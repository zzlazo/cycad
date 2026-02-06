import "package:freezed_annotation/freezed_annotation.dart";

part "signin_model.freezed.dart";

@freezed
abstract class SigninResponse with _$SigninResponse {
  const factory SigninResponse({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required String email,
  }) = _SigninResponse;
}

@freezed
abstract class SendOtpRequest with _$SendOtpRequest {
  const factory SendOtpRequest({required String email, required String otp}) =
      _SendOtpRequest;
}

@freezed
abstract class AuthData with _$AuthData {
  const factory AuthData({String? email, String? otp}) = _AuthDatat;
}
