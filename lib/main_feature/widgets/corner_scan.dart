import 'package:flutter/material.dart';
import 'package:wreckit/core/AppColors.dart';

//L shape corner
class ScannerCornerPainter extends CustomPainter {
  final double cornerLength;
  final double strokeWidth;
  final Color color;

  const ScannerCornerPainter({
    this.cornerLength = 24,
    this.strokeWidth = 2.5,
    this.color = Appcolors.accentTeal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    final double w = size.width;
    final double h = size.height;
    final double cl = cornerLength;

    //top-left
    canvas.drawLine(const Offset(0, 0), Offset(cl, 0), paint);
    canvas.drawLine(const Offset(0, 0), Offset(0, cl), paint);

    //top-right
    canvas.drawLine(Offset(w, 0), Offset(w - cl, 0), paint);
    canvas.drawLine(Offset(w, 0), Offset(w, cl), paint);

    //bottom-left
    canvas.drawLine(Offset(0, h), Offset(cl, h), paint);
    canvas.drawLine(Offset(0, h), Offset(0, h - cl), paint);

    //bottom-right
    canvas.drawLine(Offset(w, h), Offset(w - cl, h), paint);
    canvas.drawLine(Offset(w, h), Offset(w, h - cl), paint);
  }

  @override
  bool shouldRepaint(ScannerCornerPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.cornerLength != cornerLength ||
      oldDelegate.strokeWidth != strokeWidth;
}