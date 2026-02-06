import "package:flutter/widgets.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../application/provider/core_provider.dart";
import "../router/router.dart";

part "router_provider.g.dart";

class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(Ref ref) {
    ref.listen(authUserNotifierProvider, (_, __) => notifyListeners());
  }
}

@riverpod
GoRouter router(Ref ref) {
  final router = GoRouter(
    routes: $appRoutes,
    debugLogDiagnostics: true,
    refreshListenable: RouterRefreshNotifier(ref),
    redirect: (context, state) async {
      return await redirect(context, state, ref.read(authUserNotifierProvider));
    },
  );
  return router;
}
