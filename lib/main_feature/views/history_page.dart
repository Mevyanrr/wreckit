import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wreckit/core/AppColors.dart';
import 'package:wreckit/main_feature/viewmodels/history_vm.dart';
import 'package:wreckit/main_feature/widgets/history_card.dart';
import 'package:wreckit/main_feature/widgets/history_date.dart';
import '../models/scanner_model.dart';

class ScanHistoryPage extends StatefulWidget {
  const ScanHistoryPage({super.key});

  @override
  State<ScanHistoryPage> createState() => _ScanHistoryPageState();
}

class _ScanHistoryPageState extends State<ScanHistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScanHistoryViewModel>().loadDummy();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1520),
      appBar: _HistoryAppBar(),
      body: const _HistoryBody(),
    );
  }
}

class _HistoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF0D1520),
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
        'Scan History',
        style: TextStyle(
          color: Appcolors.textPrimary,
          fontSize: 17.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
      centerTitle: true,
    );
  }
}

class _HistoryBody extends StatelessWidget {
  const _HistoryBody();

  @override
  Widget build(BuildContext context) {
    return Consumer<ScanHistoryViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: const Color(0xFF5DADE2),
              strokeWidth: 2.5.w,
            ),
          );
        }
        if (vm.errorMessage != null) return _ErrorState(message: vm.errorMessage!);
        if (vm.isEmpty) return const _EmptyState();

        final groups = vm.groupedHistory;

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: 32.h),
          itemCount: groups.fold<int>(0, (sum, g) => sum + 1 + g.items.length),
          itemBuilder: (context, index) {
            int remaining = index;
            for (int gi = 0; gi < groups.length; gi++) {
              final group = groups[gi];
              if (remaining == 0) {
                return HistoryDateHeader(label: group.label, isFirst: gi == 0);
              }
              remaining--;
              if (remaining < group.items.length) {
                final item = group.items[remaining];
                return HistoryItemCard(
                  item: item,
                  onTap: () => _onItemTap(context, item),
                );
              }
              remaining -= group.items.length;
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  void _onItemTap(BuildContext context, ScanHistoryItem item) {
    debugPrint('Tapped: ${item.id} — ${item.displayLabel}');
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.history_rounded, size: 56.sp, color: const Color(0xFF2A3A55)),
          SizedBox(height: 16.h),
          Text(
            'Belum ada riwayat scan',
            style: TextStyle(
              color: const Color(0xFF6B7A99),
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Scan QR code untuk memulai',
            style: TextStyle(color: const Color(0xFF3D4F6E), fontSize: 13.sp),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 48.sp, color: const Color(0xFFFF5252)),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: const Color(0xFF6B7A99), fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }
}