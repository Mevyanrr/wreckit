class ScanResultModel {
  final String targetUrl;
  final int riskScore;
  final String riskStatus;
  final List<WhyDangerousItem> details;
  final List<RedirectHop> redirectChain;

  ScanResultModel({
    required this.targetUrl,
    required this.riskScore,
    required this.riskStatus,
    required this.details,
    required this.redirectChain,
  });
}

class WhyDangerousItem {
  final String title;
  final String value;
  final bool isWarning;

  WhyDangerousItem({
    required this.title,
    required this.value,
    this.isWarning = false,
  });
}

class RedirectHop {
  final int step;
  final String type;
  final String title;
  final String subtitle;
  final int statusCode;

  RedirectHop({
    required this.step,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.statusCode,
  });
}

class QrReportModel {
  final int reportsCount;
  final int protectedCount;
  final int ageInDays;
  final String forwardedToLabel;
  final String forwardedToSubtitle;

  const QrReportModel({
    required this.reportsCount,
    required this.protectedCount,
    required this.ageInDays,
    this.forwardedToLabel = 'Forwarded to BSSN',
    this.forwardedToSubtitle = 'Threat team notified',
  });

  factory QrReportModel.fromJson(Map<String, dynamic> json) {
    return QrReportModel(
      reportsCount: json['reports_count'] as int? ?? 0,
      protectedCount: json['protected_count'] as int? ?? 0,
      ageInDays: json['age_in_days'] as int? ?? 0,
      forwardedToLabel:
          json['forwarded_to_label'] as String? ?? 'Forwarded to BSSN',
      forwardedToSubtitle:
          json['forwarded_to_subtitle'] as String? ?? 'Threat team notified',
    );
  }


  String get protectedDisplay {
    if (protectedCount >= 1000) {
      final value = protectedCount / 1000;
      final isWhole = value == value.roundToDouble();
      return isWhole
          ? '${value.toStringAsFixed(0)}K'
          : '${value.toStringAsFixed(1)}K';
    }
    return protectedCount.toString();
  }

  String get ageDisplay => ageInDays == 1 ? '1 day' : '$ageInDays days';
}