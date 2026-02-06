import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../app_theme.dart";

part "app_theme_provider.g.dart";

@riverpod
ThemeData themeData(Ref ref) {
  final ThemeData themeData = AppDarkTheme.darkTheme;
  return themeData;
}
