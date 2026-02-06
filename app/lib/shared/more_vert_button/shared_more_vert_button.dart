import "package:flutter/material.dart";

import "../presentation/icon_button/shared_icon_button.dart";

class SharedMoreVertButton extends StatelessWidget {
  const SharedMoreVertButton({super.key, required this.menuChildren});

  final List<Widget> menuChildren;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: menuChildren,
      builder: (context, controller, child) {
        return SharedIconButton(
          iconData: Icons.more_vert,
          onPressed: () {
            controller.open();
          },
        );
      },
    );
  }
}
