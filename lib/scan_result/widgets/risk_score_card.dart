import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wreckit/core/AppColors.dart';
import 'package:wreckit/scan_result/widgets/core.dart';

class RiskScoreCard extends StatelessWidget {
  final int riskScore;

  const RiskScoreCard({super.key, required this.riskScore});

  @override
  Widget build(BuildContext context) {
    final Color currentColor = getRiskColor(riskScore);
    final String currentLabel = getRiskLabel(riskScore);

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Appcolors.secondaryColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Risk Score',
                style: TextStyle(
                  color: Appcolors.textPrimary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$riskScore',
                style: TextStyle(
                  color: currentColor,
                  fontSize: 36.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: riskScore / 100,
              minHeight: 8.h,
              backgroundColor: const Color(0xFF1E293B),
              valueColor: AlwaysStoppedAnimation<Color>(currentColor),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SAFE',
                style: TextStyle(
                  color: riskScore < 40 ? currentColor : Appcolors.textMuted,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                currentLabel,
                style: TextStyle(
                  color: currentColor,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}