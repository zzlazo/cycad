// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:supabase_flutter/supabase_flutter.dart";

part "plugin_supabase_provider.g.dart";

@riverpod
SupabaseClient supabaseClient(Ref ref) {
  throw UnimplementedError();
}

@riverpod
void pluginSupabaseKeepAlive(Ref ref) {
  ref.watch(supabaseClientProvider);
}
