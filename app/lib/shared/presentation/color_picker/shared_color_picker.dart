import "package:flex_color_picker/flex_color_picker.dart";
import "package:flutter/material.dart";

class SharedColorPicker extends StatelessWidget {
  final void Function(Color color)? onColorChanged;
  final Color? initialValue;
  const SharedColorPicker({super.key, this.onColorChanged, this.initialValue});

  @override
  Widget build(BuildContext context) {
    return ColorPicker(
      color: initialValue ?? Theme.of(context).colorScheme.primary,
      onColorChanged: onColorChanged ?? (color) {},
      enableShadesSelection: false,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.wheel: true,
        ColorPickerType.primary: false,
        ColorPickerType.accent: false,
        ColorPickerType.both: false,
        ColorPickerType.bw: false,
        ColorPickerType.custom: false,
        ColorPickerType.customSecondary: false,
      },
    );
  }
}
