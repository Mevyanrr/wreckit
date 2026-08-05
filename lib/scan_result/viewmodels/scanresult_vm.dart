import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart'; 
import 'package:wreckit/scan_result/models/scanresult_model.dart';

class ScanResultViewModel extends ChangeNotifier {
  final ScanResultModel result;
  Timer? _timer;

  int secondsLeft = 5; 
  bool isAutoOpening = false;

  ScanResultViewModel(this.result) {
    if (result.status == ScanStatus.aman) _startAutoOpenCountdown();
  }

  void _startAutoOpenCountdown() {
    isAutoOpening = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft <= 1) {
        timer.cancel();
        isAutoOpening = false;
        notifyListeners();
        
        openBrowser();
      } else {
        secondsLeft--;
        notifyListeners();
      }
    });
  }

  void cancelAutoOpen() {
    _timer?.cancel();
    isAutoOpening = false;
    notifyListeners();
  }

  Future<void> openBrowser() async {
    cancelAutoOpen(); 

    final Uri uri = Uri.parse(result.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, 
      );
    } else {
      debugPrint('Gagal membuka URL: $uri');
    }
  }
  Future<void> copyUrl(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: result.url));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Link berhasil disalin'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF1E2634),
        ),
      );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}