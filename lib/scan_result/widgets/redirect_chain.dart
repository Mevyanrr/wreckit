import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wreckit/core/AppColors.dart';

class RedirectChainCard extends StatelessWidget {
  final List<dynamic> redirectChain;

  const RedirectChainCard({super.key, required this.redirectChain});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'REDIRECT CHAIN',
              style: TextStyle(
                color: Appcolors.textMuted,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Appcolors.secondaryColor,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Appcolors.divider),
              ),
              child: Text(
                '${redirectChain.length} hops',
                style: TextStyle(color: Appcolors.textMuted, fontSize: 11.sp),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: redirectChain.length,
          itemBuilder: (context, index) {
            final hop = redirectChain[index];
            final isLast = index == redirectChain.length - 1;
            
            final Color stepColor = isLast
                ? const Color(0xFFEF4444) 
                : (index == 0 ? Appcolors.accentTeal : const Color(0xFFF59E0B)); 

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: stepColor, width: 2.w),
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2.w,
                        height: 75.h,
                        color: const Color(0xFF1E293B), 
                      ),
                  ],
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    padding: EdgeInsets.all(14.r),
                    decoration: BoxDecoration(
                      color: Appcolors.secondaryColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                      color: stepColor,
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                      color: stepColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: Text(
                                      hop.type.toString().toUpperCase(),
                                      style: TextStyle(
                                        color: stepColor,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                hop.title,
                                style: TextStyle(
                                  color: Appcolors.textPrimary,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                hop.subtitle,
                                style: TextStyle(
                                  color: Appcolors.textMuted,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${hop.statusCode}',
                          style: TextStyle(
                            color: isLast ? const Color(0xFFEF4444) : Appcolors.textMuted,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}