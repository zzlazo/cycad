import "package:flutter/material.dart";

import "../../error_message.dart";

class SharedErrorView extends StatelessWidget {
  final String message;

  const SharedErrorView({
    super.key,
    this.message = ErrorMessage.defaultMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error_outline, size: 100),
        Text(message, style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}
