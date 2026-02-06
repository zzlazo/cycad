import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../core/router/router/router.dart";
import "../../../../shared/presentation/async_state_builder/shared_async_state_builder.dart";
import "../../../../shared/presentation/base_screen/shared_app_bar.dart";
import "../../../../shared/presentation/base_screen/shared_base_screen.dart";
import "../../../../shared/presentation/base_screen/shared_floating_action_button.dart";
import "../../../../shared/provider/shared_provider.dart";
import "../../../../shared/shared_utility.dart";
import "../../application/provider/concept_series_provider.dart";
import "../../model/model/concept_series_model.dart";
import "../../model/request/concept_series_request_model.dart";
import "../component/series_list_view.dart";

class SelectSeriesScreen extends HookConsumerWidget {
  const SelectSeriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(conceptSeriesKeepAliveProvider);
    final AsyncValue<GetCardConceptSeriesListResponse> asyncValue = ref.watch(
      getConceptSeriesListProvider,
    );

    return SharedBaseScreen(
      floatingActionButton: SharedFloatingActionButton(
        onPressed: () async {
          if (!context.mounted) return;
          await SelectSeriesPresetRoute().push(context);
          ref.invalidate(getConceptSeriesListProvider);
        },
        icon: Icons.add,
      ),
      appBar: SharedAppBar(title: "Series List"),
      body: SharedAsyncStateBuilder(
        asyncValue: asyncValue,
        builder: (value) {
          if (value.series.isEmpty) {
            return Center(
              child: Text(
                "There is no series",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }
          return SeriesListView(
            overviews: value.series
                .map(
                  (element) => CardConceptSeriesOverviewListItemModel(
                    id: element.id,
                    title: element.title,
                    updatedAt: SharedUtility.formatViewDateTime(
                      element.updatedAt,
                      ref.watch(currentTimeProvider),
                    ),
                  ),
                )
                .toList(),
            onTap: (index) async {
              if (!context.mounted) return;
              final int tapId = value.series[index].id;
              await UpdateSeriesRoute(tapId).push(context);
              ref.invalidate(getConceptSeriesListProvider);
            },
          );
        },
      ),
    );
  }
}
