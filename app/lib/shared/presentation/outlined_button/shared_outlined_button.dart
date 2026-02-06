import "package:flutter/material.dart";

class SharedOutlinedButton extends StatelessWidget {
  const SharedOutlinedButton({
    super.key,
    this.onPressed,
    required this.iconData,
    this.label,
  });

  final void Function()? onPressed;
  final IconData iconData;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData, color: Theme.of(context).textTheme.titleSmall?.color),
          if (label != null)
            Text(label!, style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}
