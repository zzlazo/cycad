import "package:supabase_flutter/supabase_flutter.dart";

import "../../../core/logger/app_logger.dart";
import "../../../shared/repository/repository_utility.dart";
import "../model/model/play_model.dart";
import "../model/request/play_request_model.dart";

abstract class PlayRepository {
  Future<GetPlayProjectListResponse> getProjectList(
    GetPlayProjectListRequest request,
  );
  Future<GetPlayActDetailResponse> getActDetail(
    GetPlayActDetailRequest request,
  );
  Future<GetPlayActListResponse> getActList(GetPlayActListRequest request);

  Future<void> createPlay(CreatePlayProjectRequest request);
  Future<void> updatePlay(UpdatePlayProjectRequest request);
  Future<void> deletePlay(DeletePlayProjectRequest request);
  Future<CreatePlayActResponse> createAct(CreatePlayActRequest request);
  Future<void> updateAct(UpdatePlayActRequest request);
  Future<void> deleteAct(DeletePlayActRequest request);
  Future<void> createLine(CreatePlayLineRequest request);
  Future<void> updateLine(UpdatePlayLineRequest request);
  Future<void> deleteLine(DeletePlayLineRequest request);
  Future<PullPlaySceneListResponse> pullSceneList(
    PullPlaySceneListRequest request,
  );
}

class PlayServerRepository implements PlayRepository {
  final SupabaseClient _client;
  final IAppLogger _logger;

  PlayServerRepository(this._client, this._logger);

  Future<T> _handle<T>(Future<T> Function() job, String errorMessage) async {
    return await handleJob<T>(job, errorMessage, _logger);
  }

  @override
  Future<GetPlayProjectListResponse> getProjectList(
    GetPlayProjectListRequest request,
  ) async {
    return await _handle<GetPlayProjectListResponse>(() async {
      final rawResult = await _client
          .from(ServerTables.plays.tableName)
          .select("id, title, series_id, updated_at")
          .eq("author_id", request.userId);
      final items = rawResult
          .map((e) => PlayProjectOverview.fromJson(e))
          .toList();
      final response = GetPlayProjectListResponse(playProjects: items);

      return response;
    }, "Error occurred while getting project list");
  }

  @override
  Future<GetPlayActListResponse> getActList(
    GetPlayActListRequest request,
  ) async {
    return await _handle(() async {
      final rawResult = await _client
          .from(ServerTables.acts.tableName)
          .select("id, sort_order, play_id, updated_at, title")
          .eq("play_id", request.playId);
      final items = rawResult.map((e) => PlayActOverview.fromJson(e)).toList();
      final response = GetPlayActListResponse(overviews: items);

      return response;
    }, "Error occurred while getting act list");
  }

  @override
  Future<GetPlayActDetailResponse> getActDetail(
    GetPlayActDetailRequest request,
  ) async {
    return await _handle(() async {
      final rawResult = await _client
          .from(ServerTables.viewActDetails.tableName)
          .select("overview, scenes, lines")
          .eq("id", request.actId)
          .single();
      final response = PlayAct.fromJson(rawResult);
      return GetPlayActDetailResponse(act: response);
    }, "Error occurred while getting act detail");
  }

  @override
  Future<void> createPlay(CreatePlayProjectRequest request) async {
    await _handle(() async {
      await _client.rpc(
        ServerFunctions.rpcCreatePlay.functionName,
        params: request.toJson(),
      );
    }, "Error occurred while createing play detail");
  }

  @override
  Future<void> updatePlay(UpdatePlayProjectRequest request) async {
    await _handle(() async {
      await _client.rpc(
        ServerFunctions.rpcUpdateAct.functionName,
        params: request.toJson(),
      );
    }, "Error occurred while updating play project");
  }

  @override
  Future<void> deletePlay(DeletePlayProjectRequest request) async {
    await _handle(() async {
      await _client.rpc(
        ServerFunctions.rpcDeletePlay.functionName,
        params: request.toJson(),
      );
    }, "Error occurred while deleting play project");
  }

  @override
  Future<CreatePlayActResponse> createAct(CreatePlayActRequest request) async {
    return await _handle(() async {
      final rawResult = await _client
          .rpc(
            ServerFunctions.rpcCreateAct.functionName,
            params: request.toJson(),
          )
          .single();
      final act = PlayAct.fromJson(rawResult);
      return CreatePlayActResponse(act: act);
    }, "Error occurred while creating act");
  }

  @override
  Future<void> updateAct(UpdatePlayActRequest request) async {
    await _handle(() async {
      await _client.rpc(
        ServerFunctions.rpcUpdateAct.functionName,
        params: request.toJson(),
      );
    }, "Error occurred while updating act");
  }

  @override
  Future<void> deleteAct(DeletePlayActRequest request) async {
    await _handle(() async {
      await _client.rpc(
        ServerFunctions.rpcDeleteAct.functionName,
        params: request.toJson(),
      );
    }, "Error occurred while deleting act");
  }

  @override
  Future<void> createLine(CreatePlayLineRequest request) async {
    await _handle(() async {
      await _client.rpc(
        ServerFunctions.rpcCreateLine.functionName,
        params: request.toJson(),
      );
    }, "Error occurred while creating line");
  }

  @override
  Future<void> updateLine(UpdatePlayLineRequest request) async {
    await _handle(() async {
      await _client.rpc(
        ServerFunctions.rpcUpdateLine.functionName,
        params: request.toJson(),
      );
    }, "Error occurred while updating line");
  }

  @override
  Future<void> deleteLine(DeletePlayLineRequest request) async {
    await _handle(() async {
      await _client.rpc(
        ServerFunctions.rpcDeleteLine.functionName,
        params: request.toJson(),
      );
    }, "Error occurred while deleting line");
  }

  @override
  Future<PullPlaySceneListResponse> pullSceneList(
    PullPlaySceneListRequest request,
  ) async {
    return await _handle(() async {
      final rawResult = await _client.rpc(
        ServerFunctions.rpcPullSceneList.functionName,
        params: request.toJson(),
      );
      final scenes = (rawResult as List<dynamic>)
          .map((e) => PlayScene.fromJson(e))
          .toList();
      final response = PullPlaySceneListResponse(scenes: scenes);
      return response;
    }, "Error occurred while pulling scene list");
  }
}
