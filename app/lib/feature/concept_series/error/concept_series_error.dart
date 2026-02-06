import "../../../core/error/app_error.dart";

class PlayProjectExistException extends AppException {
  const PlayProjectExistException({
    String message =
        "A play project connected to this series exists. You cannot edit this series.",
    Object? rawError,
    StackTrace? stackTrace,
  }) : super(message, rawError: rawError, stackTrace: stackTrace);
}
