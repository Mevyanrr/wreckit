import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wreckit/core/AppColors.dart';
import 'package:wreckit/scan_result/models/scanresult_model.dart';
import 'package:wreckit/scan_result/viewmodels/scanresult_vm.dart';

class UrlAnalyzedCard extends StatelessWidget {
  final ScanResultModel result;
  final ScanResultViewModel viewModel;
  const UrlAnalyzedCard(
      {super.key, required this.result, required this.viewModel});

  IconData get _icon {
    switch (result.status) {
      case ScanStatus.bahaya:
        return Icons.link_off_rounded;
      case ScanStatus.aman:
        return Icons.link_rounded;
      case ScanStatus.waspada:
        return Icons.link_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Appcolors.primary(result.status);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Appcolors.card,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Appcolors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            result.urlLabel,
            style: TextStyle(
              color: Appcolors.textGrey,
              fontSize: 11.sp,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10.h),
          InkWell(
            borderRadius: BorderRadius.circular(8.r),
            onTap: () => viewModel.copyUrl(context),
            child: Row(
              children: [
                Icon(_icon, color: color, size: 18.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    result.url,
                    style: TextStyle(
                      color: Appcolors.url,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(Icons.copy_rounded,
                    color: Appcolors.textGrey, size: 16.sp),
              ],
            ),
          ),
          // if (result.badges != null) ...[
          //   SizedBox(height: 12.h),
          //   Wrap(
          //     spacing: 8.w,
          //     runSpacing: 8.h,
          //     children: result.badges!
          //         .map((b) => BadgeChip(label: b, color: color))
          //         .toList(),
          //   ),
          // ],
        ],
      ),
    );
  }
}
