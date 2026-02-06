import "package:freezed_annotation/freezed_annotation.dart";

import "../../../concept_series/model/model/concept_series_model.dart";
import "../model/play_model.dart";

part "play_request_model.freezed.dart";
part "play_request_model.g.dart";

@freezed
abstract class GetPlaySeriesListRequest with _$GetPlaySeriesListRequest {
  const factory GetPlaySeriesListRequest({required String userId}) =
      _GetPlaySeriesListRequest;

  factory GetPlaySeriesListRequest.fromJson(Map<String, Object?> json) =>
      _$GetPlaySeriesListRequestFromJson(json);
}

@freezed
abstract class GetPlaySeriesListResponse with _$GetPlaySeriesListResponse {
  const factory GetPlaySeriesListResponse({
    required List<CardConceptSeriesOverview> overviews,
  }) = _GetPlaySeriesListResponse;

  factory GetPlaySeriesListResponse.fromJson(Map<String, Object?> json) =>
      _$GetPlaySeriesListResponseFromJson(json);
}

@freezed
abstract class GetPlayProjectListRequest with _$GetPlayProjectListRequest {
  const factory GetPlayProjectListRequest({required String userId}) =
      _GetPlayProjectListRequest;

  factory GetPlayProjectListRequest.fromJson(Map<String, Object?> json) =>
      _$GetPlayProjectListRequestFromJson(json);
}

@freezed
abstract class GetPlayProjectListResponse with _$GetPlayProjectListResponse {
  const factory GetPlayProjectListResponse({
    required List<PlayProjectOverview> playProjects,
  }) = _GetPlayProjectListResponse;

  factory GetPlayProjectListResponse.fromJson(Map<String, Object?> json) =>
      _$GetPlayProjectListResponseFromJson(json);
}

@freezed
abstract class CreatePlayProjectRequest with _$CreatePlayProjectRequest {
  const factory CreatePlayProjectRequest({
    required String playId,
    required String title,
    required int seriesId,
  }) = _CreatePlayProjectRequest;

  factory CreatePlayProjectRequest.fromJson(Map<String, Object?> json) =>
      _$CreatePlayProjectRequestFromJson(json);
}

@freezed
abstract class GetPlayActListRequest with _$GetPlayActListRequest {
  const factory GetPlayActListRequest({
    required String userId,
    required String playId,
  }) = _GetPlayActListRequest;

  factory GetPlayActListRequest.fromJson(Map<String, Object?> json) =>
      _$GetPlayActListRequestFromJson(json);
}

@freezed
abstract class GetPlayActListResponse with _$GetPlayActListResponse {
  const factory GetPlayActListResponse({
    required List<PlayActOverview> overviews,
  }) = _GetPlayActListResponse;

  factory GetPlayActListResponse.fromJson(Map<String, Object?> json) =>
      _$GetPlayActListResponseFromJson(json);
}

@freezed
abstract class GetPlayActDetailRequest with _$GetPlayActDetailRequest {
  const factory GetPlayActDetailRequest({
    required String userId,
    required String actId,
  }) = _GetPlayActDetailRequest;

  factory GetPlayActDetailRequest.fromJson(Map<String, Object?> json) =>
      _$GetPlayActDetailRequestFromJson(json);
}

@freezed
abstract class GetPlayActDetailResponse with _$GetPlayActDetailResponse {
  const factory GetPlayActDetailResponse({required PlayAct act}) =
      _GetPlayActDetailResponse;

  factory GetPlayActDetailResponse.fromJson(Map<String, Object?> json) =>
      _$GetPlayActDetailResponseFromJson(json);
}

@freezed
abstract class UpdatePlayActDetailRequest with _$UpdatePlayActDetailRequest {
  const factory UpdatePlayActDetailRequest({required PlayAct act}) =
      _UpdatePlayActDetailRequest;

  factory UpdatePlayActDetailRequest.fromJson(Map<String, Object?> json) =>
      _$UpdatePlayActDetailRequestFromJson(json);
}

