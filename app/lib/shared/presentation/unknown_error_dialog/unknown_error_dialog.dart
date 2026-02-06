import "package:flutter/material.dart";

import "../alert_dialog/shared_alert_dialog.dart";

class UnknownErrorDialog extends StatelessWidget {
  const UnknownErrorDialog({super.key, this.errorMessage});

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return SharedAlertDialog(
      title: "Unknown Error",
      message: errorMessage ?? "Unknown Error",
    );
  }
}
