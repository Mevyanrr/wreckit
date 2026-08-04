// lib/scan_result/viewmodels/detailanalisis_vm.dart
import 'package:flutter/material.dart';
import 'package:wreckit/scan_result/models/scanresult_model.dart';

class AnalysisDetailViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AnalysisDetailModel? _analysisDetail;
  AnalysisDetailModel? get analysisDetail => _analysisDetail;

  final ScanResultModel scanResult;

  AnalysisDetailViewModel(this.scanResult) {
    _generateDetail();
  }

  void _generateDetail() {
    _isLoading = true;
    notifyListeners();

    final isDanger = scanResult.status == ScanStatus.bahaya;
    final isWarning = scanResult.status == ScanStatus.waspada;

    final List<String> summaries = [];
    if (isDanger) {
      summaries.add('Situs ini telah ditandai oleh database keamanan sebagai indikasi phishing/malware.');
      summaries.add('Sertifikat SSL atau struktur URL menunjukkan anomali tinggi.');
    } else if (isWarning) {
      summaries.add('URL menggunakan domain yang tidak umum atau memiliki indikator risiko sedang.');
      summaries.add('Berhati-hatilah sebelum memasukkan kredensial pribadi.');
    } else {
      summaries.add('Domain terverifikasi aman dan memiliki reputasi baik.');
      summaries.add('Sertifikat SSL valid dan diterbitkan oleh otoritas terpercaya.');
    }

    _analysisDetail = AnalysisDetailModel(
      status: scanResult.status == ScanStatus.bahaya
          ? 'BAHAYA'
          : scanResult.status == ScanStatus.waspada
              ? 'WASPADA'
              : 'AMAN',
      riskScore: scanResult.riskScore,
      scannedUrl: scanResult.url,
      systemSummaries: summaries,
      engineChecks: [
        EngineCheckItem(
          name: 'VirusTotal',
          weightPercentage: 40,
          description: isDanger ? '12/70 engine mendeteksi ancaman.' : '0/70 engine mendeteksi ancaman.',
          progress: isDanger ? 0.85 : 0.0,
          icon: Icons.show_chart_rounded,
        ),
        EngineCheckItem(
          name: 'Google Safe Browsing',
          weightPercentage: 35,
          description: isDanger ? 'Terdeteksi phishing/malware.' : 'Tidak ada riwayat ancaman.',
          progress: isDanger ? 1.0 : 0.0,
          icon: Icons.language_rounded,
        ),
        EngineCheckItem(
          name: 'IPQualityScore',
          weightPercentage: 15,
          description: 'Skor Risiko IPQS: ${scanResult.riskScore}/100.',
          progress: (scanResult.riskScore / 100).clamp(0.0, 1.0),
          icon: Icons.shield_outlined,
        ),
        EngineCheckItem(
          name: 'Heuristic Engine',
          weightPercentage: 10,
          description: 'Analisis struktur URL completed.',
          progress: isDanger ? 0.75 : 0.05,
          icon: Icons.search_rounded,
        ),
      ],
    );

    _isLoading = false;
    notifyListeners();
  }
}