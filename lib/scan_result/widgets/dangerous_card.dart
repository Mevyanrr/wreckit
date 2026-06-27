
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wreckit/core/AppColors.dart';

class DangerDetailsList extends StatelessWidget {
  final List<dynamic> details;

  const DangerDetailsList({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Appcolors.secondaryColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: details.length,
        separatorBuilder: (context, index) => const Divider(color: Appcolors.divider, height: 1),
        itemBuilder: (context, index) {
          final item = details[index];
          return Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  _getIconForDetail(item.title),
                  size: 20.sp,
                  color: Appcolors.textMuted,
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          color: Appcolors.textMuted,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        item.value,
                        style: TextStyle(
                          color: item.isWarning ? const Color(0xFFF59E0B) : Appcolors.textPrimary,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (item.isWarning)
                  Icon(Icons.warning_amber_rounded, size: 18.sp, color: const Color(0xFFF59E0B)),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getIconForDetail(String title) {
    switch (title) {
      case 'GENERATOR TOOL':
        return Icons.settings_outlined;
      case 'ORIGIN TIME':
        return Icons.access_time;
      case 'AI DETECTION':
        return Icons.computer;
      case 'ENCODED DATA':
        return Icons.layers_outlined;
      case 'FIRST SEEN':
        return Icons.visibility_outlined;
      default:
        return Icons.info_outline;
    }
  }
}