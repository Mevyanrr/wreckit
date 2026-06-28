import 'package:flutter/material.dart';
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
