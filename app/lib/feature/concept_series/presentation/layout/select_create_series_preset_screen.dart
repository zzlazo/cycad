import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../core/router/router/router.dart";
import "../../../../shared/presentation/async_state_builder/shared_async_state_builder.dart";
import "../../../../shared/presentation/base_screen/shared_app_bar.dart";
import "../../../../shared/presentation/base_screen/shared_base_screen.dart";
import "../../application/provider/concept_series_provider.dart";
import "../component/series_preset_list_view.dart";

class SelectCreateSeriesPresetScreen extends ConsumerWidget {
  const SelectCreateSeriesPresetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(getCardConceptSeriesPresetListProvider);
    return SharedBaseScreen(
      appBar: SharedAppBar(title: "Series Presets"),
      body: SharedAsyncStateBuilder(
        asyncValue: asyncValue,
        builder: (value) {
          return SeriesPresetListView(
            presets: value.presets,
            onTap: (id) async {
              CreateSeriesRoute(id).pushReplacement(context);
            },
          );
        },
      ),
    );
  }
}
