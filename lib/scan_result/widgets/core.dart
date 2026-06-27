
import 'package:flutter/material.dart';

Color getRiskColor(int score) {
  if (score < 40) {
    return const Color(0xFF22C55E);
  } else if (score < 70) {
    return const Color(0xFFF59E0B); 
  } else {
    return const Color(0xFFEF4444); 
  }
}

String getRiskPhishingLabel(int score) {
  if (score < 40) return 'LOW RISK';
  if (score < 70) return 'MEDIUM RISK';
  return 'HIGH RISK';
} 
String getRiskLabel(int score) {
  if (score < 40) return 'SAFE';
  if (score < 70) return 'WARNING';
  return 'CRITICAL';
}