import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/application/provider/core_provider.dart";
import "../../../../shared/presentation/user_icon/shared_user_icon.dart";

class HomeUserIcon extends ConsumerWidget {
  const HomeUserIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentPlayingUserProvider);
    return SizedBox(
      width: 50,
      height: 50,
      child: InkWell(child: SharedUserIcon(avatarUrl: user.avatarUrl)),
    );
  }
}
