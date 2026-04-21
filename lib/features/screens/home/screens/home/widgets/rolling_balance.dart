import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/features/screens/home/controller/profile_controller.dart';
import 'package:zic/customization/app_colors.dart';

class RollingBalance extends StatelessWidget {
  final ProfileController controller;
  final double? fontSize;
  final Color? color;

  const RollingBalance({
    required this.controller,
    this.fontSize,
    this.color,
    super.key,
  });

  String _format(double v) {
    return v.toStringAsFixed(8);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Text(
        _format(controller.walletBalance.value),
        style: TextStyle(
          fontSize: fontSize ?? 42.sp,
          color: color ?? ZicColors.cyan,
          fontWeight: FontWeight.w700,
          fontFamily: 'RobotoMono',
        ),
      );
    });
  }
}

class RollingActiveMiners extends StatelessWidget {
  final ProfileController controller;
  final double? fontSize;
  final Color? color;

  const RollingActiveMiners({
    required this.controller,
    this.fontSize,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Text(
        controller.activeMiners.value.toString(),
        style: TextStyle(
          fontSize: fontSize ?? 20.sp,
          color: color ?? Colors.white,
          fontWeight: FontWeight.w700,
          fontFamily: 'RobotoMono',
        ),
      );
    });
  }
}
