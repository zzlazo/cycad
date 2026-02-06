import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";

import "../../../../shared/presentation/icon_button/shared_icon_button.dart";
import "../../../../shared/presentation/text_field/shared_text_field.dart";
import "../../model/model/play_model.dart";

class PlayLineForm extends HookWidget {
  const PlayLineForm({
    super.key,
    required this.line,
    this.onSaved,
    this.onDelete,
    this.textEditingController,
    this.onBlur,
  });

  final PlayLine line;
  final void Function(String text)? onSaved;
  final void Function()? onDelete;
  final TextEditingController? textEditingController;
  final void Function(String text)? onBlur;

  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode();
    final formController =
        textEditingController ?? useTextEditingController(text: line.content);

    useEffect(() {
      void listener() {
        if (!focusNode.hasFocus) {
          onBlur?.call(formController.text);
        }
      }

      focusNode.addListener(listener);
      return () => focusNode.removeListener(listener);
    }, [focusNode]);
    useListenable(focusNode);
    return Row(
      spacing: 10,
      children: [
        Expanded(
          child: SharedTextFormField(
            textEditingController: formController,
            focusNode: focusNode,
          ),
        ),
        focusNode.hasFocus
            ? SharedIconButton(
                iconData: Icons.check,
                onPressed: onSaved == null
                    ? null
                    : () => onSaved!(formController.text),
              )
            : SharedIconButton(iconData: Icons.close, onPressed: onDelete),
      ],
    );
  }
}
