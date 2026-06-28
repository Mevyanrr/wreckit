import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryDateHeader extends StatelessWidget {
  final String label;
  final bool isFirst;

  const HistoryDateHeader({
    super.key,
    required this.label,
    this.isFirst = false,
  });

  bool get _isPill => label == 'TODAY';

@override
Widget build(BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(
      left: 16.w,
      right: 16.w,
      top: isFirst ? 8.h : 20.h,
      bottom: 10.h,
    ),
    child: Align(
      alignment: Alignment.centerLeft,
      child: _isPill
          ? _PillLabel(label: label)
          : _PlainLabel(label: label),
    ),
  );
}
}

class _PillLabel extends StatelessWidget {
  final String label;
  const _PillLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2A47),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: const Color(0xFF1E4A7A),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: const Color(0xFF5DADE2),
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.3,
        ),
      ),
    );
  }
}

class _PlainLabel extends StatelessWidget {
  final String label;
  const _PlainLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: const Color(0xFF6B7A99),
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.1,
      ),
    );
  }
}