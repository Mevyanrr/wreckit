import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wreckit/scan_result/models/scanresult_model.dart';

class ScanResultViewModel extends ChangeNotifier {
  final ScanResultModel result;
  Timer? _timer;

  int secondsLeft = 2;
  bool isAutoOpening = false;

  ScanResultViewModel(this.result) {
    if (result.status == ScanStatus.aman) _startAutoOpenCountdown();
  }

  // Countdown 2 detik lalu "buka browser" otomatis (khusus status Aman)
  void _startAutoOpenCountdown() {
    isAutoOpening = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft <= 1) {
        timer.cancel();
        isAutoOpening = false;
        // TODO: panggil url_launcher untuk buka browser sesungguhnya
      } else {
        secondsLeft--;
      }
      notifyListeners();
    });
  }

  // Dipanggil saat user tekan "Batalkan & Lihat Detail Analisis"
  void cancelAutoOpen() {
    _timer?.cancel();
    isAutoOpening = false;
    notifyListeners();
  }

  // Copy URL ke clipboard + kasih feedback
  Future<void> copyUrl(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: result.url));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Link berhasil disalin'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF1E2634),
        ),
      );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
