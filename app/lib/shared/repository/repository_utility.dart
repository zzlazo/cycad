import "package:supabase_flutter/supabase_flutter.dart";

import "../../core/error/app_error.dart";
import "../../core/logger/app_logger.dart";

enum ServerTables {
  cardConceptSeries("card_concept_series"),
  viewCardConceptsDetails("view_card_concepts_details"),
  viewCardConceptSeriesPresetDetails("view_card_concept_series_preset_details"),
  viewCardConceptSeriesDetails("view_card_concept_series_details"),
  plays("plays"),
  acts("acts"),
  viewActDetails("view_act_details");

  const ServerTables(this.tableName);
  final String tableName;
}

enum ServerFunctions {
  rpcCreateSeries("rpc_create_series"),
  rpcBulkDeleteSeries("rpc_bulk_delete_concept_series"),
  rpcUpdateSeries("rpc_update_series"),
  rpcCreatePlay("rpc_create_play"),
  rpcUpdatePlay("rpc_update_play"),
  rpcDeletePlay("rpc_delete_play"),
  rpcCreateAct("rpc_create_act"),
  rpcUpdateAct("rpc_update_act"),
  rpcDeleteAct("rpc_delete_act"),
  rpcCreateLine("rpc_create_line"),
  rpcUpdateLine("rpc_update_line"),
  rpcDeleteLine("rpc_delete_line"),
  rpcPullSceneList("rpc_pull_scene_list"),
  rpcCheckExistSeriesPlay("rpc_check_exist_series_play");

  final String functionName;
  const ServerFunctions(this.functionName);
}

abstract class ApiLoadTracker {
  void start();
  void end();
}

Future<T> handleJob<T>(
  Future<T> Function() job,
  String errorMessage,
  IAppLogger logger,
) async {
  try {
    try {
      return await job();
    } catch (e, stackTrace) {
      logger.e("error: $e:$stackTrace");
      rethrow;
    }
  } on AppException {
    rethrow;
  } on PostgrestException catch (e) {
    logger.e("server-side error: $e");
    throw ServerException(message: "A server-side error occurred", rawError: e);
  } on Exception catch (e) {
    throw NetworkException(message: "A network error occurred", rawError: e);
  } catch (e, _) {
    throw UnknownException(message: errorMessage, rawError: e);
  }
}
