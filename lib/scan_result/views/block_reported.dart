import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wreckit/core/AppColors.dart';
import 'package:wreckit/scan_result/viewmodels/scanresult_vm.dart';

class BlockReportedPage extends StatelessWidget {
  const BlockReportedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.primaryColor,
      body: SafeArea(
        child: Consumer<BlockReportedViewModel>(
          builder: (context, vm, _) {
            final data = vm.data;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.sp),
              child: Column(
                children: [
                  SizedBox(height: 48.sp),
                  const _SuccessBadge(),
                  SizedBox(height: 28.sp),
                  Text(
                    'Blocked & reported',
                    style: TextStyle(
                      color: Appcolors.textPrimary,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12.sp),
                  Text(
                    'QR blocked on device and added to QRisk\n'
                    'threat database. Others will be warned\n'
                    'automatically.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Appcolors.textMuted,
                      fontSize: 14.sp,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 42.sp),

                  // AnimatedSwitcher(
                  //   duration: const Duration(milliseconds: 3),
                  //   child: vm.isLoading
                  //       ? SizedBox(
                  //           key: const ValueKey('loading'),
                  //           height: 56.sp,
                  //           child: Center(
                  //             child: SizedBox(
                  //               width: 22.sp,
                  //               height: 22.sp,
                  //               child: CircularProgressIndicator(
                  //                 strokeWidth: 2,
                  //                 color: Appcolors.accentTeal,
                  //               ),
                  //             ),
                  //           ),
                  //         )
                  // :
                  Row(
                            key: const ValueKey('stats'),
                            children: [
                              // Container 1: REPORTS
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 4.sp,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 14.sp,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Appcolors.secondaryColor
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(
                                      14.sp,
                                    ),
                                    border: Border.all(
                                      color: Appcolors.controlBtnBorder,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _ShakeAnimation(
                                        value: data.reportsCount.toString(),
                                        style: TextStyle(
                                          color: Appcolors.textPrimary,
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.w700,
                                          height: 1.1,
                                        ),
                                      ),
                                      SizedBox(height: 4.sp),
                                      Text(
                                        'REPORTS',
                                        style: TextStyle(
                                          color: Appcolors.textMuted,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        
                              // Container 2: PROTECTED
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 4.sp,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 14.sp,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Appcolors.secondaryColor
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(
                                      14.sp,
                                    ),
                                    border: Border.all(
                                      color: Appcolors.controlBtnBorder,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                     _ShakeAnimation(
                                        value: data.protectedDisplay,
                                        style: TextStyle(
                                          color: Appcolors.textPrimary,
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w700,
                                          height: 1.1,
                                        ),
                                      ),
                                      SizedBox(height: 4.sp),
                                      Text(
                                        'PROTECTED',
                                        style: TextStyle(
                                          color: Appcolors.textMuted,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        
                              // Container 3: OLD
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 4.sp,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 14.sp,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Appcolors.secondaryColor
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(
                                      14.sp,
                                    ),
                                    border: Border.all(
                                      color: Appcolors.controlBtnBorder,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _ShakeAnimation(
                                        value: data.ageDisplay,
                                        style: TextStyle(
                                          color: Appcolors.textPrimary,
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.w700,
                                          height: 1.1,
                                        ),
                                      ),
                                      SizedBox(height: 4.sp),
                                      Text(
                                        'OLD',
                                        style: TextStyle(
                                          color: Appcolors.textMuted,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                

                  SizedBox(height: 42.sp),

                  // ----- Forwarded-to card -----
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.sp),
                    decoration: BoxDecoration(
                      color: Appcolors.secondaryColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(14.sp),
                      border: Border.all(
                        color: Appcolors.accentTealBorder,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36.sp,
                          height: 36.sp,
                          decoration: BoxDecoration(
                            color: Appcolors.accentTealDim.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(10.sp),
                          ),
                          child: Icon(
                            Icons.shield_outlined,
                            color: Appcolors.accentTeal,
                            size: 18.sp,
                          ),
                        ),
                        SizedBox(width: 12.sp),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.forwardedToLabel,
                                style: TextStyle(
                                  color: Appcolors.textPrimary,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 2.sp),
                              Text(
                                data.forwardedToSubtitle,
                                style: TextStyle(
                                  color: Appcolors.textMuted,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 8.sp,
                          height: 8.sp,
                          decoration: const BoxDecoration(
                            color: Appcolors.accentTeal,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // ----- Buttons -----
                  SizedBox(
                    width: double.infinity,
                    height: 52.sp,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/scanner');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Appcolors.controlBtnBg,
                        foregroundColor: Appcolors.textPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.sp),
                          side: BorderSide(
                            color: Appcolors.controlBtnBorder,
                          ),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Scan another QR',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.sp),
                  SizedBox(
                    width: double.infinity,
                    height: 52.sp,
                    child: OutlinedButton(
                      onPressed: () => vm.shareWarning(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Appcolors.textPrimary,
                        side: BorderSide(color: Appcolors.controlBtnBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.sp),
                        ),
                      ),
                      child: Text(
                        'Share this warning',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.sp),

                  Container(
                    width: 120.sp,
                    height: 4.sp,
                    decoration: BoxDecoration(
                      color: Appcolors.divider,
                      borderRadius: BorderRadius.circular(4.sp),
                    ),
                  ),
                  SizedBox(height: 8.sp),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SuccessBadge extends StatefulWidget {
  const _SuccessBadge();
 
  @override
  State<_SuccessBadge> createState() => _SuccessBadgeState();
}
 
class _SuccessBadgeState extends State<_SuccessBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
 
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }
 
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: 96.sp,
        height: 96.sp,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Appcolors.accentTealDim.withOpacity(0.15),
          border: Border.all(color: Appcolors.accentTealBorder, width: 1.5),
        ),
        child: Icon(
          Icons.check,
          color: Appcolors.accentTeal,
          size: 40.sp,
        ),
      ),
    );
  }
}

 class _ShakeAnimation extends StatefulWidget {
  const _ShakeAnimation({
    required this.value,
    required this.style,
  });
 
  final String value;
  final TextStyle style;
 
  @override
  State<_ShakeAnimation> createState() => _ShakeAnimationState();
}
class _ShakeAnimationState extends State<_ShakeAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotation;
   Timer? _repeatTimer;
 
  // ~30 degrees in radians
  static const double _maxAngle = 0.32;
 
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
 
    // Sequence: 0 -> -30° -> +30° -> -15° -> 0°, settling back to center.
    _rotation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -_maxAngle)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -_maxAngle, end: _maxAngle)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: _maxAngle, end: -_maxAngle * 0.5)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -_maxAngle * 0.5, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 1,
      ),
    ]).animate(_controller);
 
    _controller.forward();
    _repeatTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted) {
        _controller.forward(from: 0);
      }});
  }
 
  @override
  void didUpdateWidget(covariant _ShakeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.forward(from: 0);
    }
  }
 
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotation.value,
          child: child,
        );
      },
      child: Text(
        widget.value,
        style: widget.style,
      ),
    );
  }
}