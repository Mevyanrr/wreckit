import 'package:flutter/material.dart';
import 'package:wreckit/scan_result/models/scanresult_model.dart';

class ReportViewModel extends ChangeNotifier {
  // Mock Data URL dari Backend
  String _detectedUrl = "link-palsu-qris.top/login";
  String get detectedUrl => _detectedUrl;

  final TextEditingController locationController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setDetectedUrl(String url) {
    _detectedUrl = url;
    notifyListeners();
  }

  Future<bool> sendReport() async {
    _isLoading = true;
    notifyListeners();

    final reportData = ReportModel(
      url: _detectedUrl,
      location: locationController.text.trim(),
      notes: notesController.text.trim(),
    );
    print("Mengirim Data ke Backend: ${reportData.toJson()}");

    // Simulasi delay request network
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();

    return true; // Return true jika berhasil
  }

  @override
  void dispose() {
    locationController.dispose();
    notesController.dispose();
    super.dispose();
  }
}