import "package:flutter/widgets.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../core/application/provider/core_provider.dart";
import "../../../../core/model/core_model.dart";
import "../../../../core/router/router/router.dart";
import "../../../../shared/presentation/async_state_builder/shared_async_state_builder.dart";
import "../../../../shared/presentation/base_screen/shared_app_bar.dart";
import "../../../../shared/presentation/base_screen/shared_base_screen.dart";
import "../../../../shared/presentation/error_view/shared_error_view.dart";
import "../../../concept_series/application/provider/concept_series_provider.dart";
import "../../application/provider/play_provider.dart";
import "../../model/model/play_model.dart";
import "../../model/request/play_request_model.dart";
import "../component/update_play_project_form.dart";

class CreatePlayProjectScreen extends HookConsumerWidget {
  const CreatePlayProjectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final formState = useState<UpdateProjectFormModel>(
      UpdateProjectFormModel(),
    );
    final canSave =
        formState.value.title != null && formState.value.seriesId != null;

    final asyncValue = ref.watch(getConceptSeriesListProvider);
    return SharedBaseScreen(
      appBar: SharedAppBar(
        title: "Project Setting",
        actions: [
          SharedAppBarSaveButton(
            onPressed: canSave
                ? () async {
                    final request = CreatePlayProjectRequest(
                      playId: ref.read(uuidProvider).v4(),
                      title: formState.value.title!,
                      seriesId: formState.value.seriesId!,
                    );
                    final result = await ref
                        .read(asyncJobDispatcherProvider)
                        .trackJob(
                          AsyncJobQueue(
                            id: request.playId,
                            type: AsyncJobType.modify,
                            job: () async {
                              await ref
                                  .read(playRepositoryProvider)
                                  .createPlay(request);
                            },
                          ),
                        );
                    if (result is AsyncJobSuccess) {
                      if (!context.mounted) return;
                      await SelectPlayActRoute(
                        request.playId,
                        request.title,
                      ).push(context);
                    }
                  }
                : null,
          ),
        ],
      ),
      body: SharedAsyncStateBuilder(
        asyncValue: asyncValue,

        builder: (value) {
          if (value.series.isEmpty) {
            return SharedErrorView(message: "series not found");
          }
          return Container(
            margin: EdgeInsets.all(10),
            alignment: Alignment.topCenter,
            child: UpdatePlayProjectForm(
              seriesList: value.series,
              formKey: formKey,
              onTitleChanged: (text) {
                formState.value = formState.value.copyWith(title: text);
              },
              onSeriesChanged: (id) {
                formState.value = formState.value.copyWith(seriesId: id);
              },
            ),
          );
        },
      ),
    );
  }
}
