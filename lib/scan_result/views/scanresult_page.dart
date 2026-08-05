import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wreckit/core/AppColors.dart';
import 'package:wreckit/scan_result/models/scanresult_model.dart';
import 'package:wreckit/scan_result/viewmodels/detailanalisis_vm.dart';
import 'package:wreckit/scan_result/viewmodels/scanresult_vm.dart';
import 'package:wreckit/scan_result/views/detail_analisis.dart';
import 'package:wreckit/scan_result/widgets/action_button.dart';
import 'package:wreckit/scan_result/widgets/status_visual.dart';
import 'package:wreckit/scan_result/widgets/url_analyzed.dart';
class ScanResultPage extends StatelessWidget {
  final ScanResultModel result;
  const ScanResultPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScanResultViewModel(result),
      child: const _ScanResultView(),
    );
  }
}

class _ScanResultView extends StatelessWidget {
  const _ScanResultView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ScanResultViewModel>();
    final result = vm.result;
    final color = Appcolors.primary(result.status);

    return Scaffold(
      backgroundColor: Appcolors.background,
      appBar: AppBar(
        backgroundColor: Appcolors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 20.sp),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'QRisk Forensic',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 24.h),
                  StatusVisual(status: result.status),
                  SizedBox(height: 24.h),
                  Text(
                    result.title,
                    style: TextStyle(
                      color: color,
                      fontSize: result.status == ScanStatus.bahaya
                          ? 30.sp
                          : 32.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (result.subtitle != null) ...[
                    SizedBox(height: 8.h),
                    Text(
                      result.subtitle!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                  SizedBox(height: 10.h),
                  Text(
                    result.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Appcolors.textGrey,
                      fontSize: 13.5.sp,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  UrlAnalyzedCard(result: result, viewModel: vm),
                  if (result.status != ScanStatus.aman) ...[
                    SizedBox(height: 14.h),
                    _DetailAnalysisButton(
                      result: result
                    ),
                  ],
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
          // area tombol tetap menempel di bawah
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
            child: ActionButtons(viewModel: vm),
          ),
        ],
      ),
    );
  }
}

class _DetailAnalysisButton extends StatelessWidget {
  final ScanResultModel result;

  const _DetailAnalysisButton({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
              create: (_) => AnalysisDetailViewModel(result), // result is now defined
              child: const DetailAnalisisScreen(),
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: Appcolors.card,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Appcolors.cardBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Lihat Detail Analisis',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 6.w),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white,
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }
}