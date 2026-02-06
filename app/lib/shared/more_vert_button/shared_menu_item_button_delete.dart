import "package:flutter/material.dart";

import "shared_menu_item_button.dart";

class SharedMenuItemButtonDelete extends StatelessWidget {
  const SharedMenuItemButtonDelete({super.key, this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SharedMenuItemButton(label: "delete", onPressed: onPressed);
  }
}
