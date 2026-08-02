import 'package:flutter/material.dart';
import 'package:wreckit/scan_result/models/scanresult_model.dart';

class Appcolors {
  static const Color primaryColor = Color(0xFF0A1628);
  static const Color secondaryColor = Color(0xFF0D1E35);
  static const Color scannerBg = Color(0xFF0B1A2E);
  static const Color accentTeal = Color(0xFF2DD4BF);
  static const Color accentTealDim = Color(0xFF1A7A6E);
  static const Color accentTealBorder = Color(0xFF0F5954);
  static const Color tapToScanBg = Color(0xFF0E2A45);
  static const Color tapToScanBorder = Color(0xFF2DD4BF);
  static const Color controlBtnBg = Color(0xFF0F1E30);
  static const Color controlBtnBorder = Color(0xFF1A3050);
  static const Color textPrimary = Color(0xFFCDD9E5);
  static const Color textMuted = Color(0xFF4A6580);
  static const Color textAccent = Color(0xFF2DD4BF);
  static const Color divider = Color(0xFF1A2E45);
  static const Color scanLineTransparent = Color(0x002DD4BF);
  static const Color scanLineOpaque = Color(0xFF2DD4BF);
  static const Color cancelBtnBg = Color(0x330D1E35);
  static const Color circuitDot = Color(0xFF1B3A52);
  static const Color onboard= Color(0xFF8AEBFF);

  static const Color background = Color(0xFF0A0E1A);
  static const Color surfaceCard = Color(0xFF131A2C);
  static const Color surfaceCardBorder = Color(0xFF232B3D);
  static const Color textSecondary = Color(0xFFA0AAB8);
  static const Color textLabel = Color(0xFF6E7887);

  static const Color safe = Color(0xFF3DDC84);
  static const Color safeGlow = Color(0xFF3DDC84);
  static const Color safeButtonBg = Color(0xFF8FE3FF); 
  static const Color safeButtonText = Color(0xFF0A0E1A);
  static const Color warning = Color(0xFFFFA726);
  static const Color warningGlow = Color(0xFFFFA726);
  static const Color danger = Color(0xFFFF4757);
  static const Color dangerGlow = Color(0xFFFF4757);
  static const Color darkButtonBg = Color(0xFF131A2C);
  static const Color darkButtonBorder = Color(0xFF232B3D);

  static const url = Color(0xFF8AEBFF);

  static const card = Color(0xFF141A26);
  static const cardBorder = Color(0xFF1E2634);
  static const textGrey = Color(0xFF8A93A3);

  static const red = Color(0xFFFF4757);
  static const green = Color(0xFF2ED573);
  static const cyan = Color(0xFF5DE0E6);
  static const orange = Color(0xFFFFA502);

  static Color primary(ScanStatus status) {
    switch (status) {
      case ScanStatus.bahaya:
        return red;
      case ScanStatus.aman:
        return green;
      case ScanStatus.waspada:
        return orange;
    }
  }
}
