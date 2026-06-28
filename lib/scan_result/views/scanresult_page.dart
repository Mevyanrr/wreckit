import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wreckit/core/AppColors.dart';
import 'package:wreckit/scan_result/viewmodels/analysysandresult_vm.dart';
import 'package:wreckit/scan_result/viewmodels/blockreported_vm.dart';
import 'package:wreckit/scan_result/widgets/core.dart';
import 'package:wreckit/scan_result/widgets/dangerous_card.dart';
import 'package:wreckit/scan_result/widgets/pishing_detected_card.dart'; 
import 'package:wreckit/scan_result/widgets/redirect_chain.dart';
import 'package:wreckit/scan_result/widgets/risk_score_card.dart';
import 'package:wreckit/scan_result/views/block_reported.dart';

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
    final Color dynamicColor = getRiskColor(data.riskScore);
    final String dynamicLabel = getRiskPhishingLabel(data.riskScore);

    return Scaffold(
      backgroundColor: Appcolors.primaryColor,
      appBar: AppBar(
        backgroundColor: Appcolors.primaryColor,
        elevation: 0,
        leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Padding(
          padding: EdgeInsets.only(left: 12.w),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Appcolors.textPrimary,
            size: 20.sp,
          ),
        ),
      ),
        title: Text(
          'QR Forensics',
          style: TextStyle(
            color: Appcolors.textPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.02.sh),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PhishingInfoCard(
              targetUrl: data.targetUrl,       
              riskStatus: dynamicLabel,        
              statusColor: dynamicColor,       
              detectionText: data.riskStatus,  
            ),
            SizedBox(height: 0.02.sh),
            
            RiskScoreCard(riskScore: data.riskScore),
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
            DangerDetailsList(details: data.details, riskScore: data.riskScore),
            SizedBox(height: 0.025.sh),
          
            RedirectChainCard(redirectChain: data.redirectChain),
            SizedBox(height: 0.025.sh),
            
            //button dibawah page
            SizedBox(
  width: double.infinity,
  height: 0.06.sh,
  child: ElevatedButton.icon(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => BlockReportedViewModel(),
            child: const BlockReportedPage(),
          ),
        ),
      );
    },
    icon: Icon(Icons.shield_outlined, color: Colors.white, size: 20.sp),
    label: Text(
      'Block & Report Site',
      style: TextStyle(
        color: Colors.white,
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
      ),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFEF4444),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
      ),
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
}