@freezed
abstract class CreatePlayActRequest with _$CreatePlayActRequest {
  const factory CreatePlayActRequest({
    required String actId,
    required String playId,
    required int sortOrder,
    required String title,
  }) = _CreatePlayActRequest;

  factory CreatePlayActRequest.fromJson(Map<String, Object?> json) =>
      _$CreatePlayActRequestFromJson(json);
}

@freezed
abstract class CreatePlayActResponse with _$CreatePlayActResponse {
  const factory CreatePlayActResponse({required PlayAct act}) =
      _CreatePlayActResponse;

  factory CreatePlayActResponse.fromJson(Map<String, Object?> json) =>
      _$CreatePlayActResponseFromJson(json);
}

@freezed
abstract class UpdatePlayActRequest with _$UpdatePlayActRequest {
  const factory UpdatePlayActRequest({
    required String actId,
    required String title,
  }) = _UpdatePlayActRequest;

  factory UpdatePlayActRequest.fromJson(Map<String, Object?> json) =>
      _$UpdatePlayActRequestFromJson(json);
}

@freezed
abstract class DeletePlayActRequest with _$DeletePlayActRequest {
  const factory DeletePlayActRequest({required String actId}) =
      _DeletePlayActRequest;

  factory DeletePlayActRequest.fromJson(Map<String, Object?> json) =>
      _$DeletePlayActRequestFromJson(json);
}

@freezed
abstract class CreatePlayLineRequest with _$CreatePlayLineRequest {
  const factory CreatePlayLineRequest({
    String? sceneId,
    required String actId,
    required String lineId,
    required int sortOrder,
    required String content,
  }) = _CreatePlayLineRequest;

  factory CreatePlayLineRequest.fromJson(Map<String, Object?> json) =>
      _$CreatePlayLineRequestFromJson(json);
}

@freezed
abstract class UpdatePlayLineRequest with _$UpdatePlayLineRequest {
  const factory UpdatePlayLineRequest({
    required String lineId,
    required String content,
  }) = _UpdatePlayLineRequest;

  factory UpdatePlayLineRequest.fromJson(Map<String, Object?> json) =>
      _$UpdatePlayLineRequestFromJson(json);
}

@freezed
abstract class DeletePlayLineRequest with _$DeletePlayLineRequest {
  const factory DeletePlayLineRequest({required String lineId}) =
      _DeletePlayLineRequest;

  factory DeletePlayLineRequest.fromJson(Map<String, Object?> json) =>
      _$DeletePlayLineRequestFromJson(json);
}

@freezed
abstract class UpdatePlayProjectRequest with _$UpdatePlayProjectRequest {
  const factory UpdatePlayProjectRequest({
    required String playId,
    required String title,
  }) = _UpdatePlayProjectRequest;

  factory UpdatePlayProjectRequest.fromJson(Map<String, Object?> json) =>
      _$UpdatePlayProjectRequestFromJson(json);
}

@freezed
abstract class DeletePlayProjectRequest with _$DeletePlayProjectRequest {
  const factory DeletePlayProjectRequest({required String playId}) =
      _DeletePlayProjectRequest;

  factory DeletePlayProjectRequest.fromJson(Map<String, Object?> json) =>
      _$DeletePlayProjectRequestFromJson(json);
}

@freezed
abstract class PullPlaySceneListRequest with _$PullPlaySceneListRequest {
  const factory PullPlaySceneListRequest({
    required String actId,
    required int sceneLength,
  }) = _PullPlaySceneListRequest;

  factory PullPlaySceneListRequest.fromJson(Map<String, Object?> json) =>
      _$PullPlaySceneListRequestFromJson(json);
}

@freezed
abstract class PullPlaySceneListResponse with _$PullPlaySceneListResponse {
  const factory PullPlaySceneListResponse({required List<PlayScene> scenes}) =
      _PullPlaySceneListResponse;

  factory PullPlaySceneListResponse.fromJson(Map<String, Object?> json) =>
      _$PullPlaySceneListResponseFromJson(json);
}
