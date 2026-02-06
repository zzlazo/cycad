import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class SharedTextFormField extends HookConsumerWidget {
  const SharedTextFormField({
    super.key,
    this.formKey,
    this.textEditingController,
    this.hintText,
    this.onChanged,
    this.maxLines,
    this.validator,
    this.initialValue,
    this.keyboardType,
    this.focusNode,
  });

  final Key? formKey;

  final TextEditingController? textEditingController;
  final String? hintText;
  final void Function(String text)? onChanged;
  final int? maxLines;
  final String? Function(String? text)? validator;
  final String? initialValue;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      focusNode: focusNode,
      key: formKey,
      decoration: InputDecoration(hintText: hintText),
      controller: textEditingController,
      onChanged: onChanged,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      initialValue: initialValue,
    );
  }
}
