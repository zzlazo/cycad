import "package:flex_color_picker/flex_color_picker.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:go_router/go_router.dart";

import "../alert_dialog/model/shared_alert_dialog_model.dart";
import "../alert_dialog/shared_alert_dialog.dart";
import "shared_color_picker.dart";

class SharedColorPickerDialog extends StatelessWidget {
  const SharedColorPickerDialog({super.key, this.initialColorCode});

  final String? initialColorCode;

  @override
  Widget build(BuildContext context) {
    final selectedColor = useState<Color?>(initialColorCode?.toColor);
    return SharedAlertDialog(
      title: "Color Picker",
      actions: [
        SharedAlertDialogCancelButton(
          onPressed: () {
            context.pop(
              SharedPopResult<Color?>(type: SharedPopResultType.cancel),
            );
          },
        ),
        SharedAlertDialogOKButton(
          onPressed: () {
            context.pop(
              SharedPopResult<Color?>(
                type: SharedPopResultType.ok,
                value: selectedColor.value,
              ),
            );
          },
        ),
      ],
      child: SharedColorPicker(
        onColorChanged: (color) {
          selectedColor.value = color;
        },
        initialValue: selectedColor.value,
      ),
    );
  }
}
