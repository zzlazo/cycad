import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../core/application/provider/core_provider.dart";
import "../../../../core/model/core_model.dart";
import "../../../../core/router/router/screens.dart";
import "../../../../shared/presentation/base_screen/shared_base_screen.dart";
import "../../application/provider/play_provider.dart";
import "../../model/request/play_request_model.dart";
import "../component/delete_play_act_dialog.dart";
import "../component/play_act_detail_form.dart";
import "../component/play_act_form_screen_app_bar.dart";

class PlayActFormScreenBase extends HookConsumerWidget {
  const PlayActFormScreenBase({
    super.key,
    required this.actId,
    required this.playId,
    required this.initialValue,
  });

  final String playId;
  final String actId;
  final PlayAct initialValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final act = useState<PlayAct>(initialValue);
    final pullSceneProvider = pullPlaySceneListProvider(actId);
    final formKey = useMemoized(() => GlobalKey<FormState>());

    Future<void> onLineCreated(
      String newLineId,
      int sortOrder,
      String content,
    ) async {
      await ref
          .read(asyncJobDispatcherProvider)
          .trackJob<void>(
            AsyncJobQueue(
              id: "create_play_line_$newLineId",
              type: AsyncJobType.modify,
              showLoading: false,
              job: () async {
                await ref
                    .read(playRepositoryProvider)
                    .createLine(
                      CreatePlayLineRequest(
                        actId: actId,
                        lineId: newLineId,
                        sortOrder: sortOrder,
                        content: content,
                      ),
                    );
              },
            ),
          );
    }

    Future<void> onLineSaved(String lineId, String content) async {
      await ref
          .read(asyncJobDispatcherProvider)
          .trackJob<void>(
            AsyncJobQueue(
              id: "save_play_line_$lineId",
              type: AsyncJobType.modify,
              showLoading: false,
              job: () async {
                await ref
                    .read(playRepositoryProvider)
                    .updateLine(
                      UpdatePlayLineRequest(lineId: lineId, content: content),
                    );
              },
            ),
          );
    }

    Future<void> onLineDelete(String lineId) async {
      await ref
          .read(asyncJobDispatcherProvider)
          .trackJob<void>(
            AsyncJobQueue(
              id: "delete_play_line_$lineId",
              type: AsyncJobType.modify,
              showLoading: false,
              job: () async {
                await ref
                    .read(playRepositoryProvider)
                    .deleteLine(DeletePlayLineRequest(lineId: lineId));
              },
            ),
          );
    }

    Future<void> onActLineCreated(int sortOrder) async {
      final oldState = act.value.copyWith();
      final Map<String, PlayLine> newLines = Map.from(act.value.lines);
      final newLineId = ref.read(uuidProvider).v4();
      newLines[newLineId] = PlayLine(
        id: newLineId,
        sortOrder: sortOrder,
        actId: actId,
        content: "",
      );
      act.value = act.value.copyWith(lines: newLines);
      try {
        await onLineCreated(newLineId, sortOrder, "");
      } catch (error) {
        act.value = oldState;
      }
    }

    Future<void> onActLineSaved(String lineId, String content) async {
      final oldState = act.value.copyWith();
      final Map<String, PlayLine> newLines = Map.from(act.value.lines);
      newLines[lineId] = newLines[lineId]!.copyWith(content: content);
      act.value = act.value.copyWith(lines: newLines);
      try {
        await onLineSaved(lineId, content);
      } catch (error) {
        act.value = oldState;
      }
    }

    Future<void> onActLineDelete(String lineId) async {
      final oldState = act.value.copyWith();
      final Map<String, PlayLine> newLines = Map.from(act.value.lines);
      newLines.remove(lineId);
      act.value = act.value.copyWith(lines: newLines);
      try {
        await onLineDelete(lineId);
      } catch (error) {
        act.value = oldState;
      }
    }

    Future<void> onSceneLineSaved(
      String sceneId,
      String lineId,
      String content,
    ) async {
      final oldState = act.value.copyWith();
      final Map<String, PlayScene> newScenes = Map.from(act.value.scenes);
      final Map<String, PlayLine> newLines = Map.from(
        newScenes[sceneId]!.lines,
      );
      newLines[lineId] = newLines[lineId]!.copyWith(content: content);
      newScenes[sceneId] = newScenes[sceneId]!.copyWith(lines: newLines);
      act.value = act.value.copyWith(scenes: newScenes);
      try {
        await onLineSaved(lineId, content);
      } catch (error) {
        act.value = oldState;
      }
    }

    Future<void> onSceneLineDeleted(String sceneId, String lineId) async {
      final oldState = act.value.copyWith();
      final Map<String, PlayScene> newScenes = Map.from(act.value.scenes);
      final Map<String, PlayLine> newLines = Map.from(
        newScenes[sceneId]!.lines,
      );
      newLines.remove(lineId);
      newScenes[sceneId] = newScenes[sceneId]!.copyWith(lines: newLines);
      act.value = act.value.copyWith(scenes: newScenes);
      try {
        await onLineDelete(lineId);
      } catch (error) {
        act.value = oldState;
      }
    }

    return SharedBaseScreen(
      appBar: PlayActFormScreenAppBar(
        title: act.value.overview.title,
        onSaved: (newTitle) async {
          final oldState = act.value.copyWith();
          act.value = act.value.copyWith(
            overview: act.value.overview.copyWith(title: newTitle),
          );
          try {
            await ref
                .read(asyncJobDispatcherProvider)
                .trackJob<void>(
                  AsyncJobQueue(
                    id: "update_play_act_$actId",
                    type: AsyncJobType.modify,
                    job: () async {
                      await ref
                          .read(playRepositoryProvider)
                          .updateAct(
                            UpdatePlayActRequest(actId: actId, title: newTitle),
                          );
                    },
                  ),
                );
          } catch (error) {
            act.value = oldState;
          }
        },
        onDelete: () async {
          final confirmResult = await showDialog(
            context: context,
            builder: (context) =>
                DeletePlayActDialog(title: act.value.overview.title),
          );
          if (!(confirmResult is SharedPopResult &&
              confirmResult.type == SharedPopResultType.ok)) {
            return;
          }
          final result = await ref
              .read(asyncJobDispatcherProvider)
              .trackJob<void>(
                AsyncJobQueue(
                  id: "delete_play_act_$actId",
                  type: AsyncJobType.modify,
                  job: () async {
                    return await ref
                        .read(playRepositoryProvider)
                        .deleteAct(DeletePlayActRequest(actId: actId));
                  },
                ),
              );
          if (result case AsyncJobSuccess()) {
            if (!context.mounted) return;
            context.pop();
          }
        },
      ),
      body: PlayActDetailForm(
        act: act.value,
        formKey: formKey,
        isLoadingScene: ref.watch(pullSceneProvider).isLoading,
        onPullSceneList: () async {
          final scenes = await ref.read(pullSceneProvider.notifier).pull(3);
          act.value = act.value.copyWith(
            scenes: {for (final scene in scenes) scene.id: scene},
          );
        },
        onActLineCreate: (sortOrder) => onActLineCreated(sortOrder),
        onActLineSaved: onActLineSaved,
        onActLineBlur: onActLineSaved,
        onActLineDelete: onActLineDelete,
        onSceneLineSaved: onSceneLineSaved,
        onSceneLineBlur: onSceneLineSaved,
        onSceneLineDelete: onSceneLineDeleted,
      ),
    );
  }
}
