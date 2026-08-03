import 'package:flutter/material.dart';
import 'package:wreckit/scan_result/models/scanresult_model.dart';

class AnalysisDetailViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AnalysisDetailModel? _analysisDetail;
  AnalysisDetailModel? get analysisDetail => _analysisDetail;

  AnalysisDetailViewModel() {
    fetchAnalysisDetail();
  }

  Future<void> fetchAnalysisDetail() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _analysisDetail = AnalysisDetailModel(
      status: 'AMAN',
      riskScore: 12,
      scannedUrl: 'menu.restoran.com',
      systemSummaries: [
        'Domain telah terdaftar lebih dari 3 tahun dan memiliki reputasi baik.',
        'Sertifikat SSL valid dan diterbitkan oleh otoritas terpercaya.',
        'Tidak terdeteksi adanya URL shortener yang mencurigakan.',
      ],
      engineChecks: [
        EngineCheckItem(
          name: 'VirusTotal',
          weightPercentage: 40,
          description: '0/70 engine mendeteksi ancaman.',
          progress: 0.15,
          icon: Icons.show_chart_rounded,
        ),
        EngineCheckItem(
          name: 'Google Safe Browsing',
          weightPercentage: 35,
          description: 'Tidak ada riwayat phishing/malware.',
          progress: 0.20,
          icon: Icons.language_rounded,
        ),
        EngineCheckItem(
          name: 'IPQualityScore',
          weightPercentage: 15,
          description: 'Reputasi IP bersih, anomali DNS rendah.',
          progress: 0.10,
          icon: Icons.shield_outlined,
        ),
        EngineCheckItem(
          name: 'Heuristic Engine',
          weightPercentage: 10,
          description: 'Pola URL normal, tidak ada typosquatting.',
          progress: 0.08,
          icon: Icons.search_rounded,
        ),
      ],
    );

    _isLoading = false;
    notifyListeners();
  }
}