import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/customization/app_colors.dart';

void showFeedbackStyleSnackbar({
  required String message,
  required bool success,
  SnackPosition position = SnackPosition.BOTTOM,
  Duration duration = const Duration(seconds: 3),
}) {
  if (Get.isSnackbarOpen) {
    Get.closeCurrentSnackbar();
  }

  Get.snackbar(
    '',
    '',
    titleText: const SizedBox.shrink(),
    messageText: Text(
      message,
      style: TextStyle(fontSize: 13.sp, color: kWhiteColor),
    ),
    snackPosition: position,
    backgroundColor: success ? const Color(0xFF1A2D3D) : const Color(0xFF3C1F25),
    borderColor: success
        ? ZicColors.cyan.withValues(alpha: 0.5)
        : const Color(0xFFF09494).withValues(alpha: 0.45),
    borderWidth: 1,
    borderRadius: 12.r,
    margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
    snackStyle: SnackStyle.FLOATING,
    animationDuration: const Duration(milliseconds: 220),
    duration: duration,
  );
}
