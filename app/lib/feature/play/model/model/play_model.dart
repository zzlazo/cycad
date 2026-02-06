import "package:freezed_annotation/freezed_annotation.dart";

import "../../../concept_series/model/model/concept_series_model.dart";

part "play_model.freezed.dart";
part "play_model.g.dart";

@freezed
abstract class PlayLine with _$PlayLine {
  const factory PlayLine({
    required String id,
    required int sortOrder,
    String? sceneId,
    required String actId,
    required String content,
  }) = _PlayLine;

  factory PlayLine.fromJson(Map<String, Object?> json) =>
      _$PlayLineFromJson(json);
}

@freezed
abstract class PlayScene with _$PlayScene {
  const factory PlayScene({
    required String id,
    required int sortOrder,
    required String actId,
    required Map<String, PlayLine> lines,
    required CardConcept concept,
  }) = _PlayScene;

  factory PlayScene.fromJson(Map<String, Object?> json) =>
      _$PlaySceneFromJson(json);
}

@freezed
abstract class PlayAct with _$PlayAct {
  const factory PlayAct({
    required PlayActOverview overview,
    @Default({}) Map<String, PlayLine> lines,
    @Default({}) Map<String, PlayScene> scenes,
  }) = _PlayAct;

  factory PlayAct.fromJson(Map<String, Object?> json) =>
      _$PlayActFromJson(json);
}

@freezed
abstract class PlayActOverview with _$PlayActOverview {
  const factory PlayActOverview({
    required String id,
    required int sortOrder,
    required String playId,
    required DateTime updatedAt,
    required String title,
  }) = _PlayActOverview;

  factory PlayActOverview.fromJson(Map<String, Object?> json) =>
      _$PlayActOverviewFromJson(json);
}

@freezed
abstract class PlayActOverviewViewModel with _$PlayActOverviewViewModel {
  const factory PlayActOverviewViewModel({
    required String title,
    required String updatedAt,
  }) = _PlayActOverviewViewModel;
}

@freezed
abstract class PlayProjectOverview with _$PlayProjectOverview {
  const factory PlayProjectOverview({
    required String id,
    required String title,
    required int seriesId,
    required DateTime updatedAt,
  }) = _PlayProjectOverview;

  factory PlayProjectOverview.fromJson(Map<String, Object?> json) =>
      _$PlayProjectOverviewFromJson(json);
}

@freezed
abstract class PlayProjectOverviewViewModel
    with _$PlayProjectOverviewViewModel {
  const factory PlayProjectOverviewViewModel({
    required String title,
    required String updatedAt,
  }) = _PlayProjectOverviewViewModel;
}

@freezed
abstract class PlayProject with _$PlayProject {
  const factory PlayProject({
    required PlayProjectOverview overview,
    @Default({}) Map<String, PlayAct> acts,
  }) = _PlayProject;

  factory PlayProject.fromJson(Map<String, Object?> json) =>
      _$PlayProjectFromJson(json);
}

@freezed
abstract class UpdateProjectFormModel with _$UpdateProjectFormModel {
  const factory UpdateProjectFormModel({String? title, int? seriesId}) =
      _UpdateProjectFormModel;
}
