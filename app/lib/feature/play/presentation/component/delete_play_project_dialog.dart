import "package:flutter/material.dart";

import "../../../../shared/presentation/alert_dialog/shared_alert_dialog.dart";

class DeletePlayProjectDialog extends StatelessWidget {
  const DeletePlayProjectDialog({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SharedAlertDialog(
      title: "Delete $title?",
      message: "Delete this project and all its acts?",
    );
  }
}
