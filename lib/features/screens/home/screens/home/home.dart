import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/features/screens/home/controller/profile_controller.dart';
import 'package:zic/features/screens/home/controller/referral_controller.dart';
import 'package:zic/features/screens/home/screens/home/dailyReward/dailyreward.dart';
import 'package:zic/features/screens/home/screens/home/spining_wheel/spinwheel_dialog.dart';
import 'package:zic/features/screens/home/screens/home/widgets/achievement_card.dart';
import 'package:zic/features/screens/home/screens/home/widgets/bottom_row.dart';
import 'package:zic/features/screens/home/screens/home/widgets/graph_card.dart';
import 'package:zic/features/screens/home/screens/home/widgets/header_bar.dart';
import 'package:zic/features/screens/home/screens/home/widgets/hero_balance_card.dart';
import 'package:zic/features/screens/home/screens/home/widgets/matrix_card.dart';
import 'package:zic/features/screens/home/screens/home/spining_wheel/controller.dart';
import 'package:zic/features/screens/home/screens/home/widgets/streak_card.dart';
import 'package:zic/features/screens/home/screens/home/widgets/totalBalance.dart';

abstract class T {
  static const cyan = Color(0xFF53F7FF);
  static const purple = Color(0xFF8A79FF);
  static const teal = Color(0xFF54E8C5);
  static const gold = Color(0xFFE8D59B);
  static const goldBorder = Color(0xFFB89246);
  static const green = Color(0xFF60F7A7);

  static const panelGrad = [
    Color(0xFF182430),
    Color(0xFF0D1622),
    Color(0xFF08111B),
  ];
  static const steelGrad = [
    Color(0xFF44515E),
    Color(0xFF2A3541),
    Color(0xFF3D4853),
  ];
  static const steelBorder = Color(0xFF85909C);
}

// ─────────────────────────────────────────────────────────────
//  Screen root
// ─────────────────────────────────────────────────────────────

class HomeScreen extends GetView<ProfileController> {
  const HomeScreen({super.key});
  ReferralController get _ref => Get.find<ReferralController>();

  void _showSpinWheelDialog() {
    if (!Get.isRegistered<SpinWheelControllerX>()) {
      Get.put(SpinWheelControllerX());
    }

    Get.dialog(
      const SpinWheelDialog(),
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SpinWheelControllerX>()) {
      Get.put(SpinWheelControllerX());
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showSpinWheelDialog();
        },
        icon: const Icon(Icons.casino),
        label: const Text('Spin Wheel'),
        backgroundColor: T.teal,
      ),
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
            child: Column(
              children: [
                SizedBox(height: 20),
                HeaderBar(),
                SizedBox(height: 14.h),
                TotalBalanceDisplay(),
                SizedBox(height: 14.h),
                HeroBalanceCard(),
                SizedBox(height: 14.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: StreakCard(controller: ProfileController()),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(child: GraphCard()),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: MatrixCard()),
                    SizedBox(width: 12.w),
                    Expanded(child: AchievementCard()),
                  ],
                ),
                SizedBox(height: 12.h),
                BottomRow(referral: _ref),
              ],
            ),
          ),
          Positioned.fill(child: DailyRewardOverlay()),
        ],
      ),
    );
  }
}
