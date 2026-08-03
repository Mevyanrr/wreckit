import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wreckit/scan_result/viewmodels/lapor_vm.dart';
import 'package:wreckit/scan_result/widgets/catatan_lapor.dart';
import 'package:wreckit/scan_result/widgets/location_lapor_card.dart';
import 'package:wreckit/scan_result/widgets/url_lapor_card.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReportViewModel(),
      child: Scaffold(
        backgroundColor: const Color(0xFF0B0F19), 
        appBar: AppBar(
          backgroundColor: const Color(0xFF0B0F19),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 22.sp),
            onPressed: () => Navigator.maybePop(context),
          ),
          title: Text(
            "Laporkan Ancaman",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: Consumer<ReportViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader("TUJUAN LAPORAN"),
                  SizedBox(height: 8.h),
                  const ReportDestinationCard(),
                  
                  SizedBox(height: 24.h),
                  _buildSectionHeader("URL TERDETEKSI"),
                  SizedBox(height: 8.h),
                  DetectedUrlCard(url: viewModel.detectedUrl),

                  SizedBox(height: 24.h),
                  _buildSectionHeader("LOKASI PENEMUAN (OPSIONAL)"),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: viewModel.locationController,
                    hintText: "Misal: Kasir Restoran X, Jakarta",
                    prefixIcon: Icons.location_on_outlined,
                  ),

                  SizedBox(height: 24.h),
                  _buildSectionHeader("CATATAN TAMBAHAN (OPSIONAL)"),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: viewModel.notesController,
                    hintText: "Deskripsikan stiker QR atau konteks penemuan...",
                    maxLines: 4,
                  ),

                  SizedBox(height: 32.h),
                  
                  // Tombol Kirim
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: viewModel.isLoading
                          ? null
                          : () async {
                              bool success = await viewModel.sendReport();
                              if (success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Laporan berhasil dikirim!"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF70E0F8),
                        foregroundColor: const Color(0xFF0B0F19),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: viewModel.isLoading
                          ? SizedBox(
                              height: 20.h,
                              width: 20.h,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF0B0F19),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.send_rounded, size: 18.sp),
                                SizedBox(width: 8.w),
                                Text(
                                  "Kirim Laporan",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  SizedBox(height: 16.h),
                  Center(
                    child: Text(
                      "ENKRIPSI AES-256 AKTIF • LAPORAN ANONIM AMAN",
                      style: TextStyle(
                        color: const Color(0xFF4C586E),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        color: const Color(0xFF6C7C93),
        fontSize: 11.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.1,
      ),
    );
  }
}