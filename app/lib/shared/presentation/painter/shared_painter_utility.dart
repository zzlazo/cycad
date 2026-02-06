import "package:flutter/material.dart";

void drawCenterText(
  String text,
  double width,
  double height,
  double left,
  double top,
  TextStyle style,
  Canvas canvas, {
  double margin = 0,
}) {
  final tp = TextPainter(
    text: TextSpan(text: text, style: style),
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: width);

  final offset = Offset(
    left + (width - tp.width) / 2 + margin,
    top + (height - tp.height) / 2 + margin,
  );

  tp.paint(canvas, offset);
}
