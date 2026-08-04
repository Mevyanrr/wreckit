import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wreckit/core/AppColors.dart';
import 'package:wreckit/scan_result/models/scanresult_model.dart';
import 'package:wreckit/scan_result/viewmodels/detailanalisis_vm.dart';
import 'package:wreckit/scan_result/viewmodels/scanresult_vm.dart';
import 'package:wreckit/scan_result/views/detail_analisis.dart';
import 'package:wreckit/scan_result/views/lapor_page.dart';


class ActionButtons extends StatelessWidget {
  final ScanResultViewModel viewModel;
  const ActionButtons({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    switch (viewModel.result.status) {
      case ScanStatus.bahaya:
        return _PrimaryButton(
          label: 'Laporkan ke BSSN',
          icon: Icons.shield_rounded,
          color: Appcolors.red,
          textColor: Colors.white,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReportScreen(),
                ),
              );
          },
        );

      case ScanStatus.aman:
        return Column(
          children: [
            _PrimaryButton(
              label: viewModel.isAutoOpening
                  ? 'Membuka browser otomatis... (${viewModel.secondsLeft}s)'
                  : 'Buka Browser',
              icon: Icons.open_in_new_rounded,
              color: Appcolors.cyan,
              textColor: Appcolors.background,
              onTap: () {},
            ),
            SizedBox(height: 12.h),
            _SecondaryButton(
              label: 'Batalkan & Lihat Detail Analisis',
               onTap: () {
    viewModel.cancelAutoOpen();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => AnalysisDetailViewModel(
            scannedUrl: viewModel.result.url
          ),
          child: const DetailAnalisisScreen(),
        ),
      ),
    );
  },
            ),
          ],
        );

      case ScanStatus.waspada:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PrimaryButton(
              label: 'Batalkan Akses',
              icon: Icons.close_rounded,
              color: Appcolors.orange,
              textColor: Appcolors.background,
              onTap: () {},
            ),
            SizedBox(height: 14.h),
            TextButton(
              onPressed: () {},
              child: Text(
                'Buka (Tetap Hati-Hati)',
                style: TextStyle(
                  color: Appcolors.textGrey,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
    }
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: textColor, size: 18.sp),
        label: Text(label,
            style: TextStyle(
                color: textColor,
                fontSize: 15.sp,
                fontWeight: FontWeight.w700)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r)),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _SecondaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Appcolors.cardBorder),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r)),
        ),
        child: Text(label,
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}
