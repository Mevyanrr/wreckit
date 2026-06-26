import 'package:flutter/material.dart';
import 'package:wreckit/core/AppColors.dart';

//animation horizontal line
class ScanLine extends StatefulWidget {
  final bool isActive;
  const ScanLine({Key? key, this.isActive = true}) : super(key: key);

  @override
  State<ScanLine> createState() => _ScanLineState();
}

class _ScanLineState extends State<ScanLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _position;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _position = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _position,
      builder: (context, _) {
        return Positioned(
          top: _position.value * double.infinity,
          left: 0,
          right: 0,
          child: _buildLine(),
        );
      },
    );
  }

  Widget _buildLine() {
    return Container(
      height: 2,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Appcolors.scanLineTransparent,
            Appcolors.scanLineOpaque,
            Appcolors.scanLineOpaque,
            Appcolors.scanLineTransparent,
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
      ),
    );
  }
}

class AnimatedScanLine extends StatefulWidget {
  final bool isActive;
  const AnimatedScanLine({Key? key, this.isActive = true}) : super(key: key);

  @override
  State<AnimatedScanLine> createState() => _AnimatedScanLineState();
}

class _AnimatedScanLineState extends State<AnimatedScanLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final position = Curves.easeInOut.transform(_controller.value);
            final top = position * (maxHeight - 2);

            return Stack(
              children: [
                Positioned(
                  top: top,
                  left: 0,
                  right: 0,
                  child: _ScanLineBar(),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _ScanLineBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Glow trail above
        Container(
          height: 24,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x002DD4BF),
                Color(0x202DD4BF),
              ],
            ),
          ),
        ),
        // Main line
        Container(
          height: 2,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0x002DD4BF),
                Color(0xCC2DD4BF),
                Color(0xFF2DD4BF),
                Color(0xCC2DD4BF),
                Color(0x002DD4BF),
              ],
              stops: [0.0, 0.2, 0.5, 0.8, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x882DD4BF),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        Container(
          height: 16,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x202DD4BF),
                Color(0x002DD4BF),
              ],
            ),
          ),
        ),
      ],
    );
  }
}