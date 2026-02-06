import "package:supabase_flutter/supabase_flutter.dart";

import "../../../core/error/app_error.dart";
import "../../../core/logger/app_logger.dart";
import "../model/signin_model.dart";

abstract class ISigninRepository {
  Future<void> signin(String email);
  Future<void> sendOtp(SendOtpRequest request);
}

class SigninRepository implements ISigninRepository {
  final SupabaseClient _supabaseClient;
  final IAppLogger _appLogger;
  const SigninRepository(this._supabaseClient, this._appLogger);

  @override
  Future<void> signin(String email) async {
    try {
      _supabaseClient.auth.signInWithOtp(email: email);
    } catch (e, s) {
      _appLogger.e("unknown error", error: e, stackTrace: s);
      if (e is AuthApiException && e.statusCode == "429") {
        throw TooManyRequestException(
          message: "Too many sign in request. Please try again later.",
        );
      }
      throw UnknownException(message: "supabase signin error", rawError: e);
    }
  }

  @override
  Future<void> sendOtp(SendOtpRequest request) async {
    try {
      _supabaseClient.auth.verifyOTP(
        type: OtpType.email,
        token: request.otp,
        email: request.email,
      );
    } catch (e, s) {
      _appLogger.e("unknown error", error: e, stackTrace: s);
      throw UnknownException(
        message: "supabase sending otp error",
        rawError: e,
      );
    }
  }
}
