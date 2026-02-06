import "dart:ui" as ui;

import "package:archive/archive.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:share_plus/share_plus.dart";
import "package:supabase_flutter/supabase_flutter.dart";

import "../../../core/error/app_error.dart";
import "../../../core/logger/app_logger.dart";
import "../../../shared/repository/repository_utility.dart";
import "../error/concept_series_error.dart";
import "../model/model/concept_series_model.dart";
import "../model/request/concept_series_request_model.dart";
import "../presentation/component/series_preview.dart";

abstract class ConceptSeriesRepository {
  Future<GetCardConceptSeriesListResponse> getSeriesList(
    GetCardConceptSeriesListRequest request,
  );
  Future<CardConceptSeries> getSeries(GetCardConceptSeriesRequest request);
  Future<int> createSeries(CreateCardConceptSeriesRequest request);
  Future<void> updateSeries(UpdateCardConceptSeriesRequest request);
  Future<void> deleteSeries(DeleteCardConceptSeriesRequest request);
  Future<GetCardConceptSeriesPresetListResponse> getPresetList();
  Future<GetCardConceptSeriesPresetResponse> getPreset(
    GetCardConceptSeriesPresetRequest request,
  );
  Future<XFile> export(ExportCardConceptSeriesPresetRequest request);
  Future<bool> checkExistSeriesPlay(CheckExistSeriesPlayRequest request);
}

class ConceptSeriesServerRepository implements ConceptSeriesRepository {
  final SupabaseClient _client;
  final IAppLogger _logger;

  CardConceptSeriesRepositoryCache _cache = CardConceptSeriesRepositoryCache();

  ConceptSeriesServerRepository(this._client, this._logger);

  Future<T> _handle<T>(Future<T> Function() job, String errorMessage) async {
    return await handleJob<T>(job, errorMessage, _logger);
  }

  @override
  Future<GetCardConceptSeriesListResponse> getSeriesList(
    GetCardConceptSeriesListRequest request,
  ) async {
    return await _handle<GetCardConceptSeriesListResponse>(() async {
      final json = await _client
          .from(ServerTables.cardConceptSeries.tableName)
          .select("id, title, updated_at")
          .eq("author_id", request.userId);
      final items = json
          .map((e) => CardConceptSeriesOverview.fromJson(e))
          .toList();
      final response = GetCardConceptSeriesListResponse(series: items);

      return response;
    }, "Error occurred while getting series list");
  }

  @override
  Future<CardConceptSeries> getSeries(
    GetCardConceptSeriesRequest request,
  ) async {
    return await _handle<CardConceptSeries>(() async {
      final jsonOverView = await _client
          .from(ServerTables.cardConceptSeries.tableName)
          .select("id, title, updated_at")
          .eq("author_id", request.userId)
          .eq("id", request.id)
          .single();
      final overview = CardConceptSeriesOverview.fromJson(jsonOverView);
      final jsonConcepts = await _client
          .from(ServerTables.viewCardConceptsDetails.tableName)
          .select("id, code, concept")
          .eq("series_id", request.id)
          .eq("author_id", request.userId);
      final consepts = jsonConcepts
          .map((e) => CardConcept.fromJson(e))
          .toList();
      return CardConceptSeries(overview: overview, concepts: consepts);
    }, "Error occurred while getting series");
  }

  @override
  Future<int> createSeries(CreateCardConceptSeriesRequest request) async {
    return await _handle<int>(() async {
      final response = await _client.rpc(
        ServerFunctions.rpcCreateSeries.functionName,
        params: request.toJson(),
      );
      if (response is int) {
        return response;
      }
      throw ValidationException(message: "Creating series response is not int");
    }, "Error occurred while creating series");
  }

  @override
  Future<void> updateSeries(UpdateCardConceptSeriesRequest request) async {
    await _handle<void>(() async {
      try {
        await _client.rpc(
          ServerFunctions.rpcUpdateSeries.functionName,
          params: request.toJson(),
        );
      } catch (e) {
        if (e is PostgrestException && e.code == "23503") {
          throw PlayProjectExistException(rawError: e);
        }
      }
    }, "Error occurred while updating series");
  }

