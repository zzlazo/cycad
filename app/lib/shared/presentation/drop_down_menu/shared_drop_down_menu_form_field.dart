import "package:flutter/material.dart";

import "model/shared_drop_down_menu_model.dart";

class SharedDropDownMenuFormField<T> extends StatelessWidget {
  const SharedDropDownMenuFormField({
    super.key,
    required this.entries,
    this.onSelected,
    this.enabled = true,
    this.initialSelection,
    this.hintText,
    this.width,
  });

  final List<SharedDropDownMenuEntryModel<T>> entries;
  final void Function(T? value)? onSelected;
  final bool enabled;
  final T? initialSelection;
  final String? hintText;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return DropdownMenuFormField<T>(
      width: width,
      hintText: hintText,
      initialSelection: initialSelection,
      onSelected: onSelected,
      enabled: enabled,
      dropdownMenuEntries: entries
          .map(
            (entry) =>
                DropdownMenuEntry<T>(value: entry.value, label: entry.label),
          )
          .toList(),
    );
  }
}
