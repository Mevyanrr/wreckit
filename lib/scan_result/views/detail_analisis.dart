import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wreckit/scan_result/viewmodels/detailanalisis_vm.dart';
import 'package:wreckit/scan_result/widgets/detailanalisis_header.dart';
import 'package:wreckit/scan_result/widgets/detailcekmesin.dart';
import 'package:wreckit/scan_result/widgets/kesimpulan_card.dart';

class DetailAnalisisScreen extends StatelessWidget {
  const DetailAnalisisScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF0B1017),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0B1017),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Detail Analisis',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Consumer<AnalysisDetailViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF63D9F8)),
                ),
              );
            }

            final data = viewModel.analysisDetail;
            if (data == null) {
              return const Center(
                child: Text(
                  'Gagal memuat data.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderRiskCard(
                    status: data.status,
                    riskScore: data.riskScore,
                    scannedUrl: data.scannedUrl,
                  ),
                  SizedBox(height: 24.h),
                  SummarySection(summaries: data.systemSummaries),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Icon(
                        Icons.dns_outlined,
                        color: const Color(0xFF63D9F8),
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Detail Pengecekan Mesin',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.engineChecks.length,
                    itemBuilder: (context, index) {
                      return EngineCheckCard(item: data.engineChecks[index]);
                    },
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            );
          },
        ),
  
    );
  }
}