// lib/main_feature/views/history_page.dart
import 'package:flutter/material.dart';
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
        title: const Text("Scan History"),
        backgroundColor: const Color(0xFF0F1826),
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