import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:supabase_flutter/supabase_flutter.dart";

import "core/app_theme/provider/app_theme_provider.dart";
import "core/application/provider/core_provider.dart";
import "core/model/core_model.dart";
import "core/presentation/global_error_dialog_overlay.dart";
import "core/router/provider/router_provider.dart";
import "feature/signin/provider/signin_provider.dart";
import "plugins/supabase/application/provider/plugin_supabase_provider.dart";
import "plugins/supabase/index.dart";
import "shared/presentation/loading_overlay/shared_loading_overlay.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SupabaseClient supabaseClient = await initializeSupabase();
  final PlayingUser? sessionActiveUser = getSessionActiveUser(supabaseClient);

  final List<Override> providerOverrides = [
    supabaseClientProvider.overrideWithValue(supabaseClient),
    initialCurrentUserProvider.overrideWithValue(sessionActiveUser),
  ];
  if (sessionActiveUser != null) {
    providerOverrides.add(
      currentPlayingUserProvider.overrideWithValue(sessionActiveUser),
    );
  }

  runApp(ProviderScope(overrides: providerOverrides, child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appKeepAliveProvider);
    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      theme: ref.watch(themeDataProvider),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return PopScope(
          canPop:
              !ref.watch(showGlobalLoadingProvider) &&
              ref.read(globalErrorDialogNotifierProvider) == null,
          onPopInvokedWithResult: (didPop, result) {
            if (ref.read(globalErrorDialogNotifierProvider) != null) {
              ref.read(globalErrorDialogNotifierProvider.notifier).clear();
            }
          },
          child: Stack(
            children: [
              if (child != null) child,
              if (ref.watch(showGlobalLoadingProvider)) SharedLoadingOverlay(),
              if (ref.watch(globalErrorDialogNotifierProvider) != null)
                GlobalErrorDialogOverlay(
                  title: "Error",
                  message: ref.watch(globalErrorDialogNotifierProvider)!,
                  onPressedOK: () {
                    ref
                        .read(globalErrorDialogNotifierProvider.notifier)
                        .clear();
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
