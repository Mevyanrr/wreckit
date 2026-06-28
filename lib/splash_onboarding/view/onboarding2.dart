import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wreckit/core/AppColors.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: Appcolors.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              SizedBox(height: 24.h),

              const _ShieldHero(),

              SizedBox(height: 28.h),

              Text(
                'Before You Begin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 23.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),

              SizedBox(height: 10.h),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Appcolors.textPrimary.withOpacity(0.65),
                    height: 1.55,
                  ),
                  children: [
                    const TextSpan(
                      text: 'QRisk needs camera access to scan QR codes.\n',
                    ),
                    TextSpan(
                      text: "Here's our privacy commitment.",
                      style: TextStyle(
                        color: Appcolors.onboard,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 28.h),

              _PermissionCard(
                icon: Icons.camera_alt_outlined,
                title: 'Camera Access',
                description:
                    'Used only to scan QR codes. Your visual data is processed in real-time and is never recorded or stored on disk.',
              ),

              SizedBox(height: 12.h),

              _PermissionCard(
                icon: Icons.location_off_outlined,
                title: 'No Location Data',
                description:
                    'QRisk never requests or stores your GPS coordinates. Forensic analysis is metadata-driven only.',
              ),

              SizedBox(height: 12.h),

              _PermissionCard(
                icon: Icons.notifications_active_outlined,
                title: 'Threat Notifications',
                description:
                    'Optional forensic alerts delivered locally to your device when high-risk malicious codes are detected.',
              ),

              SizedBox(height: 16.h),

              const _PrivacyBanner(),

              SizedBox(height: 24.h),

              SizedBox(
                width: double.infinity,
                height: 0.06.sh,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/scanner'),
                   style: ElevatedButton.styleFrom(
                    backgroundColor: Appcolors.onboard,
                    foregroundColor: Appcolors.primaryColor,
                    elevation: 0,
                     shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
      ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_outlined, size: 20.r),
                      SizedBox(width: 8.w),
                      Text(
                        'Enable Camera Access',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 28.h),
            ],
          ),
          ),
        ),
        ),
      
    );
  }
}



class _ShieldHero extends StatefulWidget {
  const _ShieldHero();

  @override
  State<_ShieldHero> createState() => _ShieldHeroState();
}

class _ShieldHeroState extends State<_ShieldHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
    _pulse = Tween(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120.r,
      height: 120.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer breathing ring
          AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => Transform.scale(
              scale: _pulse.value,
              child: Container(
                width: 95.r,
                height: 95.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Appcolors.accentTeal.withOpacity(0.15),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),

          // Middle ring
          // Container(
          //   width: 86.r,
          //   height: 86.r,
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     color: Appcolors.secondaryColor,
          //     border: Border.all(
          //       color: Appcolors.accentTeal.withOpacity(0.25),
          //       width: 1.2,
          //     ),
          //   ),
          // ),

          // Shield icon center
          Container(
            width: 64.r,
            height: 64.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Appcolors.scannerBg,
              border: Border.all(
                color: Appcolors.accentTealBorder,
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.security_rounded,
              size: 30.r,
              color: Appcolors.onboard,
            ),
          ),

          // Green check badge — bottom center
          Positioned(
            bottom: 0,
            child: Container(
              width: 24.r,
              height: 24.r,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF22C55E),
              ),
              child: Icon(
                Icons.check_rounded,
                size: 15.r,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _PermissionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _PermissionCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Appcolors.secondaryColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Appcolors.divider, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon box
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: Appcolors.scannerBg,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Appcolors.controlBtnBorder, width: 1),
            ),
            child: Icon(icon, size: 20.r, color: Appcolors.onboard),
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Appcolors.textPrimary.withOpacity(0.55),
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _PrivacyBanner extends StatelessWidget {
  const _PrivacyBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Appcolors.primaryColor,
        borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Appcolors.controlBtnBorder, width: 1.5),
        
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 20.r,
            color: Appcolors.onboard,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'ALL ANALYSIS RUNS ON-DEVICE. YOUR QR SCAN DATA IS NEVER UPLOADED TO EXTERNAL SERVERS.',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: Appcolors.onboard,
                letterSpacing: 0.5,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}