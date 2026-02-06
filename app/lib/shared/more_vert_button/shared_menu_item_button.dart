import "package:flutter/material.dart";

class SharedMenuItemButton extends StatelessWidget {
  const SharedMenuItemButton({super.key, required this.label, this.onPressed});

  final String label;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      onPressed: onPressed,
      child: Text(label, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}
