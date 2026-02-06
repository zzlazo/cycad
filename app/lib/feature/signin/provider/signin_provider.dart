// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:supabase_flutter/supabase_flutter.dart";

import "../../../core/application/provider/core_provider.dart";
import "../../../core/model/core_model.dart";
import "../../../plugins/supabase/application/provider/plugin_supabase_provider.dart";
import "../model/signin_model.dart";
import "../repository/signin_repository.dart";

part "signin_provider.g.dart";

@riverpod
ISigninRepository signinRepository(Ref ref) {
  return SigninRepository(
    ref.read(supabaseClientProvider),
    ref.read(appLoggerProvider),
  );
}

@riverpod
class SigninAsyncNotifier extends _$SigninAsyncNotifier {
  @override
  AsyncValue<void> build() {
    return AsyncData(null);
  }

  Future<void> signin(String email) async {
    state = AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(asyncJobDispatcherProvider)
          .trackJob(
            AsyncJobQueue(
              id: "signin",
              type: AsyncJobType.modify,
              job: () async {
                await ref.read(signinRepositoryProvider).signin(email);
              },
            ),
          );
    });
  }

  Future<void> sendOtp(SendOtpRequest request) async {
    state = AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(asyncJobDispatcherProvider)
          .trackJob(
            AsyncJobQueue(
              id: "signin",
              type: AsyncJobType.modify,
              job: () async {
                await ref.read(signinRepositoryProvider).sendOtp(request);
              },
            ),
          );
    });
  }
}

@riverpod
void listenAuthState(Ref ref) {
  ref
      .read(supabaseClientProvider)
      .auth
      .onAuthStateChange
      .listen(
        (authState) {
          if (authState.event == AuthChangeEvent.signedIn) {
            if (authState.session != null) {
              ref
                  .read(authUserNotifierProvider.notifier)
                  .set(
                    PlayingUser(
                      id: authState.session!.user.id,
                      email: authState.session!.user.email!,
                    ),
                  );
            } else {
              ref
                  .read(globalErrorDialogNotifierProvider.notifier)
                  .set("invalid session");
            }
          }
        },
        onError: (e, s) {
          ref.read(appLoggerProvider).e("auth unknown error");
          ref
              .read(globalErrorDialogNotifierProvider.notifier)
              .set("auth error");
        },
      );
}

@riverpod
PlayingUser? initialCurrentUser(Ref ref) {
  throw UnimplementedError();
}

@riverpod
class CurrentAuthDataNotifier extends _$CurrentAuthDataNotifier {
  @override
  AuthData build() {
    return AuthData();
  }

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setOtp(String otp) {
    state = state.copyWith(otp: otp);
  }

  void clear() {
    state = AuthData();
  }
}
