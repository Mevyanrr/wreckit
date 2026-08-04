import 'package:flutter/material.dart';

enum ScanStatus { bahaya, aman, waspada }

enum RiskLevel { safe, suspicious, critical }

class ScanResultModel {
  final ScanStatus status;
  final int riskScore; // Now dynamically populated from API response
  final String title;
  final String? subtitle;
  final String description;
  final String url;
  final String urlLabel;
  final List<String>? badges;

  const ScanResultModel({
    required this.status,
    required this.riskScore,
    required this.title,
    this.subtitle,
    required this.description,
    required this.url,
    required this.urlLabel,
    this.badges,
  });

  String get targetUrl => url;

  String get riskStatus {
    switch (status) {
      case ScanStatus.bahaya:
        return 'critical';
      case ScanStatus.waspada:
        return 'suspicious';
      case ScanStatus.aman:
        return 'safe';
    }
  }

  // Determine status enum dynamically from a numeric risk score
  static ScanStatus statusFromScore(int score) {
    if (score >= 66) {
      return ScanStatus.bahaya;
    } else if (score >= 26) {
      return ScanStatus.waspada;
    } else {
      return ScanStatus.aman;
    }
  }

  // Dynamic constructor from JSON backend response
  factory ScanResultModel.fromJson(Map<String, dynamic> json) {
    final int score = (json['risk_score'] as num?)?.toInt() ?? 0;
    final ScanStatus computedStatus = statusFromScore(score);
    final String urlStr = json['scanned_url'] ?? json['url'] ?? '';

    switch (computedStatus) {
      case ScanStatus.bahaya:
        return ScanResultModel.bahaya(url: urlStr, score: score);
      case ScanStatus.waspada:
        return ScanResultModel.waspada(url: urlStr, score: score);
      case ScanStatus.aman:
      default:
        return ScanResultModel.aman(url: urlStr, score: score);
    }
  }

  factory ScanResultModel.bahaya({required String url, int score = 90}) =>
      ScanResultModel(
        status: ScanStatus.bahaya,
        riskScore: score,
        title: 'Bahaya',
        subtitle: 'Situs Penipuan Ditemukan',
        description:
            'Tautan ini terbukti sebagai situs penipuan (phishing). Akses diblokir untuk melindungi data dan uang Anda.',
        url: url,
        urlLabel: 'MALICIOUS URL DETECTED',
      );

  factory ScanResultModel.aman({required String url, int score = 5}) =>
      ScanResultModel(
        status: ScanStatus.aman,
        riskScore: score,
        title: 'Aman',
        description:
            'Tidak ada tanda-tanda penipuan. Tautan ini aman untuk dikunjungi.',
        url: url,
        urlLabel: 'URL TERANALISIS',
        badges: const ['SSL VERIFIED', 'NO PHISHING FOUND'],
      );

  factory ScanResultModel.waspada({required String url, int score = 50}) =>
      ScanResultModel(
        status: ScanStatus.waspada,
        riskScore: score,
        title: 'Waspada',
        description:
            'Tautan ini menggunakan alamat yang tidak biasa. Berhati-hatilah sebelum memasukkan data pribadi atau melakukan pembayaran.',
        url: url,
        urlLabel: 'URL TERANALISIS',
      );
}

extension RiskLevelExtension on RiskLevel {
  Color get color {
    switch (this) {
      case RiskLevel.critical:
        return const Color(0xFFFF4C4C);
      case RiskLevel.suspicious:
        return const Color(0xFFFFB020);
      case RiskLevel.safe:
      default:
        return const Color(0xFF00E676);
    }
  }

  String get label {
    switch (this) {
      case RiskLevel.critical:
        return 'BAHAYA';
      case RiskLevel.suspicious:
        return 'WASPADA';
      case RiskLevel.safe:
      default:
        return 'AMAN';
    }
  }
}

class EngineCheckItem {
  final String name;
  final int weightPercentage;
  final String description;
  final double progress;
  final IconData icon;

  EngineCheckItem({
    required this.name,
    required this.weightPercentage,
    required this.description,
    required this.progress,
    required this.icon,
  });

  factory EngineCheckItem.fromJson(Map<String, dynamic> json) {
    return EngineCheckItem(
      name: json['name'] ?? '',
      weightPercentage: json['weight_percentage'] ?? 0,
      description: json['description'] ?? '',
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      icon: json['icon'] ?? Icons.security,
    );
  }
}

class AnalysisDetailModel {
  final String status;
  final int riskScore;
  final String scannedUrl;
  final List<String> systemSummaries;
  final List<EngineCheckItem> engineChecks;

  AnalysisDetailModel({
    required this.status,
    required this.riskScore,
    required this.scannedUrl,
    required this.systemSummaries,
    required this.engineChecks,
  });

  factory AnalysisDetailModel.fromJson(Map<String, dynamic> json) {
    return AnalysisDetailModel(
      status: json['status'] ?? 'AMAN',
      riskScore: json['risk_score'] ?? 0,
      scannedUrl: json['scanned_url'] ?? '',
      systemSummaries: List<String>.from(json['system_summaries'] ?? []),
      engineChecks: (json['engine_checks'] as List? ?? [])
          .map((item) => EngineCheckItem.fromJson(item))
          .toList(),
    );
  }
}

class ReportModel {
  final String url;
  final String? location;
  final String? notes;

  ReportModel({
    required this.url,
    this.location,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'location': location ?? '',
      'notes': notes ?? '',
    };
  }
}