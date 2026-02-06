import "package:flutter/widgets.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../shared/presentation/async_state_builder/shared_async_state_builder.dart";
import "../../application/provider/play_provider.dart";
import "play_act_form_screen_base.dart";

class UpdatePlayActScreen extends HookConsumerWidget {
  const UpdatePlayActScreen({
    super.key,
    required this.actId,
    required this.playId,
  });

  final String actId;
  final String playId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SharedAsyncStateBuilder(
      asyncValue: ref.watch(getPlayActDetailProvider(actId)),
      builder: (value) => PlayActFormScreenBase(
        actId: actId,
        playId: playId,
        initialValue: value,
      ),
    );
  }
}
