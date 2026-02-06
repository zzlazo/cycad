import "package:supabase_flutter/supabase_flutter.dart";

import "../../core/model/core_model.dart";
import "../../shared/shared_utility.dart";

Future<SupabaseClient> initializeSupabase() async {
  final supabase = await Supabase.initialize(
    url: EnvVariables.supabaseUrl,
    anonKey: EnvVariables.supabaseKey,
  );
  return supabase.client;
}

PlayingUser? getSessionActiveUser(SupabaseClient client) {
  final Session? session = client.auth.currentSession;
  if (session == null || session.user.email == null) {
    return null;
  }
  return PlayingUser(id: session.user.id, email: session.user.email!);
}
