// lib/main_feature/viewmodels/history_vm.dart
import 'package:flutter/foundation.dart';
import '../../services/api_service.dart';

class HistoryViewModel extends ChangeNotifier {
  List<dynamic> _historyList = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters for UI access
  List<dynamic> get historyList => _historyList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch history from API and handle states
  Future<void> loadHistory({String? verdict}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Tell UI we are loading

    try {
      _historyList = await ApiService.fetchHistory(verdict: verdict);
    } catch (e) {
      _errorMessage = "Failed to load history: $e";
    } finally {
      _isLoading = false;
      notifyListeners(); // Tell UI to rebuild with new data/error
    }
  }
}