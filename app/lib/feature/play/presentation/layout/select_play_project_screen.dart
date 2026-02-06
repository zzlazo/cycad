import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/router/router/router.dart";
import "../../../../shared/presentation/async_state_builder/shared_async_state_builder.dart";
import "../../../../shared/presentation/base_screen/shared_app_bar.dart";
import "../../../../shared/presentation/base_screen/shared_base_screen.dart";
import "../../../../shared/presentation/base_screen/shared_floating_action_button.dart";
import "../../../../shared/provider/shared_provider.dart";
import "../../../../shared/shared_utility.dart";
import "../../application/provider/play_provider.dart";
import "../../model/model/play_model.dart";
import "../component/play_project_list_view.dart";

class SelectPlayProjectScreen extends ConsumerWidget {
  const SelectPlayProjectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(getPlayProjectListProvider);
    return SharedBaseScreen(
      floatingActionButton: SharedFloatingActionButton(
        onPressed: () async {
          await CreatePlayProjectRoute().push(context);
          ref.invalidate(getPlayProjectListProvider);
        },
        icon: Icons.add,
      ),
      appBar: SharedAppBar(title: "Play Projects"),
      body: SharedAsyncStateBuilder(
        asyncValue: asyncValue,
        builder: (value) {
          if (value.playProjects.isEmpty) {
            return Center(
              child: Text(
                "There is no project",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }
          return PlayProjectListView(
            overviews: value.playProjects
                .map(
                  (project) => PlayProjectOverviewViewModel(
                    title: project.title,
                    updatedAt: SharedUtility.formatViewDateTime(
                      project.updatedAt,
                      ref.watch(currentTimeProvider),
                    ),
                  ),
                )
                .toList(),
            onTap: (index) async {
              await SelectPlayActRoute(
                value.playProjects[index].id,
                value.playProjects[index].title,
              ).push(context);
              ref.invalidate(getPlayProjectListProvider);
            },
          );
        },
      ),
    );
  }
}
