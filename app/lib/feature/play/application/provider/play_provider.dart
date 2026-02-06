import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../core/application/provider/core_provider.dart";
import "../../../../core/model/core_model.dart";
import "../../../../plugins/supabase/application/provider/plugin_supabase_provider.dart";
import "../../model/model/play_model.dart";
import "../../model/request/play_request_model.dart";
import "../../repository/play_repository.dart";

part "play_provider.g.dart";

@riverpod
PlayRepository playRepository(Ref ref) {
  return PlayServerRepository(
    ref.read(supabaseClientProvider),
    ref.read(appLoggerProvider),
  );
}

@riverpod
Future<GetPlayProjectListResponse> getPlayProjectList(Ref ref) async {
  final GetPlayProjectListRequest request = GetPlayProjectListRequest(
    userId: ref.read(currentPlayingUserProvider).id,
  );
  return await ref.read(playRepositoryProvider).getProjectList(request);
}

@riverpod
Future<GetPlayActListResponse> getPlayActList(Ref ref, String playId) async {
  final GetPlayActListRequest request = GetPlayActListRequest(
    userId: ref.read(currentPlayingUserProvider).id,
    playId: playId,
  );
  return await ref.read(playRepositoryProvider).getActList(request);
}

@riverpod
Future<PlayAct> getPlayActDetail(Ref ref, String actId) async {
  final response = await ref
      .read(playRepositoryProvider)
      .getActDetail(
        GetPlayActDetailRequest(
          userId: ref.watch(currentPlayingUserProvider).id,
          actId: actId,
        ),
      );
  return response.act;
}

@riverpod
class PullPlaySceneList extends _$PullPlaySceneList {
  @override
  AsyncValue<void> build(String actId) {
    return AsyncData(null);
  }

  Future<List<PlayScene>> pull(int sceneLength) async {
    state = AsyncLoading();
    PullPlaySceneListResponse? response;
    state = await AsyncValue.guard(() async {
      await ref
          .read(asyncJobDispatcherProvider)
          .trackJob<void>(
            AsyncJobQueue(
              id: "pull_play_scene_list_$actId",
              type: AsyncJobType.modify,
              job: () async {
                response = await ref
                    .read(playRepositoryProvider)
                    .pullSceneList(
                      PullPlaySceneListRequest(
                        actId: actId,
                        sceneLength: sceneLength,
                      ),
                    );
              },
            ),
          );
    });
    return response?.scenes ?? [];
  }
}

@riverpod
Future<PlayAct> getNewAct(
  Ref ref, {
  required String actId,
  required int sortOrder,
  required String playId,
}) async {
  final response = await ref
      .read(playRepositoryProvider)
      .createAct(
        CreatePlayActRequest(
          playId: playId,
          actId: actId,
          sortOrder: sortOrder,
          title: "Act $sortOrder",
        ),
      );
  return response.act;
}
