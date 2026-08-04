import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:wreckit/main_feature/models/scanner_model.dart';
import 'package:wreckit/scan_result/models/scanresult_model.dart';
import 'package:wreckit/services/api_service.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class ScannerViewModel extends ChangeNotifier {
  ScannerModel _state = const ScannerModel();
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isAnalyzing = false; // Tracks network API call state
  String? _errorMessage;

  ScannerModel get state => _state;
  CameraController? get cameraController => _cameraController;
  bool get isCameraInitialized => _isCameraInitialized;
  bool get isTorchOn => _state.isTorchOn;
  bool get isScanning => _state.isScanning;
  bool get isAnalyzing => _isAnalyzing;
  String? get errorMessage => _errorMessage;

  Future<void> initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        _errorMessage = 'No cameras found on this device.';
        notifyListeners();
        return;
      }

      _cameraController = CameraController(
        _cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();
      _isCameraInitialized = true;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to initialize camera: $e';
      _isCameraInitialized = false;
      notifyListeners();
    }
  }

  Future<String?> captureImage() async {
    if (_cameraController == null || !_isCameraInitialized) return null;

    try {
      _state = _state.copyWith(isScanning: true);
      notifyListeners();

      final XFile image = await _cameraController!.takePicture();

      _state = _state.copyWith(
        isScanning: false,
        capturedImagePath: image.path,
      );
      notifyListeners();

      return image.path;
    } catch (e) {
      _state = _state.copyWith(isScanning: false);
      _errorMessage = 'Failed to capture image: $e';
      notifyListeners();
      return null;
    }
  }

  Future<void> toggleTorch() async {
    if (_cameraController == null || !_isCameraInitialized) return;

    try {
      final newTorchState = !_state.isTorchOn;
      await _cameraController!.setFlashMode(
        newTorchState ? FlashMode.torch : FlashMode.off,
      );
      _state = _state.copyWith(isTorchOn: newTorchState);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to toggle torch: $e';
      notifyListeners();
    }
  }

  Future<String?> pickFileFromDevice() async {
    try {
      final FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        _state = _state.copyWith(capturedImagePath: filePath);
        notifyListeners();
        return filePath;
      }
      return null;
    } catch (e) {
      _errorMessage = 'Failed to pick file: $e';
      notifyListeners();
      return null;
    }
  }

  Future<String?> extractUrlFromImage(String filePath) async {
    final inputImage = InputImage.fromFilePath(filePath);
    final barcodeScanner = BarcodeScanner(formats: [BarcodeFormat.qrCode]);

    final List<Barcode> barcodes = await barcodeScanner.processImage(inputImage);
    await barcodeScanner.close();

    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      return barcodes.first.rawValue; // Returns the actual scanned URL! (e.g. "https://example.com")
    }
    return null;
  }

  // Send raw scanned QR URL payload to FastAPI backend proxy
  Future<ScanResultModel?> analyzeScannedUrl(String rawUrl, {double heuristicScore = 0.0}) async {
    if (_isAnalyzing) return null;

    _isAnalyzing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Post scanned URL to FastAPI backend
      final responseData = await ApiService.scanUrl(
        url: rawUrl,
        heuristicScore: heuristicScore,
      );

      print('DEBUG BACKEND RESPONSE: $responseData');

      // 2. Extract fields from backend response
      final String verdict = (responseData['verdict'] as String?)?.toUpperCase() ?? 'AMAN';
      final String resolvedUrl = responseData['resolved_url'] ?? rawUrl;
      
      // Extract risk score inside the method where responseData exists:
      final int score = ((responseData['risk_score'] ?? responseData['score'] ?? responseData['riskScore']) as num?)?.toInt() ?? 0;

      // 3. Map backend verdict to ScanResultModel factory
      ScanResultModel resultModel;
      switch (verdict) {
        case 'BAHAYA':
          resultModel = ScanResultModel.bahaya(
            url: resolvedUrl,
            score: score,
          );
          break;
        case 'WASPADA':
          resultModel = ScanResultModel.waspada(
            url: resolvedUrl,
            score: score,
          );
          break;
        case 'AMAN':
        default:
          resultModel = ScanResultModel.aman(
            url: resolvedUrl,
            score: score,
          );
          break;
      }

      return resultModel;
    } catch (e) {
      _errorMessage = 'Analysis failed: $e';
      return null;
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}