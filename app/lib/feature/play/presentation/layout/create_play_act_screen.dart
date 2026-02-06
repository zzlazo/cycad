import "package:flutter/widgets.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../shared/presentation/async_state_builder/shared_async_state_builder.dart";
import "../../application/provider/play_provider.dart";
import "play_act_form_screen_base.dart";

class CreatePlayActScreen extends HookConsumerWidget {
  const CreatePlayActScreen({
    super.key,
    required this.actId,
    required this.sortOrder,
    required this.playId,
  });

  final String actId;
  final String playId;
  final int sortOrder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SharedAsyncStateBuilder(
      asyncValue: ref.watch(
        getNewActProvider(actId: actId, sortOrder: sortOrder, playId: playId),
      ),
      builder: (value) => PlayActFormScreenBase(
        actId: actId,
        playId: playId,
        initialValue: value,
      ),
    );
  }
}
