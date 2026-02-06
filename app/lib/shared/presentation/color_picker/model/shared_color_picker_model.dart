import "package:flutter/rendering.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "shared_color_picker_model.freezed.dart";

@freezed
abstract class SharedColorPickerConfig with _$SharedColorPickerConfig {
  const factory SharedColorPickerConfig({
    String? title,
    required void Function(Color color) onColorChanged,
    Color? initialValue,
  }) = _SharedColorPickerConfig;
}
