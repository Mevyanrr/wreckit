import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetectedUrlCard extends StatelessWidget {
  final String url;

  const DetectedUrlCard({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFF141A29),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFFF5252), 
          width: 1.5.w,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.link_off_rounded,
            color: const Color(0xFFFF6584),
            size: 22.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              url,
              style: TextStyle(
                color: const Color(0xFFFF6584),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'monospace',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 8.w),
          Icon(
            Icons.lock_outline_rounded,
            color: const Color(0xFF6C757D),
            size: 18.sp,
          ),
        ],
      ),
    );
  }
}