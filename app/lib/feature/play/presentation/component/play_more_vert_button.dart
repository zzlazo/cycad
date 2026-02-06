import "package:flutter/material.dart";

import "../../../../shared/more_vert_button/shared_menu_item_button_delete.dart";
import "../../../../shared/more_vert_button/shared_more_vert_button.dart";

class PlayMoreVertButton extends StatelessWidget {
  const PlayMoreVertButton({super.key, this.onDelete});

  final void Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return SharedMoreVertButton(
      menuChildren: [SharedMenuItemButtonDelete(onPressed: onDelete)],
    );
  }
}
