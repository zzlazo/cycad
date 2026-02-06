import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../repository/repository_utility.dart";

part "shared_provider.g.dart";

@riverpod
DateTime currentTime(Ref ref) {
  return DateTime.now().toUtc();
}

@riverpod
class GlobalLoadingController extends _$GlobalLoadingController
    implements ApiLoadTracker {
  @override
  int build() => 0;

  @override
  void start() => state++;

  @override
  void end() => state--;
}
