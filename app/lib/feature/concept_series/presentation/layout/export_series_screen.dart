import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:share_plus/share_plus.dart";

import "../../../../core/application/provider/core_provider.dart";
import "../../../../core/model/core_model.dart";
import "../../../../shared/presentation/base_screen/shared_app_bar.dart";
import "../../../../shared/presentation/base_screen/shared_base_screen.dart";
import "../../../../shared/presentation/icon_button/shared_icon_button.dart";
import "../../application/provider/concept_series_provider.dart";
import "../../model/model/concept_series_model.dart";
import "../../model/request/concept_series_request_model.dart";
import "../component/series_preview.dart";

class ExportSeriesScreen extends ConsumerWidget {
  const ExportSeriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preview = ref.watch(previewCardConceptSeriesNotifierProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final exportStyle = ExportSeriesStyle(
          backgroundColor: Colors.black,
          padding: 20,
          codeStyle: Theme.of(context).textTheme.headlineLarge!,
          bodyStyle: Theme.of(context).textTheme.titleMedium!,
          size: ConceptSeriesExportCardSize(
            width: constraints.maxWidth.toInt(),
            height: (constraints.maxHeight ~/ 1.5),
          ),
        );
        return SharedBaseScreen(
          appBar: SharedAppBar(
            title: "Export",
            actions: [
              SharedIconButton(
                iconData: Icons.save,
                onPressed: () async {
                  final result = await ref
                      .read(asyncJobDispatcherProvider)
                      .trackJob(
                        AsyncJobQueue(
                          id: "export_series_${preview!.overview.id}}",
                          type: AsyncJobType.modify,
                          job: () async {
                            return await ref
                                .read(conceptSeriesRepositoryProvider)
                                .export(
                                  ExportCardConceptSeriesPresetRequest(
                                    series: preview,
                                    userId: ref
                                        .watch(currentPlayingUserProvider)
                                        .id,
                                    style: exportStyle,
                                  ),
                                );
                          },
                        ),
                      );
                  if (result case AsyncJobSuccess(:final value)) {
                    final params = ShareParams(files: [value]);

                    await SharePlus.instance.share(params);
                  }
                },
              ),
            ],
          ),
          body: preview == null
              ? Text("Series not found")
              : ExportSeriesPreviewWidget(
                  concepts: preview.concepts,
                  style: exportStyle,
                ),
        );
      },
    );
  }
}
