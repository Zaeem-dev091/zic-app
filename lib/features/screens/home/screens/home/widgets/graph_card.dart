import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/features/screens/home/controller/referral_controller.dart';
import 'package:zic/features/screens/home/screens/home/home.dart';
import 'package:zic/features/screens/home/screens/home/widgets/network_graph_painters.dart';
import 'package:zic/features/screens/home/screens/home/widgets/steel_panel.dart';
import 'package:zic/features/screens/home/screens/home/widgets/top_handle.dart';
import 'package:zic/features/screens/home/screens/referrals/referral_list_screen.dart';

class GraphCard extends StatelessWidget {
  const GraphCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReferralController>();
    return Obx(() {
      final nodes = controller.totalReferrals;
      return SteelPanel(
        accent: T.cyan,
        onTap: () => Get.to(
          () => const ReferralListScreen(),
          transition: Transition.fadeIn,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Referral Matrix',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 138.h,
              width: double.infinity,
              child: CustomPaint(
                painter: NetworkGraphPainter(
                  activeNodes: nodes,
                  primary: const Color(0xFF6EEBFF),
                  secondary: T.teal,
                ),
                child: SizedBox(
                  width: 50.w,
                  height: 50.w,
                  child: Center(child: Image.asset('assets/images/ref.png')),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            MiningButton(
              label: '($nodes Nodes)',
              color: T.teal,
              fullWidth: true,
            ),
          ],
        ),
      );
    });
  }
}
