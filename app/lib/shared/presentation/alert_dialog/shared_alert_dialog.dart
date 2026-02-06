import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

import "model/shared_alert_dialog_model.dart";

class SharedAlertDialog extends StatelessWidget {
  const SharedAlertDialog({
    super.key,
    required this.title,
    this.message,
    this.child,
    this.actions,
  });

  final String title;
  final String? message;
  final Widget? child;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      content:
          child ??
          (message == null
              ? null
              : Text(message!, style: Theme.of(context).textTheme.bodyMedium)),
      actions:
          actions ??
          [SharedAlertDialogCancelButton(), SharedAlertDialogOKButton()],
    );
  }
}

class SharedAlertDialogOKButton extends StatelessWidget {
  const SharedAlertDialogOKButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SharedAlertDialogButton(
      onPressed:
          onPressed ??
          () {
            context.pop(SharedPopResult<void>(type: SharedPopResultType.ok));
          },
      title: "OK",
    );
  }
}

class SharedAlertDialogCancelButton extends StatelessWidget {
  const SharedAlertDialogCancelButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SharedAlertDialogButton(
      onPressed:
          onPressed ??
          () {
            context.pop(
              SharedPopResult<void>(type: SharedPopResultType.cancel),
            );
          },
      title: "Cancel",
    );
  }
}

class SharedAlertDialogButton extends StatelessWidget {
  const SharedAlertDialogButton({
    super.key,
    required this.title,
    this.onPressed,
  });

  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(title, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}
