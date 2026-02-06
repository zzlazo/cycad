import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";

import "../../../../shared/presentation/base_screen/shared_app_bar.dart";
import "../../../../shared/presentation/icon_button/shared_icon_button.dart";
import "../../../../shared/presentation/text_field/shared_text_field.dart";
import "play_more_vert_button.dart";

class PlayActFormScreenAppBar extends HookWidget
    implements PreferredSizeWidget {
  final String title;
  final void Function(String newTitle)? onSaved;
  final void Function()? onDelete;

  const PlayActFormScreenAppBar({
    super.key,
    required this.title,
    this.onSaved,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final canEdit = useState(false);
    final newTitle = useState(title);
    useEffect(() {
      newTitle.value = title;
      return null;
    }, [title]);
    return SharedAppBar(
      title: newTitle.value,
      titleWidget: canEdit.value
          ? SharedTextFormField(
              initialValue: newTitle.value,
              onChanged: (text) {
                newTitle.value = text;
              },
            )
          : GestureDetector(
              child: SizedBox(
                width: double.infinity,
                child: SharedAppBarTitle(title: newTitle.value),
              ),
              onTap: () {
                canEdit.value = true;
              },
            ),
      actions: canEdit.value
          ? [
              SharedIconButton(
                iconData: Icons.check,
                onPressed: () {
                  onSaved?.call(newTitle.value);
                  canEdit.value = false;
                },
              ),
            ]
          : [PlayMoreVertButton(onDelete: onDelete)],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
