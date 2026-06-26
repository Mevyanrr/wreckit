
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

class ScanHistoryItem {
  final String id;
  final String imagePath;
  final DateTime scannedAt;
  final String? result;

  const ScanHistoryItem({
    required this.id,
    required this.imagePath,
    required this.scannedAt,
    this.result,
  });
}