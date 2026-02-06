import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../core/application/provider/core_provider.dart";
import "../../../../core/model/core_model.dart";
import "../../../../core/router/router/router.dart";
import "../../../../shared/presentation/alert_dialog/model/shared_alert_dialog_model.dart";
import "../../../../shared/presentation/async_state_builder/shared_async_state_builder.dart";
import "../../../../shared/presentation/base_screen/shared_app_bar.dart";
import "../../../../shared/presentation/base_screen/shared_base_screen.dart";
import "../../../../shared/presentation/icon_button/shared_icon_button.dart";
import "../../../../shared/provider/shared_provider.dart";
import "../../application/provider/concept_series_provider.dart";
import "../../model/model/concept_series_model.dart";
import "../../model/request/concept_series_request_model.dart";
import "../component/series_form.dart";
import "../component/series_more_vert_button.dart";
import "delete_series_dialog.dart";

class UpdateSeriesScreen extends HookConsumerWidget {
  const UpdateSeriesScreen({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(previewCardConceptSeriesNotifierProvider);
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
    ref.listen(getConceptSeriesProvider(id), (previous, next) {
      if (previous?.isLoading != false && !next.isLoading && next.hasValue) {
        formState.value = next.value!;
      }
    });
    return SharedBaseScreen(
      appBar: SharedAppBar(
        title: formState.value.overview.title,
        actions: [
          SharedIconButton(
            iconData: Icons.image,
            onPressed: () async {
              ref
                  .read(previewCardConceptSeriesNotifierProvider.notifier)
                  .set(formState.value);
              if (!context.mounted) return;
              await ExportSeriesRoute().push(context);
            },
          ),
          SharedAppBarSaveButton(
            onPressed: () async {
              await ref
                  .read(asyncJobDispatcherProvider)
                  .trackJob(
                    AsyncJobQueue(
                      id: "update_series_$id}",
                      type: AsyncJobType.modify,
                      job: () async {
                        await ref
                            .read(conceptSeriesRepositoryProvider)
                            .updateSeries(
                              UpdateCardConceptSeriesRequest(
                                id: id,
                                title: formState.value.overview.title,
                                concepts: formState.value.concepts,
                              ),
                            );
                      },
                    ),
                  );
            },
          ),
          if (ref.watch(checkExistSeriesPlayProvider(id)).value == false)
            SeriesMoreVertButton(
              onDelete: () async {
                final dialogResult = await showDialog(
                  context: context,
                  builder: (context) =>
                      DeleteSeriesDialog(title: formState.value.overview.title),
                );
                if (!(dialogResult is SharedPopResult &&
                    dialogResult.type == SharedPopResultType.ok)) {
                  return;
                }
                final result = await ref
                    .read(asyncJobDispatcherProvider)
                    .trackJob(
                      AsyncJobQueue(
                        id: "delete_series_$id",
                        type: AsyncJobType.modify,
                        job: () async {
                          await ref
                              .read(conceptSeriesRepositoryProvider)
                              .deleteSeries(
                                DeleteCardConceptSeriesRequest(idList: [id]),
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
      body: SharedAsyncStateBuilder(
        asyncValue: ref.watch(getConceptSeriesProvider(id)),
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
