import "dart:async";

import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:logger/logger.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:uuid/uuid.dart";

import "../../../feature/signin/provider/signin_provider.dart";
import "../../../plugins/supabase/application/provider/plugin_supabase_provider.dart";
import "../../logger/app_logger.dart";
import "../../model/core_model.dart";
import "../service/async_job_dispatcher.dart";

part "core_provider.g.dart";

@riverpod
class AuthUserNotifier extends _$AuthUserNotifier {
  @override
  PlayingUser? build() {
    return ref.read(initialCurrentUserProvider);
  }

  void set(PlayingUser user) {
    state = user;
  }
}

@riverpod
PlayingUser currentPlayingUser(Ref ref) {
  return ref.watch(authUserNotifierProvider)!;
}

@riverpod
void appKeepAlive(Ref ref) {
  ref.watch(pluginSupabaseKeepAliveProvider);
  ref.watch(initialCurrentUserProvider);
  ref.watch(appLoggerProvider);
  ref.watch(authUserNotifierProvider);
  ref.watch(listenAuthStateProvider);
  ref.watch(currentAuthDataNotifierProvider);
  ref.listen(asyncJobStatusStreamProvider, (previous, next) {
    if (next.hasValue && next.value!.hasError) {
      ref
          .read(globalErrorDialogNotifierProvider.notifier)
          .set(next.value!.errorMessage);
    }
  });
  ref.watch(authTimerProvider);
}

@riverpod
IAppLogger appLogger(Ref ref) => AppLogger(Logger());

@riverpod
IASyncJobDispatcher asyncJobDispatcher(Ref ref) => AsyncJobDispatcher();

@riverpod
Stream<AsyncJobStatus> asyncJobStatusStream(Ref ref) {
  return ref.watch(asyncJobDispatcherProvider).statusStream;
}

@riverpod
bool showGlobalLoading(Ref ref) {
  final current = ref.watch(asyncJobStatusStreamProvider).valueOrNull;
  final show = current?.isLoading == true && current?.showLoading == true;
  return show;
}

@riverpod
class GlobalErrorDialogNotifier extends _$GlobalErrorDialogNotifier {
  @override
  String? build() {
    return null;
  }

  void set(String? message) {
    state = message;
  }

  void clear() {
    state = null;
  }
}

@riverpod
class AuthTimer extends _$AuthTimer {
  Timer? _timer;

  @override
  AuthTimerModel build() {
    ref.onDispose(() => _timer?.cancel());
    return AuthTimerModel(seconds: 0);
  }

  void startTimer() {
    _timer?.cancel();
    state = AuthTimerModel(seconds: 60);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.seconds > 0) {
        state = state.copyWith(seconds: state.seconds - 1);
      } else {
        timer.cancel();
      }
    });
  }
}

@riverpod
Uuid uuid(Ref ref) => const Uuid();
