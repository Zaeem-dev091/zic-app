import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/features/screens/home/controller/referral_controller.dart';
import 'package:zic/features/screens/home/screens/home/home.dart';
import 'package:zic/features/screens/home/screens/home/widgets/network_graph_painters.dart';
import 'package:zic/features/screens/home/screens/home/widgets/steel_panel.dart';
import 'package:zic/features/screens/home/screens/home/widgets/top_handle.dart';
import 'package:zic/features/screens/home/screens/referrals/referral_invite.dart';

class MatrixCard extends StatelessWidget {
  const MatrixCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReferralController>();
    return Obx(() {
      final nodes = controller.totalReferrals;
      final connected = math.min(nodes, 2);
      return SteelPanel(
        accent: T.teal,
        onTap: () => Get.to(
          () => const ReferralInviteScreen(),
          transition: Transition.fadeIn,
        ),
        child: Column(
          children: [
            Text(
              'Invite Core',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              height: 100.h,
              width: double.infinity,
              child: CustomPaint(
                painter: CoreLinkPainter(leftGlow: T.teal, rightGlow: T.gold),
              ),
            ),
            SizedBox(height: 6.h),
            Row(
              children: [
                Expanded(
                  child: NodeCounter(value: '$nodes', color: T.teal),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: NodeCounter(value: '$connected', color: T.gold),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            MiningButton(
              label: '($connected Connected)',
              color: T.teal,
              fullWidth: true,
            ),
          ],
        ),
      );
    });
  }
}
