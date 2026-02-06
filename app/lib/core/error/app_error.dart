class AppException implements Exception {
  final String message;
  final Object? rawError;
  final StackTrace? stackTrace;

  const AppException(this.message, {this.rawError, this.stackTrace});

  @override
  String toString() => "AppException: $message";
}

class UnknownException extends AppException {
  const UnknownException({
    String message = "unknown error",
    Object? rawError,
    StackTrace? stackTrace,
  }) : super(message, rawError: rawError, stackTrace: stackTrace);
}

class UserServerAuthFailed extends AppException {
  const UserServerAuthFailed({
    String message = "User auth failed on server",
    Object? rawError,
    StackTrace? stackTrace,
  }) : super(message, rawError: rawError, stackTrace: stackTrace);
}

class ServerException extends AppException {
  const ServerException({
    String message = "server error",
    Object? rawError,
    StackTrace? stackTrace,
  }) : super(message, rawError: rawError, stackTrace: stackTrace);
}

class NetworkException extends AppException {
  const NetworkException({
    String message = "network error",
    Object? rawError,
    StackTrace? stackTrace,
  }) : super(message, rawError: rawError, stackTrace: stackTrace);
}

class DataNotFoundException extends AppException {
  const DataNotFoundException({
    String message = "data not found",
    Object? rawError,
    StackTrace? stackTrace,
  }) : super(message, rawError: rawError, stackTrace: stackTrace);
}

class TooManyRequestException extends AppException {
  const TooManyRequestException({
    String message = "Too many request. Please try again later.",
    Object? rawError,
    StackTrace? stackTrace,
  }) : super(message, rawError: rawError, stackTrace: stackTrace);
}

class ValidationException extends AppException {
  const ValidationException({
    String message = "invalid value or input",
    Object? rawError,
    StackTrace? stackTrace,
  }) : super(message, rawError: rawError, stackTrace: stackTrace);
}
