import "package:flutter/material.dart";

import "../icon_button/shared_icon_button.dart";

class SharedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool canPop;
  final Widget? titleWidget;

  const SharedAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.canPop = true,
    this.titleWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: titleWidget ?? SharedAppBarTitle(title: title),
      leading: canPop ? leading : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class SharedAppBarTitle extends StatelessWidget {
  final String title;
  const SharedAppBarTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.headlineSmall);
  }
}

class SharedAppBarSaveButton extends StatelessWidget {
  const SharedAppBarSaveButton({super.key, required this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SharedIconButton(onPressed: onPressed, iconData: Icons.check);
  }
}
