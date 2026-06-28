
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wreckit/core/AppColors.dart';

class PhishingInfoCard extends StatelessWidget {
  final String targetUrl;
  final String riskStatus;
  final Color statusColor;     
  final String detectionText;  

  const PhishingInfoCard({
    super.key,
    required this.targetUrl,
    required this.riskStatus,
    required this.statusColor,   
    required this.detectionText,  
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Appcolors.secondaryColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor, 
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      riskStatus == 'LOW RISK' ? Icons.verified_user : Icons.gpp_bad, 
                      size: 14.sp, 
                      color: Colors.white,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      riskStatus,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                detectionText, 
                style: TextStyle(
                  color: statusColor, 
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: const Color(0xFF070F1B),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Target URL',
                  style: TextStyle(
                    color: Appcolors.textMuted,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        targetUrl,
                        style: TextStyle(
                          color: statusColor, 
                          fontSize: 15.sp,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    AnimatedCopyButton(
                      textToCopy: targetUrl,
                      activeColor: statusColor, 
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedCopyButton extends StatefulWidget {
  final String textToCopy;
  final Color activeColor; 
  
  const AnimatedCopyButton({
    super.key, 
    required this.textToCopy,
    required this.activeColor,
  });

  @override
  State<AnimatedCopyButton> createState() => _AnimatedCopyButtonState();
}

class _AnimatedCopyButtonState extends State<AnimatedCopyButton> {
  bool _isGlowing = false;

  void _handleCopy() async {
    if (_isGlowing) return;

    setState(() {
      _isGlowing = true;
    });

    // copy targeturl
    await Clipboard.setData(ClipboardData(text: widget.textToCopy));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('URL copied to clipboard!'),
          backgroundColor: Appcolors.accentTeal,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    
    // efek light icon saat di klik user
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() {
        _isGlowing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _handleCopy,
      borderRadius: BorderRadius.circular(8.r),
      splashColor: widget.activeColor.withOpacity(0.2),
      highlightColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.all(6.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Icon(
            Icons.copy,
            size: 18.sp,
           
            color: _isGlowing ? widget.activeColor : Appcolors.textMuted,
          ),
        ),
      ),
    );
  }
}