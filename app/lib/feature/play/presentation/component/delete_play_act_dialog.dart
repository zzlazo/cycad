import "package:flutter/material.dart";

import "../../../../shared/presentation/alert_dialog/shared_alert_dialog.dart";

class DeletePlayActDialog extends StatelessWidget {
  const DeletePlayActDialog({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SharedAlertDialog(
      title: "Delete $title?",
      message: "Delete this act and all its data?",
    );
  }
}
