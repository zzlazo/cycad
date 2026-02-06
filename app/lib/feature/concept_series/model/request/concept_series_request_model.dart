import "package:freezed_annotation/freezed_annotation.dart";

import "../model/concept_series_model.dart";

part "concept_series_request_model.freezed.dart";
part "concept_series_request_model.g.dart";

@freezed
abstract class GetCardConceptSeriesListRequest
    with _$GetCardConceptSeriesListRequest {
  const factory GetCardConceptSeriesListRequest({required String userId}) =
      _GetCardConceptSeriesListRequest;

  factory GetCardConceptSeriesListRequest.fromJson(Map<String, Object?> json) =>
      _$GetCardConceptSeriesListRequestFromJson(json);
}

@freezed
abstract class GetCardConceptSeriesListResponse
    with _$GetCardConceptSeriesListResponse {
  const factory GetCardConceptSeriesListResponse({
    required List<CardConceptSeriesOverview> series,
  }) = _GetCardConceptSeriesListResponse;

  factory GetCardConceptSeriesListResponse.fromJson(
    Map<String, Object?> json,
  ) => _$GetCardConceptSeriesListResponseFromJson(json);
}

@freezed
abstract class GetCardConceptSeriesRequest with _$GetCardConceptSeriesRequest {
  const factory GetCardConceptSeriesRequest({
    required int id,
    required String userId,
  }) = _GetCardConceptSeriesRequest;

  factory GetCardConceptSeriesRequest.fromJson(Map<String, Object?> json) =>
      _$GetCardConceptSeriesRequestFromJson(json);
}

@freezed
abstract class GetCardConceptSeriesResponse
    with _$GetCardConceptSeriesResponse {
  const factory GetCardConceptSeriesResponse({
    required CardConceptSeries series,
  }) = _GetCardConceptSeriesResponse;

  factory GetCardConceptSeriesResponse.fromJson(Map<String, Object?> json) =>
      _$GetCardConceptSeriesResponseFromJson(json);
}

@freezed
abstract class CreateCardConceptSeriesRequest
    with _$CreateCardConceptSeriesRequest {
  const factory CreateCardConceptSeriesRequest({
    required String title,
    required List<CardConcept> concepts,
  }) = _CreateCardConceptSeriesRequest;

  factory CreateCardConceptSeriesRequest.fromJson(Map<String, Object?> json) =>
      _$CreateCardConceptSeriesRequestFromJson(json);
}

@freezed
abstract class CreateCardConceptSeriesOverviewResponse
    with _$CreateCardConceptSeriesOverviewResponse {
  const factory CreateCardConceptSeriesOverviewResponse({required int id}) =
      _CreateCardConceptSeriesOverviewResponse;

  factory CreateCardConceptSeriesOverviewResponse.fromJson(
    Map<String, Object?> json,
  ) => _$CreateCardConceptSeriesOverviewResponseFromJson(json);
}

@freezed
abstract class UpdateCardConceptSeriesRequest
    with _$UpdateCardConceptSeriesRequest {
  const factory UpdateCardConceptSeriesRequest({
    required int id,
    required String title,
    required List<CardConcept> concepts,
  }) = _UpdateCardConceptSeriesRequest;

  factory UpdateCardConceptSeriesRequest.fromJson(Map<String, Object?> json) =>
      _$UpdateCardConceptSeriesRequestFromJson(json);
}

@freezed
abstract class DeleteCardConceptSeriesRequest
    with _$DeleteCardConceptSeriesRequest {
  const factory DeleteCardConceptSeriesRequest({required List<int> idList}) =
      _DeleteCardConceptSeriesRequest;

  factory DeleteCardConceptSeriesRequest.fromJson(Map<String, Object?> json) =>
      _$DeleteCardConceptSeriesRequestFromJson(json);
}

@freezed
abstract class GetCardConceptSeriesPresetListResponse
    with _$GetCardConceptSeriesPresetListResponse {
  const factory GetCardConceptSeriesPresetListResponse({
    required List<CardConceptSeriesPreset> presets,
  }) = _GetCardConceptSeriesPresetListResponse;

  factory GetCardConceptSeriesPresetListResponse.fromJson(
    Map<String, Object?> json,
  ) => _$GetCardConceptSeriesPresetListResponseFromJson(json);
}

@freezed
abstract class ExportCardConceptSeriesPresetRequest
    with _$ExportCardConceptSeriesPresetRequest {
  const factory ExportCardConceptSeriesPresetRequest({
    required CardConceptSeries series,
    required String userId,
    required ExportSeriesStyle style,
  }) = _ExportCardConceptSeriesPresetRequest;

  factory ExportCardConceptSeriesPresetRequest.fromJson(
    Map<String, Object?> json,
  ) => _$ExportCardConceptSeriesPresetRequestFromJson(json);
}

@freezed
abstract class CardConceptSeriesRepositoryCache
    with _$CardConceptSeriesRepositoryCache {
  const factory CardConceptSeriesRepositoryCache({
    Map<int, CardConceptSeriesPreset>? presets,
  }) = _CardConceptSeriesRepositoryCache;
}

@freezed
abstract class GetCardConceptSeriesPresetRequest
    with _$GetCardConceptSeriesPresetRequest {
  const factory GetCardConceptSeriesPresetRequest({
    required String userId,
    required int presetId,
  }) = _GetCardConceptSeriesPresetRequest;

  factory GetCardConceptSeriesPresetRequest.fromJson(
    Map<String, Object?> json,
  ) => _$GetCardConceptSeriesPresetRequestFromJson(json);
}

@freezed
abstract class GetCardConceptSeriesPresetResponse
    with _$GetCardConceptSeriesPresetResponse {
  const factory GetCardConceptSeriesPresetResponse({
    required CardConceptSeriesPreset preset,
  }) = _GetCardConceptSeriesPresetResponse;

  factory GetCardConceptSeriesPresetResponse.fromJson(
    Map<String, Object?> json,
  ) => _$GetCardConceptSeriesPresetResponseFromJson(json);
}

@freezed
abstract class CheckExistSeriesPlayRequest with _$CheckExistSeriesPlayRequest {
  const factory CheckExistSeriesPlayRequest({required int id}) =
      _CheckExistSeriesPlayRequest;

  factory CheckExistSeriesPlayRequest.fromJson(Map<String, Object?> json) =>
      _$CheckExistSeriesPlayRequestFromJson(json);
}
