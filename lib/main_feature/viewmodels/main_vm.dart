
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:wreckit/main_feature/models/main_model.dart';

class ScannerViewModel extends ChangeNotifier {
  ScannerModel _state = const ScannerModel();
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  String? _errorMessage;

  ScannerModel get state => _state;
  CameraController? get cameraController => _cameraController;
  bool get isCameraInitialized => _isCameraInitialized;
  bool get isTorchOn => _state.isTorchOn;
  bool get isScanning => _state.isScanning;
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

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}