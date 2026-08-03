import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SummarySection extends StatelessWidget {
  final List<String> summaries;

  const SummarySection({Key? key, required this.summaries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: const Color(0xFF63D9F8),
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'Kesimpulan Sistem',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
          decoration: BoxDecoration(
            color: const Color(0xFF131A26),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFF1E2838), width: 1.w),
          ),
          child: Column(
            children: summaries.map((text) {
              return Padding(
                padding: EdgeInsets.only(bottom: text == summaries.last ? 0 : 16.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 6.h),
                      width: 6.w,
                      height: 6.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4DE1FA),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Text(
                        text,
                        style: TextStyle(
                          color: const Color(0xFFB0C0D0),
                          fontSize: 13.sp,
                          height: 1.4,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}