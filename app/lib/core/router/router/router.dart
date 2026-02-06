import "dart:async";

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

import "../../model/core_model.dart";
import "page/dialog_page.dart";
import "screens.dart";

part "router.g.dart";

@TypedGoRoute<SigninRoute>(
  path: "/signin",
  routes: [TypedGoRoute<SigninInputOtpRoute>(path: "signin-input-otp")],
)
class SigninRoute extends GoRouteData with _$SigninRoute {
  const SigninRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SigninScreen();
}

class SigninInputOtpRoute extends GoRouteData with _$SigninInputOtpRoute {
  const SigninInputOtpRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SigninInputOtpScreen();
}

@TypedGoRoute<HomeRoute>(
  path: "/",
  routes: [
    TypedGoRoute<SelectSeriesRoute>(
      path: "select-series",
      routes: [
        TypedGoRoute<UpdateSeriesRoute>(path: "update-series"),
        TypedGoRoute<ExportSeriesRoute>(path: "export-series"),
        TypedGoRoute<SelectSeriesPresetRoute>(
          path: "select-series-preset",
          routes: [TypedGoRoute<CreateSeriesRoute>(path: "create-series")],
        ),
      ],
    ),
    TypedGoRoute<SelectPlayProjectRoute>(
      path: "select-play-project",
      routes: [
        TypedGoRoute<CreatePlayProjectRoute>(path: "create-play-project"),
        TypedGoRoute<SelectPlayActRoute>(path: "select-play-act"),
        TypedGoRoute<CreatePlayActRoute>(path: "create-play-act"),
        TypedGoRoute<UpdatePlayActRoute>(path: "update-play-act"),
      ],
    ),
    TypedGoRoute<ColorPickerRoute>(path: "color-picker"),
  ],
)
class HomeRoute extends GoRouteData with _$HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

class SelectSeriesRoute extends GoRouteData with _$SelectSeriesRoute {
  const SelectSeriesRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SelectSeriesScreen();
}

class UpdateSeriesRoute extends GoRouteData with _$UpdateSeriesRoute {
  const UpdateSeriesRoute(this.id);

  final int id;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      UpdateSeriesScreen(id: id);
}

class CreateSeriesRoute extends GoRouteData with _$CreateSeriesRoute {
  const CreateSeriesRoute(this.presetId);

  final int presetId;
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      CreateSeriesScreen(presetId: presetId);
}

class SelectSeriesPresetRoute extends GoRouteData
    with _$SelectSeriesPresetRoute {
  const SelectSeriesPresetRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SelectCreateSeriesPresetScreen();
}

class ExportSeriesRoute extends GoRouteData with _$ExportSeriesRoute {
  const ExportSeriesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ExportSeriesScreen();
}

class SelectPlayProjectRoute extends GoRouteData with _$SelectPlayProjectRoute {
  const SelectPlayProjectRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SelectPlayProjectScreen();
}

class CreatePlayProjectRoute extends GoRouteData with _$CreatePlayProjectRoute {
  const CreatePlayProjectRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      CreatePlayProjectScreen();
}

class SelectPlayActRoute extends GoRouteData with _$SelectPlayActRoute {
  final String playId;
  final String title;
  const SelectPlayActRoute(this.playId, this.title);

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SelectPlayActScreen(playId: playId, title: title);
}

class CreatePlayActRoute extends GoRouteData with _$CreatePlayActRoute {
  final String playId;
  final String actId;
  final int sortOrder;
  const CreatePlayActRoute(this.playId, this.actId, this.sortOrder);

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      CreatePlayActScreen(playId: playId, actId: actId, sortOrder: sortOrder);
}

class UpdatePlayActRoute extends GoRouteData with _$UpdatePlayActRoute {
  final String actId;
  final String playId;
  const UpdatePlayActRoute(this.actId, this.playId);

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      UpdatePlayActScreen(actId: actId, playId: playId);
}

abstract class SharedDialogRoute<T> extends GoRouteData {
  const SharedDialogRoute();

  Widget buildDialog(BuildContext context);

  @override
  Page<SharedPopResult<T>> buildPage(
    BuildContext context,
    GoRouterState state,
  ) {
    return DialogPage<SharedPopResult<T>>(
      builder: (context) => buildDialog(context),
    );
  }
}

class ColorPickerRoute extends SharedDialogRoute<void> with _$ColorPickerRoute {
  const ColorPickerRoute(this.initialColorCode);

  final String? initialColorCode;

  @override
  Widget buildDialog(BuildContext context) =>
      SharedColorPickerDialog(initialColorCode: initialColorCode);
}

final List<String> signinRoutes = [
  SigninRoute().location,
  SigninInputOtpRoute().location,
];

FutureOr<String?> redirect(
  BuildContext context,
  GoRouterState state,
  PlayingUser? currentUser,
) async {
  if (currentUser != null && signinRoutes.contains(state.matchedLocation)) {
    return HomeRoute().location;
  } else if (currentUser == null &&
      !signinRoutes.contains(state.matchedLocation)) {
    return SigninRoute().location;
  }

  return null;
}
