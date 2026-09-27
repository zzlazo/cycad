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
import "../component/play_editable_title_app_bar.dart";

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

    Future<AsyncJobResult<void>> onLineCreated(
      String newLineId,
      int sortOrder,
      String content,
    ) {
      return ref
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

    Future<AsyncJobResult<void>> onLineSaved(String lineId, String content) {
      return ref
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

    Future<AsyncJobResult<void>> onLineDelete(String lineId) {
      return ref
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

    // 書き込みはキューで順に処理されるため、失敗が分かった時点で後続の編集が画面に反映済みのことがある。
    // 操作前の状態を丸ごと戻すとそれらまで消えるので、失敗した操作の対象の行だけを戻す。
    void updateActLines(void Function(Map<String, PlayLine> lines) update) {
      final Map<String, PlayLine> newLines = Map.from(act.value.lines);
      update(newLines);
      act.value = act.value.copyWith(lines: newLines);
    }

    void updateSceneLines(
      String sceneId,
      void Function(Map<String, PlayLine> lines) update,
    ) {
      final scene = act.value.scenes[sceneId];
      if (scene == null) return;
      final Map<String, PlayLine> newLines = Map.from(scene.lines);
      update(newLines);
      final Map<String, PlayScene> newScenes = Map.from(act.value.scenes);
      newScenes[sceneId] = scene.copyWith(lines: newLines);
      act.value = act.value.copyWith(scenes: newScenes);
    }

    Future<void> onActLineCreated(int sortOrder) async {
      final newLineId = ref.read(uuidProvider).v4();
      updateActLines(
        (lines) => lines[newLineId] = PlayLine(
          id: newLineId,
          sortOrder: sortOrder,
          actId: actId,
          content: "",
        ),
      );
      final result = await onLineCreated(newLineId, sortOrder, "");
      if (result is AsyncJobFailure) {
        updateActLines((lines) => lines.remove(newLineId));
      }
    }

    Future<void> onActLineSaved(String lineId, String content) async {
      final oldLine = act.value.lines[lineId];
      // blur のたびに呼ばれるため、変化がなければ送らない
      if (oldLine == null || oldLine.content == content) return;
      updateActLines(
        (lines) => lines[lineId] = oldLine.copyWith(content: content),
      );
      final result = await onLineSaved(lineId, content);
      if (result is AsyncJobFailure) {
        updateActLines((lines) {
          if (lines.containsKey(lineId)) lines[lineId] = oldLine;
        });
      }
    }

    Future<void> onActLineDelete(String lineId) async {
      final oldLine = act.value.lines[lineId];
      if (oldLine == null) return;
      updateActLines((lines) => lines.remove(lineId));
      final result = await onLineDelete(lineId);
      if (result is AsyncJobFailure) {
        updateActLines((lines) => lines[lineId] = oldLine);
      }
    }

    Future<void> onSceneLineSaved(
      String sceneId,
      String lineId,
      String content,
    ) async {
      final oldLine = act.value.scenes[sceneId]?.lines[lineId];
      // blur のたびに呼ばれるため、変化がなければ送らない
      if (oldLine == null || oldLine.content == content) return;
      updateSceneLines(
        sceneId,
        (lines) => lines[lineId] = oldLine.copyWith(content: content),
      );
      final result = await onLineSaved(lineId, content);
      if (result is AsyncJobFailure) {
        updateSceneLines(sceneId, (lines) {
          if (lines.containsKey(lineId)) lines[lineId] = oldLine;
        });
      }
    }

    Future<void> onSceneLineDeleted(String sceneId, String lineId) async {
      final oldLine = act.value.scenes[sceneId]?.lines[lineId];
      if (oldLine == null) return;
      updateSceneLines(sceneId, (lines) => lines.remove(lineId));
      final result = await onLineDelete(lineId);
      if (result is AsyncJobFailure) {
        updateSceneLines(sceneId, (lines) => lines[lineId] = oldLine);
      }
    }

    return SharedBaseScreen(
      appBar: PlayEditableTitleAppBar(
        title: act.value.overview.title,
        onSaved: (newTitle) async {
          final oldTitle = act.value.overview.title;
          act.value = act.value.copyWith(
            overview: act.value.overview.copyWith(title: newTitle),
          );
          final result = await ref
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
          if (result is AsyncJobFailure) {
            act.value = act.value.copyWith(
              overview: act.value.overview.copyWith(title: oldTitle),
            );
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
