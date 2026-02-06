import "package:freezed_annotation/freezed_annotation.dart";

part "shared_drop_down_menu_model.freezed.dart";

@freezed
abstract class SharedDropDownMenuEntryModel<T>
    with _$SharedDropDownMenuEntryModel<T> {
  const factory SharedDropDownMenuEntryModel({
    required T value,
    required String label,
  }) = _SharedDropDownMenuEntryModel<T>;
}