  @override
  Future<void> deleteSeries(DeleteCardConceptSeriesRequest request) async {
    await _handle<void>(() async {
      await _client.rpc(
        ServerFunctions.rpcBulkDeleteSeries.functionName,
        params: request.toJson(),
      );
    }, "Error occurred while deleting series");
  }

  @override
  Future<GetCardConceptSeriesPresetListResponse> getPresetList() async {
    if (_cache.presets != null) {
      return GetCardConceptSeriesPresetListResponse(
        presets: _cache.presets!.values.toList(),
      );
    }
    final presets = await _handle<GetCardConceptSeriesPresetListResponse>(
      () async {
        final jsonResponse = await _client
            .from(ServerTables.viewCardConceptSeriesPresetDetails.tableName)
            .select()
            .isFilter("author_id", null);
        final response = jsonResponse
            .map((e) => CardConceptSeriesPreset.fromJson(e))
            .toList();
        return GetCardConceptSeriesPresetListResponse(presets: response);
      },
      "Error occurred while getting preset codes",
    );
    _cache = _cache.copyWith(
      presets: {for (final preset in presets.presets) preset.id: preset},
    );
    return presets;
  }

  @override
  Future<GetCardConceptSeriesPresetResponse> getPreset(
    GetCardConceptSeriesPresetRequest request,
  ) async {
    if (_cache.presets?.containsKey(request.presetId) == true) {
      return GetCardConceptSeriesPresetResponse(
        preset: _cache.presets![request.presetId]!,
      );
    }
    return await _handle(() async {
      final rawResponse = await _client
          .from(ServerTables.viewCardConceptSeriesPresetDetails.tableName)
          .select("id, title, description, codes")
          .eq("id", request.presetId)
          .single();
      final response = CardConceptSeriesPreset.fromJson(rawResponse);
      _cache = _cache.copyWith(
        presets: {..._cache.presets ?? {}, response.id: response},
      );
      return GetCardConceptSeriesPresetResponse(preset: response);
    }, "Error occurred while getting preset");
  }

  @override
  Future<XFile> export(ExportCardConceptSeriesPresetRequest request) async {
    final bytes = await _createZip(request.series, request.style);
    final zipFile = await _exportAsZipFile(
      bytes,
      request.series.overview.title,
    );
    return zipFile;
  }

  Future<ui.Image> _createImage(
    CardConcept concept,
    ExportSeriesStyle style,
  ) async {
    try {
      final recorder = ui.PictureRecorder();

      final canvas = Canvas(recorder);

      final painter = CardConceptPainter(concept: concept, style: style);

      painter.paint(
        canvas,
        Size(style.size.width.toDouble(), style.size.height.toDouble()),
      );

      final picture = recorder.endRecording();
      final image = await picture.toImage(style.size.width, style.size.height);
      return image;
    } catch (e) {
      throw UnknownException(
        message: "Error occurred while creating image",
        rawError: e,
      );
    }
  }

  Future<Uint8List> _imageToBytes(ui.Image image) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) throw Exception("Failed to encode image");
    return byteData.buffer.asUint8List();
  }

  Future<List<int>> _createZip(
    CardConceptSeries series,
    ExportSeriesStyle style,
  ) async {
    final encoder = ZipEncoder();
    final archive = Archive();

    for (final CardConcept concept in series.concepts) {
      final uiImage = await _createImage(concept, style);
      final imageBytes = await _imageToBytes(uiImage);

      final fileName =
          "${series.overview.title}_${concept.code.suit.name}_${concept.code.number.name}.png";
      archive.addFile(ArchiveFile(fileName, imageBytes.length, imageBytes));

      uiImage.dispose();
    }

    return encoder.encode(archive);
  }

  Future<XFile> _exportAsZipFile(List<int> zipBytes, String fileName) async {
    final uint8List = Uint8List.fromList(zipBytes);

    return XFile.fromData(
      uint8List,
      mimeType: "application/zip",
      name: "$fileName.zip",
    );
  }

  @override
  Future<bool> checkExistSeriesPlay(CheckExistSeriesPlayRequest request) async {
    return await _handle(() async {
      final result = await _client.rpc(
        ServerFunctions.rpcCheckExistSeriesPlay.functionName,
        params: request.toJson(),
      );
      if (result is bool) {
        return result;
      }
      throw ValidationException(
        message: "Checking series play response is not bool",
      );
    }, "Error occurred while checking series play");
  }
}
