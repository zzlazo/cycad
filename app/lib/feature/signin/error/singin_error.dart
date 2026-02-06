import "../../../core/error/app_error.dart";

class SigninResponseValueError extends AppException {
  final List<String> invalidValues;
  SigninResponseValueError({required this.invalidValues})
    : super("invalid signin response values: ${invalidValues.join(", ")}");
}

class AuthException extends AppException {
  const AuthException({String message = "auth error", Object? rawError})
    : super(message);
}
