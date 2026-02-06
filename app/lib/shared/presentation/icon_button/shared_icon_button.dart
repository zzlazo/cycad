import "package:flutter/material.dart";

class SharedIconButton extends StatelessWidget {
  const SharedIconButton({super.key, required this.iconData, this.onPressed});

  final VoidCallback? onPressed;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onPressed, icon: Icon(iconData));
  }
}
