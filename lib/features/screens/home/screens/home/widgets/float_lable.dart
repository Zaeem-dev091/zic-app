import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FloatLabel extends StatelessWidget {
  final String label;
  const FloatLabel(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.18),
        fontSize: 11.sp,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}
