import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wreckit/core/AppColors.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: Appcolors.primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 38.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: const _QrScanCard(),
              ),

              SizedBox(height: 44.h),

              Text(
                'Scan. Analyze.\nStay Safe.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w800,
                  color: Appcolors.textPrimary,
                  height: 1.25,
                  letterSpacing: -0.4,
                ),
              ),

              SizedBox(height: 16.h),

              Text(
                'QRisk inspects QR codes for hidden redirect\nchains, phishing URLs, and suspicious metadata\nbefore you ever click.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: Appcolors.textPrimary.withOpacity(0.65),
                  height: 1.65,
                ),
              ),

              SizedBox(height: 40.h),

              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8.w,
                runSpacing: 8.h,
                children: const [
                  _FeatureChip(label: 'REDIRECT CHAIN ANALYSIS'),
                  _FeatureChip(label: 'PHISHING DETECTION'),
                  _FeatureChip(label: 'ORIGIN TRACKING'),
                ],
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 0.06.sh,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/onboarding2');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Appcolors.onboard,
                    foregroundColor: Appcolors.primaryColor,
                    elevation: 0,
                     shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
      ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.1,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(Icons.arrow_forward_ios, size: 20.r),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              Text(
                'No account required  •  Privacy-first analysis',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Appcolors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _QrScanCard extends StatelessWidget {
  const _QrScanCard();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 0.28.sh,
          decoration: BoxDecoration(
            color: Appcolors.scannerBg,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Appcolors.divider, width: 1.5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18.r),
            child: Image.asset(
              'assets/images/image_onboarding.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Appcolors.scannerBg,
                child: Center(
                  child: Icon(
                    Icons.qr_code_2,
                    size: 90.r,
                    color: Appcolors.onboard.withOpacity(0.45),
                  ),
                ),
              ),
            ),
          ),
        ),

        //corner bracket
        Positioned.fill(child: CustomPaint(painter: _CornerBracketPainter())),

        // AI-Powered badge — top right — BREATHING
        Positioned(
          top: -14.h,
          right: -6.w,
          child: _BreathingWidget(
            delay: const Duration(milliseconds: 200),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Appcolors.secondaryColor,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Appcolors.accentTealBorder, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome, size: 14.r, color: Appcolors.onboard),
                  SizedBox(width: 5.w),
                  Text(
                    'AI-Powered',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Appcolors.onboard,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Clock icon — left center — BREATHING
        Positioned(
          left: -18.w,
          top: 0,
          bottom: 0,
          child: Center(
            child: _BreathingWidget(
              delay: const Duration(milliseconds: 600),
              minScale: 0.90,
              maxScale: 1.10,
              child: Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: Appcolors.controlBtnBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: Appcolors.controlBtnBorder, width: 1.2),
                ),
                child: Icon(
                  Icons.access_time_rounded,
                  size: 22.r,
                  color: Appcolors.onboard.withOpacity(0.7),
                ),
              ),
            ),
          ),
        ),

        // Shield icon — right center — BREATHING
        Positioned(
          right: -18.w,
          top: 0,
          bottom: 0,
          child: Center(
            child: _BreathingWidget(
              delay: const Duration(milliseconds: 400),
              child: Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  color: Appcolors.tapToScanBg,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: Appcolors.accentTealDim, width: 1.2),
                ),
                child: Icon(
                  Icons.verified_user_rounded,
                  size: 22.r,
                  color: Appcolors.accentTeal,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

//animasi breath
class _BreathingWidget extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final double minScale;
  final double maxScale;

  const _BreathingWidget({
    required this.child,
    this.delay = Duration.zero,
    this.minScale = 0.94,
    this.maxScale = 1.06,
  });

  @override
  State<_BreathingWidget> createState() => _BreathingWidgetState();
}

class _BreathingWidgetState extends State<_BreathingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _scale = Tween(begin: widget.minScale, end: widget.maxScale).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    _opacity = Tween(begin: 0.70, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => Opacity(
        opacity: _opacity.value,
        child: Transform.scale(scale: _scale.value, child: child),
      ),
      child: widget.child,
    );
  }
}

class _CornerBracketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Appcolors.onboard
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const double len = 22.0;
    const double m = 10.0;
    const double r = 6.0;

    _bracket(canvas, paint, Offset(m, m), len, r, 0);
    _bracket(canvas, paint, Offset(size.width - m, m), len, r, 1);
    _bracket(canvas, paint, Offset(m, size.height - m), len, r, 2);
    _bracket(canvas, paint, Offset(size.width - m, size.height - m), len, r, 3);
  }

  void _bracket(Canvas canvas, Paint p, Offset o, double len, double r, int c) {
    final xd = (c == 1 || c == 3) ? -1.0 : 1.0;
    final yd = (c == 2 || c == 3) ? -1.0 : 1.0;
    final path = Path()
      ..moveTo(o.dx + xd * len, o.dy)
      ..lineTo(o.dx + xd * r, o.dy)
      ..arcToPoint(
        Offset(o.dx, o.dy + yd * r),
        radius: Radius.circular(r),
        clockwise: (c == 0 || c == 3),
      )
      ..lineTo(o.dx, o.dy + yd * len);
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(_) => false;
}


class _FeatureChip extends StatelessWidget {
  final String label;
  const _FeatureChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Appcolors.secondaryColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Appcolors.divider, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w400,
          color: Appcolors.textMuted,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}