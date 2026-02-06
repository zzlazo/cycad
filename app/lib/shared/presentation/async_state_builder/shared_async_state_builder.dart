import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../error_view/shared_error_view.dart";
import "../loading_indicator/shared_loading_indicator.dart";

class SharedAsyncStateBuilder<T> extends StatelessWidget {
  final AsyncValue<T> asyncValue;
  final Widget Function(T value) builder;

  const SharedAsyncStateBuilder({
    super.key,
    required this.asyncValue,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return switch (asyncValue) {
      AsyncLoading() => SharedLoadingIndicator(),
      AsyncError(:final error) => SharedErrorView(message: error.toString()),
      AsyncData(:final value) => builder(value),
      _ => SharedErrorView(message: "Unexpected AsyncValue Type"),
    };
  }
}
