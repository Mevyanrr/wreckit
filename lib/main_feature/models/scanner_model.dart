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


String get displayLabel {
    if (scanResult == null) return id;
    final url = scanResult!.targetUrl
        .replaceFirst(RegExp(r'https?://'), '')
        .replaceFirst(RegExp(r'www\.'), '');
    return url.length > 22 ? '${url.substring(0, 22)}…' : url;
  }
 
  int get riskScore => scanResult?.riskScore ?? 0;
 
  String get riskStatus => scanResult?.riskStatus ?? 'safe';
 
  RiskLevel get riskLevel => RiskLevelX.fromStatus(riskStatus);
 
  /// Score dengan zero-padding dua digit, e.g. "02", "91"
  String get formattedScore => riskScore.toString().padLeft(2, '0');
}