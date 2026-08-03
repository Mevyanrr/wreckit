import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wreckit/core/AppColors.dart';
import 'package:wreckit/scan_result/models/scanresult_model.dart';

class StatusVisual extends StatefulWidget {
  final ScanStatus status;
  const StatusVisual({super.key, required this.status});

  @override
  State<StatusVisual> createState() => _StatusVisualState();
}

class _StatusVisualState extends State<StatusVisual>
    with TickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  late final AnimationController _iconCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: Duration(
          milliseconds: widget.status == ScanStatus.bahaya ? 1200 : 1800),
    )..repeat(reverse: true);

    _iconCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _iconCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Appcolors.primary(widget.status);
    final icon = widget.status == ScanStatus.aman
        ? Icons.check
        : Icons.priority_high_rounded;

    return SizedBox(
      width: 200.w,
      height: 200.w,
      child: AnimatedBuilder(
        animation: _pulseCtrl,
        builder: (context, child) {
          final pulse = 0.85 + (_pulseCtrl.value * 0.15);
          return Stack(
            alignment: Alignment.center,
            children: [
              _ring(200.w * pulse, color.withOpacity(0.10)),
              _ring(150.w * pulse, color.withOpacity(0.18)),
              _ring(105.w, color.withOpacity(0.35)),
              child!,
            ],
          );
        },
        child: ScaleTransition(
          scale: CurvedAnimation(parent: _iconCtrl, curve: Curves.elasticOut),
          child: Container(
            width: 78.w,
            height: 78.w,
            decoration: BoxDecoration(
              color: widget.status == ScanStatus.aman
                  ? color
                  : Colors.transparent,
              shape: BoxShape.circle,
              border: widget.status == ScanStatus.aman
                  ? null
                  : Border.all(color: Colors.transparent),
            ),
            child: widget.status == ScanStatus.aman
                ? Icon(icon, color: Appcolors.background, size: 40.sp)
                : CustomPaint(
                    painter: _TrianglePainter(color: color),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _ring(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 1.2.w),
        ),
      );
}

//bahaya sm waspada 
class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);

    final dotPaint = Paint()..color = Appcolors.background;
    canvas.drawRect(
      Rect.fromCenter(
          center: Offset(size.width / 2, size.height * 0.55),
          width: size.width * 0.09,
          height: size.height * 0.28),
      dotPaint,
    );
    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.8),
      size.width * 0.05,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
