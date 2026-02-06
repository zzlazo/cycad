import "package:freezed_annotation/freezed_annotation.dart";

part "shared_alert_dialog_model.freezed.dart";

enum SharedPopResultType { ok, cancel }

@freezed
abstract class SharedPopResult<T> with _$SharedPopResult<T> {
  const factory SharedPopResult({required SharedPopResultType type, T? value}) =
      _SharedPopResult<T>;
}
