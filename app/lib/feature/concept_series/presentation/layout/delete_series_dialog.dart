import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../shared/presentation/alert_dialog/shared_alert_dialog.dart";

class DeleteSeriesDialog extends ConsumerWidget {
  const DeleteSeriesDialog({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SharedAlertDialog(
      title: "Confirm Delete",
      message:
          "Are you sure you want to delete $title series? This action cannot be undone.",
    );
  }
}
