import "package:flutter/material.dart";

class SharedLoadingIndicator extends StatelessWidget {
  const SharedLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }
}
