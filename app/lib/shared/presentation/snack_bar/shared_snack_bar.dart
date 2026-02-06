import "package:flutter/material.dart";

class SharedSnackBarContent extends StatelessWidget {
  const SharedSnackBarContent({
    super.key,
    required this.icon,
    required this.message,
  });

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Expanded(
          child: Text(message, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }
}

class _SharedSnackBarBase extends SnackBar {
  _SharedSnackBarBase({required IconData icon, required String message})
    : super(
        content: SharedSnackBarContent(icon: icon, message: message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      );
}

class SharedInformationSnackBar extends _SharedSnackBarBase {
  SharedInformationSnackBar({required super.message})
    : super(icon: Icons.info_outline);
}

class SharedErrorSnackBar extends _SharedSnackBarBase {
  SharedErrorSnackBar({required super.message}) : super(icon: Icons.error);
}
