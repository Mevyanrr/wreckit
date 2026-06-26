import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wreckit/core/AppColors.dart';

class ScannerControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const ScannerControlButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: isActive
                  ? Appcolors.accentTeal.withOpacity(0.15)
                  : Appcolors.controlBtnBg,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isActive
                    ? Appcolors.accentTeal.withOpacity(0.6)
                    : Appcolors.controlBtnBorder,
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: isActive ? Appcolors.accentTeal : Appcolors.textPrimary,
              size: 24.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              color: Appcolors.textMuted,
              fontSize: 11.sp,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}