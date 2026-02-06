import "package:flutter/material.dart";

import "../loading_overlay/shared_loading_overlay.dart";

class SharedBaseScreen extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget body;
  final bool isLoading;

  const SharedBaseScreen({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (isLoading) SharedLoadingOverlay(),
        Scaffold(
          appBar: appBar,
          floatingActionButton: floatingActionButton,
          body: body,
        ),
      ],
    );
  }
}
