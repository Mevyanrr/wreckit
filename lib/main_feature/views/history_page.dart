// lib/main_feature/views/history_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wreckit/core/AppColors.dart';
import '../viewmodels/history_vm.dart';
import '../widgets/history_card.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryViewModel _viewModel = HistoryViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.loadHistory();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: const Color(0xFF0D1520),
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Padding(
          padding: EdgeInsets.only(left: 12.w),
          child: Icon(
            Icons.arrow_back,
            color: Appcolors.textPrimary,
            size: 20.sp,
          ),
        ),
      ),
      title: Text(
        'Riwayat Memindai',
        style: TextStyle(
          color: Appcolors.textPrimary,
          fontSize: 17.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
      centerTitle: true,
    ),
      backgroundColor: const Color(0xFF0F1826),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          if (_viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_viewModel.errorMessage != null) {
            return Center(
              child: Text(
                _viewModel.errorMessage!,
                style: const TextStyle(color: Colors.white70),
              ),
            );
          }

          if (_viewModel.historyList.isEmpty) {
            return const Center(
              child: Text(
                "No scan history found.",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => _viewModel.loadHistory(),
            child: ListView.builder(
              itemCount: _viewModel.historyList.length,
              itemBuilder: (context, index) {
                // Directly access the pre-parsed ScanHistoryItem
                final historyItem = _viewModel.historyList[index];

                return HistoryItemCard(
                  item: historyItem,
                );
              },
            ),
          );
        },
      ),
    );
  }
}