import "package:freezed_annotation/freezed_annotation.dart";

part "core_model.freezed.dart";

@freezed
abstract class PlayingUser with _$PlayingUser {
  const factory PlayingUser({
    required String id,
    required String email,
    String? name,
    String? avatarUrl,
  }) = _PlayingUser;
}

const Map<String, String> mimeTypes = {
  // 画像
  "jpg": "image/jpeg",
  "jpeg": "image/jpeg",
  "png": "image/png",
  "gif": "image/gif",
  "webp": "image/webp",

  // 動画・音声
  "mp4": "video/mp4",
  "mov": "video/quicktime",
  "mp3": "audio/mpeg",
  "wav": "audio/wav",

  // ドキュメント・データ
  "pdf": "application/pdf",
  "json": "application/json",
  "txt": "text/plain",
  "zip": "application/zip",
};

String getMimeTypeFromFileName(String fileName) {
  final parts = fileName.split(".");
  if (parts.length <= 1) {
    return "application/octet-stream";
  }
  final extension = parts.last.toLowerCase();
  return mimeTypes[extension] ?? "application/octet-stream";
}

enum AsyncJobType { get, modify }

@freezed
abstract class AsyncJobStatus with _$AsyncJobStatus {
  const factory AsyncJobStatus({
    @Default(false) bool isLoading,
    @Default(false) bool hasError,
    @Default(false) bool showLoading,
    String? errorMessage,
  }) = _AsyncJobStatus;
}

@freezed
abstract class AsyncJobQueue<T> with _$AsyncJobQueue<T> {
  const factory AsyncJobQueue({
    required String id,
    bool? showLoading,
    required AsyncJobType type,
    required Future<T> Function() job,
  }) = _AsyncJobQueue<T>;
}

@freezed
abstract class GlobalErrorDialogModel with _$GlobalErrorDialogModel {
  const factory GlobalErrorDialogModel({required String errorMessage}) =
      _GlobalErrorDialogModel;
}

@freezed
abstract class AuthTimerModel with _$AuthTimerModel {
  const AuthTimerModel._();
  const factory AuthTimerModel({required int seconds}) = _AuthTimerModel;
  bool get canResend => seconds == 0;
}

sealed class AsyncJobResult<T> {
  const AsyncJobResult();
}

class AsyncJobSuccess<T> extends AsyncJobResult<T> {
  final T value;
  const AsyncJobSuccess(this.value);
}

class AsyncJobFailure<T> extends AsyncJobResult<T> {
  final Object error;
  const AsyncJobFailure(this.error);
}
