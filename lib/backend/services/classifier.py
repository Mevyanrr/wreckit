# lib/backend/services/classifier.py
from pathlib import Path
import onnxruntime as ort
import numpy as np

# Load extended ONNX ML operators for tree models
try:
    from onnxruntime_extensions import get_library_path
    HAS_EXTENSIONS = True
except ImportError:
    HAS_EXTENSIONS = False

# Navigate from classifier.py -> services -> backend root directory
BASE_DIR = Path(__file__).resolve().parent.parent

# Resolves to: .../backend/models/phishing_model.onnx
MODEL_PATH = BASE_DIR / "models" / "phishing_model.onnx"

class ServerMLClassifier:
    def __init__(self, model_path: Path = MODEL_PATH):
        try:
            # Configure ONNX session options to include custom ML ops library
            session_options = ort.SessionOptions()
            if HAS_EXTENSIONS:
                session_options.register_custom_ops_library(get_library_path())

            # Convert Path to string for ONNX Runtime
            self.session = ort.InferenceSession(str(model_path), sess_options=session_options)
            self.input_name = self.session.get_inputs()[0].name
            
            outputs = self.session.get_outputs()
            self.output_name = outputs[1].name if len(outputs) > 1 else outputs[0].name
            print(f"[INFO] Server ML ONNX model loaded successfully from {model_path}")
        except Exception as e:
            print(f"[ERROR] Failed to load ONNX model: {e}")
            self.session = None

    def extract_features(self, url: str) -> np.ndarray:
        features = [
            float(len(url)),
            float(url.count('.')),
            float(url.count('-')),
            float(url.count('@')),
            1.0 if url.startswith('https') else 0.0,
        ]
        return np.array([features], dtype=np.float32)

    def predict(self, url: str) -> float:
        if not self.session:
            return 0.0

        try:
            input_data = self.extract_features(url)
            outputs = self.session.run(None, {self.input_name: input_data})
            
            probs = outputs[1] if len(outputs) > 1 else outputs[0]
            
            if isinstance(probs, list) and isinstance(probs[0], dict):
                return float(probs[0].get(1, 0.0))
            elif isinstance(probs, np.ndarray):
                # Handles 2D probability outputs like [[prob_clean, prob_phishing]]
                if probs.ndim == 2 and probs.shape[1] > 1:
                    return float(probs[0][1])
                return float(probs[0][-1])
            
            return 0.0
        except Exception as e:
            print(f"[ERROR] ML Prediction failed: {e}")
            return 0.0

# Singleton instance
ml_service = ServerMLClassifier()