import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/features/screens/home/controller/profile_controller.dart';
import 'package:zic/features/screens/home/screens/home/home.dart';

class MinerChip extends StatelessWidget {
  const MinerChip({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Obx(() {
      final activeMinersCount = controller.activeMiners.value;

      return Container(
        height: 42.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.r),
          gradient: const LinearGradient(
            colors: [Color(0xFF10202D), Color(0xFF0A131B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border.all(color: T.purple.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(color: T.purple.withValues(alpha: 0.25), blurRadius: 10),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: T.purple.withValues(alpha: 0.15),
                border: Border.all(color: T.purple),
              ),
              child: Icon(Icons.bolt_rounded, color: T.purple, size: 14.w),
            ),
            SizedBox(width: 8.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active Miners',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$activeMinersCount',
                  style: TextStyle(
                    color: T.purple,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
