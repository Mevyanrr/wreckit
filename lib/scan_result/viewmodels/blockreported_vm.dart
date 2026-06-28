
//BLOCK AND REPORTED PAGE
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wreckit/scan_result/models/scanresult_model.dart';

class BlockReportedViewModel extends ChangeNotifier {
  BlockReportedViewModel({QrReportModel? initialData}) {
    if (initialData != null) {
      _data = initialData;
      _isLoading = false;
    } else {
      _fetchReportStats();
    }
  }

  QrReportModel _data = const QrReportModel(
    reportsCount: 0,
    protectedCount: 0,
    ageInDays: 0,
  );

  bool _isLoading = true;
  String? _errorMessage;

  QrReportModel get data => _data;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> _fetchReportStats() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      
      await Future.delayed(const Duration(milliseconds: 600));
      const result = QrReportModel(
        reportsCount: 43,
        protectedCount: 2100,
        ageInDays: 2,
      );

      _data = result;
    } catch (e) {
      _errorMessage = 'Failed to load report stats.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => _fetchReportStats();

  Future<void> shareWarning() async {
  final message = _buildShareMessage();

  await SharePlus.instance.share(
    ShareParams(
      text: message,
      subject: 'QR Code Threat Warning',
    ),
  );
}

  String _buildShareMessage() {
    return '⚠️ QR Code Threat Warning\n\n'
        'I just blocked a malicious QR code using QRisk.\n\n'
        '• Reports: ${_data.reportsCount}\n'
        '• People protected: ${_data.protectedDisplay}\n'
        '• Threat age: ${_data.ageDisplay}\n\n'
        'This QR has been added to the QRisk threat database and forwarded '
        'to ${_data.forwardedToLabel.replaceFirst('Forwarded to ', '')} for review.\n\n'
        'Stay safe — always verify QR codes before scanning!';
  }
}