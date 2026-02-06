import "package:flutter/material.dart";

import "../loading_indicator/shared_loading_indicator.dart";
import "../modal_barrier/shared_modal_barrier.dart";

class SharedLoadingOverlay extends StatelessWidget {
  const SharedLoadingOverlay({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SharedModalBarrier(),
        Center(child: SharedLoadingIndicator()),
      ],
    );
  }
}
