//SCANNER PAGE MODEL
import 'package:wreckit/scan_result/models/scanresult_model.dart';

class ScannerModel {
  final bool isTorchOn;
  final bool isScanning;
  final String? capturedImagePath;
  final List<ScanHistoryItem> history;

  const ScannerModel({
    this.isTorchOn = false,
    this.isScanning = false,
    this.capturedImagePath,
    this.history = const [],
  });

  ScannerModel copyWith({
    bool? isTorchOn,
    bool? isScanning,
    String? capturedImagePath,
    List<ScanHistoryItem>? history,
  }) {
    return ScannerModel(
      isTorchOn: isTorchOn ?? this.isTorchOn,
      isScanning: isScanning ?? this.isScanning,
      capturedImagePath: capturedImagePath ?? this.capturedImagePath,
      history: history ?? this.history,
    );
  }
}

//HISTORY PAGE MODEL
class ScanHistoryItem {
  final String id;
  final String imagePath;
  final DateTime scannedAt;
  final ScanResultModel? scanResult;

  const ScanHistoryItem({
    required this.id,
    required this.imagePath,
    required this.scannedAt,
    this.scanResult,
  });

  RiskLevel get riskLevel {
    switch (status) {
      case ScanStatus.bahaya:
        return RiskLevel.critical;
      case ScanStatus.waspada:
        return RiskLevel.suspicious;
      case ScanStatus.aman:
      default:
        return RiskLevel.safe;
    }
  }

  String get displayLabel {
    if (scanResult == null) return id;
    final url = scanResult!.url
        .replaceFirst(RegExp(r'https?://'), '')
        .replaceFirst(RegExp(r'www\.'), '');
    return url.length > 22 ? '${url.substring(0, 22)}…' : url;
  }

  int get riskScore => scanResult?.riskScore ?? 0;

  ScanStatus get status => scanResult?.status ?? ScanStatus.aman;

  // Format skor 2 digit (misal: 05, 50, 90)
  String get formattedScore => riskScore.toString().padLeft(2, '0');

  factory ScanHistoryItem.fromBackendMap(Map<String, dynamic> json) {
  final String rawUrl = json['scanned_url']?.toString() ?? '';
  final String verdict = json['verdict']?.toString().toUpperCase() ?? 'AMAN';
  final String id = json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();
  
  // Parse timestamp string safely
  DateTime scannedAt = DateTime.now();
  if (json['created_at'] != null) {
    try {
      scannedAt = DateTime.parse(json['created_at']);
    } catch (_) {}
  }

  // Create the nested ScanResultModel based on verdict
  ScanResultModel resultModel;
  switch (verdict) {
    case 'BAHAYA':
      resultModel = ScanResultModel.bahaya(url: rawUrl);
      break;
    case 'WASPADA':
      resultModel = ScanResultModel.waspada(url: rawUrl);
      break;
    case 'AMAN':
    default:
      resultModel = ScanResultModel.aman(url: rawUrl);
      break;
  }

  return ScanHistoryItem(
    id: id,
    imagePath: '', // Fallback empty string will trigger thumbnail placeholder safely
    scannedAt: scannedAt,
    scanResult: resultModel,
  );
}
}