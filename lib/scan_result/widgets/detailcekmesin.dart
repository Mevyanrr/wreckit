import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wreckit/scan_result/models/scanresult_model.dart';

class EngineCheckCard extends StatelessWidget {
  final EngineCheckItem item;

  const EngineCheckCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF131A26),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFF1E2838), width: 1.w),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: const Color(0xFF1A2636),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF26364A), width: 1.w),
            ),
            child: Icon(
              item.icon,
              color: const Color(0xFF63D9F8),
              size: 20.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.name} (${item.weightPercentage}%)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  item.description,
                  style: TextStyle(
                    color: const Color(0xFF7A8B9E),
                    fontSize: 11.sp,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          SizedBox(
            width: 60.w,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2A3A),
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: item.progress.clamp(0.0, 1.0),
                  child: Container(
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4DE1FA),
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4DE1FA),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}