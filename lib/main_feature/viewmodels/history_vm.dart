import 'package:flutter/foundation.dart';
import 'package:wreckit/main_feature/models/scanner_model.dart';
import 'package:wreckit/services/db_service.dart';

class HistoryViewModel extends ChangeNotifier {
  List<ScanHistoryItem> _historyList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ScanHistoryItem> get historyList => _historyList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadHistory() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Fetch entries directly from local SQLite database
      _historyList = await DatabaseService.instance.getLocalHistory();
    } catch (e) {
      _errorMessage = 'Failed to load scan history: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}