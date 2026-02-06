import "package:flutter/material.dart";

import "../../shared/presentation/alert_dialog/shared_alert_dialog.dart";
import "../../shared/presentation/modal_barrier/shared_modal_barrier.dart";

class GlobalErrorDialogOverlay extends StatelessWidget {
  const GlobalErrorDialogOverlay({
    super.key,
    required this.title,
    required this.message,
    this.onPressedOK,
  });

  final String title;
  final String message;
  final void Function()? onPressedOK;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SharedModalBarrier(),
        SharedAlertDialog(
          title: title,
          message: message,
          actions: [SharedAlertDialogOKButton(onPressed: onPressedOK)],
        ),
      ],
    );
  }
}
