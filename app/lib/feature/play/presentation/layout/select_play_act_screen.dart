import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

import "../../../../core/application/provider/core_provider.dart";
import "../../../../core/model/core_model.dart";
import "../../../../core/router/router/router.dart";
import "../../../../core/router/router/screens.dart";
import "../../../../shared/presentation/async_state_builder/shared_async_state_builder.dart";
import "../../../../shared/presentation/base_screen/shared_app_bar.dart";
import "../../../../shared/presentation/base_screen/shared_base_screen.dart";
import "../../../../shared/presentation/base_screen/shared_floating_action_button.dart";
import "../../../../shared/provider/shared_provider.dart";
import "../../../../shared/shared_utility.dart";
import "../../application/provider/play_provider.dart";
import "../../model/request/play_request_model.dart";
import "../component/delete_play_project_dialog.dart";
import "../component/play_act_list_view.dart";
import "../component/play_more_vert_button.dart";

class SelectPlayActScreen extends ConsumerWidget {
  const SelectPlayActScreen({
    super.key,
    required this.playId,
    required this.title,
  });

  final String playId;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(getPlayActListProvider(playId));

    return SharedBaseScreen(
      appBar: SharedAppBar(
        title: title,
        actions: [
          PlayMoreVertButton(
            onDelete: () async {
              final confirmResult = await showDialog(
                context: context,
                builder: (context) => DeletePlayProjectDialog(title: title),
              );
              if (!(confirmResult is SharedPopResult &&
                  confirmResult.type == SharedPopResultType.ok)) {
                return;
              }
              final result = await ref
                  .read(asyncJobDispatcherProvider)
                  .trackJob<void>(
                    AsyncJobQueue(
                      id: "delete_play_project_$playId",
                      type: AsyncJobType.modify,
                      job: () async {
                        await ref
                            .read(playRepositoryProvider)
                            .deletePlay(
                              DeletePlayProjectRequest(playId: playId),
                            );
                      },
                    ),
                  );
              if (result is AsyncJobSuccess) {
                if (!context.mounted) return;
                context.pop();
              }
            },
          ),
        ],
      ),
      floatingActionButton: SharedFloatingActionButton(
        onPressed: () async {
          await CreatePlayActRoute(
            playId,
            ref.read(uuidProvider).v4(),
            (asyncValue.value?.overviews.length ?? 0) + 1,
          ).push(context);
          ref.invalidate(getPlayActListProvider(playId));
        },
        icon: Icons.add,
      ),
      body: SharedAsyncStateBuilder(
        asyncValue: asyncValue,
        builder: (value) {
          if (value.overviews.isEmpty) {
            return Center(
              child: Text(
                "There is no act",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }
          return PlayActListView(
            overviews: value.overviews
                .map(
                  (act) => PlayActOverviewViewModel(
                    title: act.title,
                    updatedAt: SharedUtility.formatViewDateTime(
                      act.updatedAt,
                      ref.watch(currentTimeProvider),
                    ),
                  ),
                )
                .toList(),
            onTap: (index) async {
              await UpdatePlayActRoute(
                value.overviews[index].id,
                playId,
              ).push(context);
              ref.invalidate(getPlayActListProvider(playId));
            },
          );
        },
      ),
    );
  }
}
