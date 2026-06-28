import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wreckit/core/AppColors.dart';
import 'package:wreckit/main_feature/viewmodels/scanner_vm.dart';
import 'package:wreckit/main_feature/widgets/animation_scan.dart';
import 'package:wreckit/main_feature/widgets/background.dart';
import 'package:wreckit/main_feature/widgets/corner_scan.dart';
import 'package:wreckit/main_feature/widgets/scannercontrol_button.dart';
import 'package:wreckit/scan_result/viewmodels/analysysandresult_vm.dart';
import 'package:wreckit/scan_result/views/scanresult_page.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScannerViewModel>().initCamera();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }
  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          backgroundColor: const Color(0xFF1A2235),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 28.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 36.w,
                  height: 36.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Appcolors.accentTeal,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToScanResult(String imagePath) async {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => ScanResultViewModel()..loadScanResult(),
          child: const ScanResultPage(),
        ),
      ),
    );
  }

  Future<void> _onTapToScan() async {
    HapticFeedback.mediumImpact();
    final vm = context.read<ScannerViewModel>();

    final path = await vm.captureImage();
    if (path == null || !mounted) return;

    _showLoadingDialog('Processing image...');
    await Future.delayed(const Duration(seconds: 2));

    //simulasi save ke data be
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop(); 

    _showLoadingDialog('Saving scan data...');
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop();

    await _navigateToScanResult(path);
  }

  Future<void> _onUpload() async {
    HapticFeedback.lightImpact();
    final vm = context.read<ScannerViewModel>();

    final path = await vm.pickFileFromDevice();
    if (path == null || !mounted) return;

    _showLoadingDialog('Processing file...');
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop();

    _showLoadingDialog('Saving scan data...');
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop();

    await _navigateToScanResult(path);
  }

  void _onHistory() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/history');
  }

  void _onCancel() {
    HapticFeedback.lightImpact();
    Navigator.maybePop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Appcolors.primaryColor,
        body: FadeTransition(
          opacity: _fadeAnim,
          child: SafeArea(
            child: Column(
              children: [
                _TopBar(onCancel: _onCancel),

                Expanded(
                  child: Consumer<ScannerViewModel>(
                    builder: (context, vm, _) {
                      return Column(
                        children: [
                          SizedBox(height: 20.h),

                          Text(
                            'Point camera at a QR code',
                            style: TextStyle(
                              color: Appcolors.textMuted,
                              fontSize: 14.sp,
                              letterSpacing: 0.2,
                            ),
                          ),

                          SizedBox(height: 20.h),

                          _Viewfinder(
                            cameraController: vm.cameraController,
                            isCameraInitialized: vm.isCameraInitialized,
                            isScanning: vm.isScanning,
                            onTapToScan: _onTapToScan,
                          ),

                          SizedBox(height: 18.h),
                          _SupportedFormats(),

                          const Spacer(),

                          _BottomControls(
                            isTorchOn: vm.isTorchOn,
                            onTorch: vm.toggleTorch,
                            onUpload: _onUpload,
                            onHistory: _onHistory,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final VoidCallback onCancel;
  const _TopBar({required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, top: 8.h, right: 16.w, bottom: 4.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: onCancel,
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: Appcolors.cancelBtnBg,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Appcolors.controlBtnBorder,
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.close_rounded,
                color: Appcolors.textPrimary,
                size: 18.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Viewfinder extends StatelessWidget {
  final CameraController? cameraController;
  final bool isCameraInitialized;
  final bool isScanning;
  final VoidCallback onTapToScan;

  const _Viewfinder({
    required this.cameraController,
    required this.isCameraInitialized,
    required this.isScanning,
    required this.onTapToScan,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _CameraLayer(
                controller: cameraController,
                isInitialized: isCameraInitialized,
              ),
              CustomPaint(painter: CircuitBackgroundPainter()),
              AnimatedScanLine(isActive: true),
              CustomPaint(
                painter: ScannerCornerPainter(
                  cornerLength: 28,
                  strokeWidth: 2.5,
                ),
              ),
              Center(
                child: _TapToScanButton(
                  isScanning: isScanning,
                  onTap: onTapToScan,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CameraLayer extends StatelessWidget {
  final CameraController? controller;
  final bool isInitialized;

  const _CameraLayer({required this.controller, required this.isInitialized});

  @override
  Widget build(BuildContext context) {
    if (isInitialized && controller != null) {
      return CameraPreview(controller!);
    }
    return Container(
      color: Appcolors.scannerBg,
      child: Center(
        child: SizedBox(
          width: 24.w,
          height: 24.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Appcolors.accentTeal.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}

class _TapToScanButton extends StatelessWidget {
  final bool isScanning;
  final VoidCallback onTap;

  const _TapToScanButton({required this.isScanning, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isScanning ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isScanning
              ? Appcolors.tapToScanBg.withOpacity(0.5)
              : Appcolors.tapToScanBg,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isScanning
                ? Appcolors.accentTeal.withOpacity(0.4)
                : Appcolors.tapToScanBorder,
            width: 1,
          ),
        ),
        child: isScanning
            ? SizedBox(
                width: 20.w,
                height: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Appcolors.accentTeal,
                ),
              )
            : Text(
                'Tap to Scan',
                style: TextStyle(
                  color: Appcolors.accentTeal,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
      ),
    );
  }
}

class _SupportedFormats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _FormatChip('Supports QR'),
        _Dot(),
        _FormatChip('Micro QR'),
        _Dot(),
        _FormatChip('Aztec codes'),
      ],
    );
  }
}

class _FormatChip extends StatelessWidget {
  final String text;
  const _FormatChip(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Appcolors.textMuted,
        fontSize: 11.sp,
        letterSpacing: 0.3,
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Text(
        '·',
        style: TextStyle(
          color: Appcolors.textMuted,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}

class _BottomControls extends StatelessWidget {
  final bool isTorchOn;
  final VoidCallback onTorch;
  final VoidCallback onUpload;
  final VoidCallback onHistory;

  const _BottomControls({
    required this.isTorchOn,
    required this.onTorch,
    required this.onUpload,
    required this.onHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
      decoration: BoxDecoration(
        color: Appcolors.secondaryColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Appcolors.divider, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                color: Appcolors.divider,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          Text(
            'SCANNER CONTROLS',
            style: TextStyle(
              color: Appcolors.textMuted,
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.8,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ScannerControlButton(
                icon: Icons.flashlight_on_rounded,
                label: 'Torch',
                isActive: isTorchOn,
                onTap: onTorch,
              ),
              ScannerControlButton(
                icon: Icons.upload_file_rounded,
                label: 'Upload',
                onTap: onUpload,
              ),
              ScannerControlButton(
                icon: Icons.history_rounded,
                label: 'History',
                onTap: onHistory,
              ),
            ],
          ),
        ],
      ),
    );
  }
}