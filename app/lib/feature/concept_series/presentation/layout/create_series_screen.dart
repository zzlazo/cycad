import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../core/application/provider/core_provider.dart";
import "../../../../core/model/core_model.dart";
import "../../../../shared/presentation/async_state_builder/shared_async_state_builder.dart";
import "../../../../shared/presentation/base_screen/shared_app_bar.dart";
import "../../../../shared/presentation/base_screen/shared_base_screen.dart";
import "../../../../shared/provider/shared_provider.dart";
import "../../application/provider/concept_series_provider.dart";
import "../../model/model/concept_series_model.dart";
import "../../model/request/concept_series_request_model.dart";
import "../component/series_form.dart";

class CreateSeriesScreen extends HookConsumerWidget {
  const CreateSeriesScreen({super.key, required this.presetId});

  final int presetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newSeriesId = useState<int?>(null);
    final formState = useState(
      CardConceptSeries(
        overview: CardConceptSeriesOverview(
          id: 0,
          title: "",
          updatedAt: ref.watch(currentTimeProvider),
        ),
        concepts: [],
      ),
    );
    ref.listen(getCardConceptSeriesPresetProvider(presetId), (previous, next) {
      if (next.hasValue) {
        formState.value = formState.value.copyWith(
          concepts: next.value!.preset.codes
              .map((code) => CardConcept(id: 0, code: code, concept: ""))
              .toList(),
        );
      }
    });
    return SharedBaseScreen(
      appBar: SharedAppBar(
        title: formState.value.overview.title,
        actions: [
          SharedAppBarSaveButton(
            onPressed: () async {
              if (newSeriesId.value != null) {
                await ref
                    .read(asyncJobDispatcherProvider)
                    .trackJob<void>(
                      AsyncJobQueue(
                        id: "update_series_${formState.value.overview.title}}",
                        type: AsyncJobType.modify,
                        job: () async {
                          await ref
                              .read(conceptSeriesRepositoryProvider)
                              .updateSeries(
                                UpdateCardConceptSeriesRequest(
                                  id: newSeriesId.value!,
                                  title: formState.value.overview.title,
                                  concepts: formState.value.concepts,
                                ),
                              );
                        },
                      ),
                    );
              } else {
                final result = await ref
                    .read(asyncJobDispatcherProvider)
                    .trackJob<int>(
                      AsyncJobQueue(
                        id: "create_series_${formState.value.overview.title}}",
                        type: AsyncJobType.modify,
                        job: () async {
                          return await ref
                              .read(conceptSeriesRepositoryProvider)
                              .createSeries(
                                CreateCardConceptSeriesRequest(
                                  title: formState.value.overview.title,
                                  concepts: formState.value.concepts,
                                ),
                              );
                        },
                      ),
                    );
                if (result case AsyncJobSuccess(:final value)) {
                  newSeriesId.value = value;
                }
              }
            },
          ),
        ],
      ),
      body: SharedAsyncStateBuilder(
        asyncValue: ref.watch(getCardConceptSeriesPresetProvider(presetId)),
        builder: (value) {
          return SeriesForm(
            title: formState.value.overview.title,
            onChangedTitle: (title) {
              formState.value = formState.value.copyWith(
                overview: formState.value.overview.copyWith(title: title),
              );
            },
            onChangedConcept: (index, text) {
              final concepts = List<CardConcept>.from(formState.value.concepts);
              concepts[index] = concepts[index].copyWith(concept: text);
              formState.value = formState.value.copyWith(concepts: concepts);
            },
            concepts: formState.value.concepts,
          );
        },
      ),
    );
  }
}
