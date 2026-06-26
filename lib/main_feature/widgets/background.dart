
import 'package:flutter/material.dart';
import 'package:wreckit/core/AppColors.dart';

class CircuitBackgroundPainter extends CustomPainter {
  final double opacity;
  CircuitBackgroundPainter({this.opacity = 1.0});

  static const List<Offset> _dotPositions = [
    Offset(0.20, 0.18),
    Offset(0.50, 0.12),
    Offset(0.78, 0.22),
    Offset(0.15, 0.45),
    Offset(0.60, 0.38),
    Offset(0.85, 0.55),
    Offset(0.30, 0.68),
    Offset(0.55, 0.72),
    Offset(0.75, 0.80),
    Offset(0.10, 0.82),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Appcolors.circuitDot.withOpacity(0.6 * opacity)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Appcolors.circuitDot.withOpacity(0.3 * opacity)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    for (final pos in _dotPositions) {
      final center = Offset(pos.dx * size.width, pos.dy * size.height);
      canvas.drawCircle(center, 2.5, paint);

      canvas.drawLine(
        center.translate(-8, 0),
        center.translate(-3, 0),
        linePaint,
      );
      canvas.drawLine(
        center.translate(0, -8),
        center.translate(0, -3),
        linePaint,
      );
    }

    final faintLine = Paint()
      ..color = Appcolors.accentTealDim.withOpacity(0.08 * opacity)
      ..strokeWidth = 0.5;

    for (int i = 1; i < 6; i++) {
      final y = size.height * i / 6;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), faintLine);
    }
    for (int i = 1; i < 5; i++) {
      final x = size.width * i / 5;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), faintLine);
    }
  }

  @override
  bool shouldRepaint(CircuitBackgroundPainter old) => old.opacity != opacity;
}