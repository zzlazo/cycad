import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../core/application/provider/core_provider.dart";
import "../../../../plugins/supabase/application/provider/plugin_supabase_provider.dart";
import "../../model/model/concept_series_model.dart";
import "../../model/request/concept_series_request_model.dart";
import "../../repository/concept_series_repository.dart";

part "concept_series_provider.g.dart";

@riverpod
ConceptSeriesRepository conceptSeriesRepository(Ref ref) {
  return ConceptSeriesServerRepository(
    ref.read(supabaseClientProvider),
    ref.read(appLoggerProvider),
  );
}

@riverpod
GetCardConceptSeriesListRequest getCardConceptSeriesListRequest(Ref ref) {
  return GetCardConceptSeriesListRequest(
    userId: ref.read(currentPlayingUserProvider).id,
  );
}

@riverpod
Future<GetCardConceptSeriesListResponse> getConceptSeriesList(Ref ref) async {
  final response = await ref
      .read(conceptSeriesRepositoryProvider)
      .getSeriesList(ref.watch(getCardConceptSeriesListRequestProvider));
  return response;
}

@riverpod
GetCardConceptSeriesRequest getCardConceptSeriesRequest(Ref ref, int id) {
  return GetCardConceptSeriesRequest(
    id: id,
    userId: ref.read(currentPlayingUserProvider).id,
  );
}

@riverpod
Future<CardConceptSeries> getConceptSeries(Ref ref, int id) async {
  final response = await ref
      .read(conceptSeriesRepositoryProvider)
      .getSeries(ref.watch(getCardConceptSeriesRequestProvider(id)));

  return response;
}

@riverpod
GetCardConceptSeriesPresetRequest getCardConceptSeriesPresetRequest(
  Ref ref,
  int presetId,
) {
  return GetCardConceptSeriesPresetRequest(
    userId: ref.read(currentPlayingUserProvider).id,
    presetId: presetId,
  );
}

@riverpod
Future<GetCardConceptSeriesPresetResponse> getCardConceptSeriesPreset(
  Ref ref,
  int presetId,
) async {
  final result = ref
      .read(conceptSeriesRepositoryProvider)
      .getPreset(
        ref.watch(getCardConceptSeriesPresetRequestProvider(presetId)),
      );

  return result;
}

@riverpod
class PreviewCardConceptSeriesNotifier
    extends _$PreviewCardConceptSeriesNotifier {
  @override
  CardConceptSeries? build() {
    return null;
  }

  void set(CardConceptSeries series) {
    state = series;
  }
}

@riverpod
void conceptSeriesKeepAlive(Ref ref) {
  ref.watch(previewCardConceptSeriesNotifierProvider);
  ref.watch(conceptSeriesRepositoryProvider);
}

@riverpod
Future<GetCardConceptSeriesPresetListResponse> getCardConceptSeriesPresetList(
  Ref ref,
) async {
  final result = await ref
      .read(conceptSeriesRepositoryProvider)
      .getPresetList();
  return result;
}

@riverpod
Future<bool> checkExistSeriesPlay(Ref ref, int id) async {
  final response = await ref
      .read(conceptSeriesRepositoryProvider)
      .checkExistSeriesPlay(CheckExistSeriesPlayRequest(id: id));
  return response;
}
