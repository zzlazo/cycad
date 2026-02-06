import "package:flutter/material.dart";

class SharedModalBarrier extends StatelessWidget {
  const SharedModalBarrier({super.key});

  @override
  Widget build(BuildContext context) {
    return ModalBarrier(dismissible: false, color: Colors.black.withAlpha(180));
  }
}
