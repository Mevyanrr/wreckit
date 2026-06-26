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