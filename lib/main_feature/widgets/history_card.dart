import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wreckit/main_feature/models/scanner_model.dart';
import 'package:wreckit/scan_result/models/scanresult_model.dart';

class HistoryItemCard extends StatelessWidget {
  final ScanHistoryItem item;
  final VoidCallback? onTap;

  const HistoryItemCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final riskLevel = item.riskLevel;
    final riskColor = riskLevel.color;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2235),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            _QrThumbnail(
              imagePath: item.imagePath,
              riskLevel: riskLevel,
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.displayLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    riskLevel.label,
                    style: TextStyle(
                      color: riskColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            _ScoreWidget(score: item.formattedScore, color: riskColor),
          ],
        ),
      ),
    );
  }
}
class _QrThumbnail extends StatelessWidget {
  final String imagePath;
  final RiskLevel riskLevel;

  const _QrThumbnail({required this.imagePath, required this.riskLevel});

  Color get _borderColor => riskLevel.color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFF0F1826),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor.withOpacity(0.35), width: 1.5),
      ),
      clipBehavior: Clip.hardEdge,
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    final file = File(imagePath);
    if (file.existsSync()) return Image.file(file, fit: BoxFit.cover);
    if (imagePath.startsWith('assets/')) {
      return Image.asset(imagePath, fit: BoxFit.cover);
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Center(
      child: Icon(
        riskLevel == RiskLevel.critical
            ? Icons.qr_code_2
            : riskLevel == RiskLevel.suspicious
                ? Icons.warning_amber_rounded
                : Icons.qr_code_rounded,
        color: _borderColor,
        size: 28,
      ),
    );
  }
}

class _ScoreWidget extends StatelessWidget {
  final String score;
  final Color color;
  const _ScoreWidget({required this.score, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          score,
          style: TextStyle(
            color: color,
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
            height: 1,
          ),
        ),
        const SizedBox(height: 3),
        const Text(
          'SCORE',
          style: TextStyle(
            color: Color(0xFF6B7A99),
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}