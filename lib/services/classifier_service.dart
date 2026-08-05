import 'package:flutter_onnxruntime/flutter_onnxruntime.dart';

class LocalClassifierService {
  OrtSession? _session;

  Future<void> init() async {
    try {
      final ort = OnnxRuntime();
      _session = await ort.createSessionFromAsset('assets/models/phishing_model.onnx');
      print('ONNX model loaded successfully!');
    } catch (e) {
      print('Failed to load ONNX model: $e');
    }
  }

  Future<double> predict(String url) async {
    if (_session == null) return 0.0;

    final features = extractFeatures(url);
    
    // Create ONNX OrtValue Float Tensor (batch_size: 1, num_features: features.length)
    final inputTensor = await OrtValue.fromList(features, [1, features.length]);
    final inputName = _session!.inputNames[0];

    try {
      final outputs = await _session!.run({inputName: inputTensor});
      // Extract class probability / risk score from model outputs
      final probabilities = await outputs[_session!.outputNames[1]]?.asList();
      return (probabilities?.last as double? ?? 0.0).clamp(0.0, 1.0);
    } catch (e) {
      print('ONNX Prediction Error: $e');
      return 0.0;
    }
  }

  List<double> extractFeatures(String url) {
    return [
      url.length.toDouble(),
      '.'.allMatches(url).length.toDouble(),
      '-'.allMatches(url).length.toDouble(),
      '@'.allMatches(url).length.toDouble(),
      url.startsWith('https') ? 1.0 : 0.0,
    ];
  }
}