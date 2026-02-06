import "package:flutter/material.dart";

import "../../../../shared/presentation/painter/shared_painter_utility.dart";
import "../../model/model/concept_series_model.dart";

class ExportSeriesPreviewWidget extends StatelessWidget {
  const ExportSeriesPreviewWidget({
    super.key,
    required this.concepts,
    required this.style,
  });
  final List<CardConcept> concepts;
  final ExportSeriesStyle style;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 10),
      itemCount: concepts.length,
      itemBuilder: (context, index) {
        final concept = concepts[index];
        return SizedBox(
          width: style.size.width.toDouble(),
          height: style.size.height.toDouble(),
          child: CustomPaint(
            painter: CardConceptPainter(concept: concept, style: style),
          ),
        );
      },
    );
  }
}

class CardConceptPainter extends CustomPainter {
  final CardConcept concept;
  final ExportSeriesStyle style;
  CardConceptPainter({required this.concept, required this.style});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = style.backgroundColor;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(12),
    );
    canvas.drawRRect(rect, paint);
    drawCenterText(
      "${concept.code.suit.name} ${concept.code.number.name}",
      rect.width,
      20,
      rect.left,
      rect.top + 40,
      style.codeStyle,
      canvas,
    );
    // suit and number
    drawCenterText(
      concept.concept,
      rect.width - 20 * 2,
      rect.height - 20 - 20,
      rect.left + 20,
      rect.top + 20 + 20,
      style.bodyStyle,
      canvas,
    );
  }

  @override
  bool shouldRepaint(covariant CardConceptPainter oldDelegate) => true;
}
