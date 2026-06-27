import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wreckit/scan_result/models/scanresult_model.dart';

class ScanResultViewModel extends ChangeNotifier {
  ScanResultModel? _scanResult;
  bool _isLoading = false;

  ScanResultModel? get scanResult => _scanResult;
  bool get isLoading => _isLoading;

  void loadScanResult() {
    _isLoading = true;
    notifyListeners();

    _scanResult = ScanResultModel(
      targetUrl: 'phishing-site.info/login/verify',
      riskScore: 62,
      riskStatus: 'Phishing Detected',
      details: [
        WhyDangerousItem(title: 'GENERATOR TOOL', value: 'QR Tiger Pro'),
        WhyDangerousItem(title: 'ORIGIN TIME', value: '2024-11-14 • 03:22 UTC'),
        WhyDangerousItem(title: 'AI DETECTION', value: '94.7% Phishing Probability', isWarning: true),
        WhyDangerousItem(title: 'ENCODED DATA', value: 'URL + Geofence trigger'),
        WhyDangerousItem(title: 'FIRST SEEN', value: '14 hours ago • 2 reports'),
      ],
      redirectChain: [
        RedirectHop(step: 1, type: 'Shortener', title: 'bit.ly', subtitle: 'bit.ly/3xQ9mR7', statusCode: 301),
        RedirectHop(step: 2, type: 'Gateway', title: 'secure-gateway.link', subtitle: 'secure-gateway.link/redirect?id=8f3a', statusCode: 302),
        RedirectHop(step: 3, type: 'Destination', title: 'phishing-site.info', subtitle: 'phishing-site.info/login/verify', statusCode: 200),
      ],
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> blockAndReportSite(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NextPagePlaceholder()),
      );
    }
  }
}

class NextPagePlaceholder extends StatelessWidget {
  const NextPagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0A1628),
      body: Center(
        child: Text(
          'Site Blocked & Reported Successfully',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}


//BLOCK AND REPORTED PAGE
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