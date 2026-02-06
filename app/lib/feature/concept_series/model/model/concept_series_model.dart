import "package:flutter/material.dart";
import "package:freezed_annotation/freezed_annotation.dart";

import "../../../../shared/model/card/model/shared_card_model.dart";
import "../../../../shared/model/json_converter/shared_json_color_converter.dart";
import "../../../../shared/model/json_converter/shared_json_text_style_converter.dart";

part "concept_series_model.freezed.dart";
part "concept_series_model.g.dart";

@freezed
abstract class CardConceptSeriesOverview with _$CardConceptSeriesOverview {
  const factory CardConceptSeriesOverview({
    required int id,
    required String title,
    required DateTime updatedAt,
  }) = _CardConceptSeriesOverview;

  factory CardConceptSeriesOverview.fromJson(Map<String, Object?> json) =>
      _$CardConceptSeriesOverviewFromJson(json);
}

@freezed
abstract class CardConceptSeriesOverviewListItemModel
    with _$CardConceptSeriesOverviewListItemModel {
  const factory CardConceptSeriesOverviewListItemModel({
    required int id,
    required String title,
    required String updatedAt,
  }) = _CardConceptSeriesOverviewListItemModel;

  factory CardConceptSeriesOverviewListItemModel.fromJson(
    Map<String, Object?> json,
  ) => _$CardConceptSeriesOverviewListItemModelFromJson(json);
}

@freezed
abstract class CardConceptSeries with _$CardConceptSeries {
  const factory CardConceptSeries({
    required CardConceptSeriesOverview overview,
    required List<CardConcept> concepts,
  }) = _CardConceptSeries;

  factory CardConceptSeries.fromJson(Map<String, Object?> json) =>
      _$CardConceptSeriesFromJson(json);
}

@freezed
abstract class ConceptSeriesExportCardSize with _$ConceptSeriesExportCardSize {
  const ConceptSeriesExportCardSize._();
  const factory ConceptSeriesExportCardSize({
    required int width,
    required int height,
  }) = _ConceptSeriesExportCardSize;

  Size get toSize => Size(width.toDouble(), height.toDouble());

  factory ConceptSeriesExportCardSize.fromJson(Map<String, Object?> json) =>
      _$ConceptSeriesExportCardSizeFromJson(json);
}

@freezed
abstract class ExportSeriesStyle with _$ExportSeriesStyle {
  const ExportSeriesStyle._();
  const factory ExportSeriesStyle({
    @SharedJsonColorConverter() required Color backgroundColor,
    required int padding,
    required ConceptSeriesExportCardSize size,
    @SharedJsonTextStyleConverter() required TextStyle bodyStyle,
    @SharedJsonTextStyleConverter() required TextStyle codeStyle,
  }) = _ExportSeriesStyle;

  factory ExportSeriesStyle.fromJson(Map<String, Object?> json) =>
      _$ExportSeriesStyleFromJson(json);
}

@freezed
abstract class CardConcept with _$CardConcept {
  const factory CardConcept({
    required int id,
    required CardCode code,
    required String concept,
  }) = _CardConcept;

  factory CardConcept.fromJson(Map<String, Object?> json) =>
      _$CardConceptFromJson(json);
}

@freezed
abstract class CardConceptSeriesLoadState with _$CardConceptSeriesLoadState {
  const factory CardConceptSeriesLoadState({
    required CardConceptSeries series,
    required bool hasValue,
  }) = _CardConceptSeriesLoadState;

  factory CardConceptSeriesLoadState.fromJson(Map<String, Object?> json) =>
      _$CardConceptSeriesLoadStateFromJson(json);
}

@freezed
abstract class CardConceptSeriesPreset with _$CardConceptSeriesPreset {
  const factory CardConceptSeriesPreset({
    required int id,
    required String title,
    required String description,
    required List<CardCode> codes,
  }) = _CardConceptSeriesPreset;

  factory CardConceptSeriesPreset.fromJson(Map<String, Object?> json) =>
      _$CardConceptSeriesPresetFromJson(json);
}
