import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wreckit/core/AppColors.dart';
import 'package:wreckit/scan_result/viewmodels/scanresult_vm.dart';

class ScanResultPage extends StatefulWidget {
  const ScanResultPage({super.key});

  @override
  State<ScanResultPage> createState() => _ScanResultPageState();
}

class _ScanResultPageState extends State<ScanResultPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScanResultViewModel>().loadScanResult();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScanResultViewModel>();
    final data = viewModel.scanResult;

    if (viewModel.isLoading || data == null) {
      return const Scaffold(
        backgroundColor: Appcolors.primaryColor,
        body: Center(child: CircularProgressIndicator(color: Appcolors.accentTeal)),
      );
    }

    return Scaffold(
      backgroundColor: Appcolors.primaryColor,
      appBar: AppBar(
        backgroundColor: Appcolors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Appcolors.textPrimary, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'QR Forensics',
          style: TextStyle(
            color: Appcolors.textPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5.h,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w, 
          vertical: 0.02.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: Appcolors.secondaryColor,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w, 
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.gpp_bad, size: 14.sp, color: Colors.white),
                            SizedBox(width: 4.w),
                            Text(
                              'HIGH RISK',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Phishing Detected',
                        style: TextStyle(
                          color: const Color(0xFFEF4444),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFF070F1B),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Target URL',
                          style: TextStyle(
                            color: Appcolors.textMuted,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                data.targetUrl,
                                style: TextStyle(
                                  color: const Color(0xFFEF4444),
                                  fontSize: 15.sp,
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Icon(Icons.copy, size: 18.sp, color: Appcolors.textMuted),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 0.02.sh),
            Container(
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
                        '${data.riskScore}',
                        style: TextStyle(
                          color: const Color(0xFFEF4444),
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
                      value: data.riskScore / 100,
                      minHeight: 8.h,
                      backgroundColor: const Color(0xFF1E293B),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFEF4444)),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('SAFE', style: TextStyle(color: Appcolors.textMuted, fontSize: 10.sp, fontWeight: FontWeight.bold)),
                      Text('CRITICAL', style: TextStyle(color: const Color(0xFFEF4444), fontSize: 10.sp, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 0.025.sh),
            Text(
              'WHY IT\'S DANGEROUS',
              style: TextStyle(
                color: Appcolors.textMuted,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              decoration: BoxDecoration(
                color: Appcolors.secondaryColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.details.length,
                separatorBuilder: (context, index) => const Divider(color: Appcolors.divider, height: 1),
                itemBuilder: (context, index) {
                  final item = data.details[index];
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
            ),
            SizedBox(height: 0.025.sh),
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w, 
                    vertical: 2.h,
                  ),
                  decoration: BoxDecoration(
                    color: Appcolors.secondaryColor,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Appcolors.divider),
                  ),
                  child: Text(
                    '${data.redirectChain.length} hops',
                    style: TextStyle(color: Appcolors.textMuted, fontSize: 11.sp),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.redirectChain.length,
              itemBuilder: (context, index) {
                final hop = data.redirectChain[index];
                final isLast = index == data.redirectChain.length - 1;
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
                            border: Border.all(
                              color: isLast
                                  ? const Color(0xFFEF4444)
                                  : (index == 0 ? Appcolors.accentTeal : const Color(0xFFF59E0B)),
                              width: 2.w,
                            ),
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
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6.w, 
                                          vertical: 2.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isLast
                                              ? const Color(0xFFEF4444).withOpacity(0.1)
                                              : (index == 0 ? Appcolors.accentTeal.withOpacity(0.1) : const Color(0xFFF59E0B).withOpacity(0.1)),
                                          borderRadius: BorderRadius.circular(4.r),
                                        ),
                                        child: Text(
                                          hop.type,
                                          style: TextStyle(
                                            color: isLast
                                                ? const Color(0xFFEF4444)
                                                : (index == 0 ? Appcolors.accentTeal : const Color(0xFFF59E0B)),
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
                                    style: TextStyle(color: Appcolors.textPrimary, fontSize: 14.sp, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    hop.subtitle,
                                    style: TextStyle(color: Appcolors.textMuted, fontSize: 12.sp),
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
            SizedBox(height: 0.025.sh),
            SizedBox(
              
              width: double.infinity,
              height: 0.06.sh,
              child: ElevatedButton.icon(
                onPressed: () => viewModel.blockAndReportSite(context),
                icon: Icon(Icons.shield_outlined, color: Colors.white, size: 20.sp),
                label: Text(
                  'Block & Report Site',
                  style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                  elevation: 0,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              height: 0.06.sh,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFF070F1B),
                  side: const BorderSide(color: Color(0xFF1E293B)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                ),
                child: Text(
                  'Scan Another Code',
                  style: TextStyle(color: Appcolors.textPrimary, fontSize: 15.sp, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 0.02.sh),
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Proceed to link/site (on your risk)',
                  style: TextStyle(
                    color: Appcolors.textMuted,
                    fontSize: 13.sp,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            SizedBox(height: 0.015.sh),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline, size: 14.sp, color: Appcolors.accentTeal),
                SizedBox(width: 6.w),
                Text(
                  'SECURED BY QRISK',
                  style: TextStyle(
                    color: Appcolors.textMuted,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.025.sh),
          ],
        ),
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