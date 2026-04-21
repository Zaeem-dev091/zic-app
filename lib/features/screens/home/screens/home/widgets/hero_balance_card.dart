import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:zic/features/screens/home/controller/profile_controller.dart';
import 'package:zic/features/screens/home/screens/home/home.dart';
// import 'package:zic/features/screens/home/screens/home/widgets/float_lable.dart';
import 'package:zic/features/screens/home/screens/home/widgets/material_lable.dart';
import 'package:zic/features/screens/home/screens/home/widgets/rolling_balance.dart';
import 'package:zic/features/screens/home/screens/home/widgets/steel_panel.dart';
import 'package:zic/features/screens/home/screens/home/widgets/top_handle.dart';
import 'package:zic/features/screens/home/screens/widgets/coin_animation.dart';

class HeroBalanceCard extends StatelessWidget {
  const HeroBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    return DarkPanel(
      accent: T.cyan,
      borderColor: T.cyan.withValues(alpha: 0.6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MINING',
            style: TextStyle(
              color: T.cyan.withValues(alpha: 0.75),
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.0,
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            height: 220.h,
            child: Stack(
              children: [
                // ───────────── Rolling Balance ─────────────
                Positioned(
                  left: 0,
                  top: 0,
                  child: RollingBalance(
                    controller: controller,
                    fontSize: 24.sp,
                    color: T.cyan,
                  ),
                ),

                // ───────────── Miner Core ─────────────
                Positioned(
                  right: 0,
                  top: 6.h,
                  bottom: 28.h,
                  width: 185.w,
                  child: GestureDetector(
                    onTap: controller.tapStartMining,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Positioned(
                          bottom: 12.h,
                          child: GlowOrb(
                            color: const Color(0x553AF7FF),
                            size: 128,
                          ),
                        ),
                        Positioned(
                          bottom: 26.h,
                          child: Container(
                            width: 88.w,
                            height: 68.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60.r),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0x6039EAFD),
                                  Color(0x1539EAFD),
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 32.h,
                          child: SizedBox(
                            width: 150.w,
                            height: 150.w,
                            child: const AutoFlipImage(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ───────────── Mining Speed ─────────────
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Obx(
                    () => MetricLabel(
                      title: 'Mining Speed:',
                      value:
                          '${controller.ratePerSecond.value.toStringAsFixed(6)} z/sec',
                    ),
                  ),
                ),

                // ───────────── Mining Progress Bar ─────────────
                Positioned(
                  bottom: 5,
                  left: 0,
                  right: 0,
                  child: Obx(() {
                    // Calculate remaining percentage
                    final progress = controller.isMining.value
                        ? 1.0 -
                              (controller.secondsLeft.value /
                                  controller.totalMiningDuration.value)
                        : 0.0;

                    return MiningProgressBar(
                      progress: progress.clamp(0.0, 1.0),
                      isActive: controller.isMining.value,
                    );
                  }),
                ),

                // ───────────── Daily Streak ─────────────
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Obx(
                    () => MetricLabel(
                      title: 'Daily Streak:',
                      value: 'Day ${controller.streak.value}',
                      alignEnd: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),

          // ───────────── Status Pill ─────────────
          // ───────────── Mining Button with Timer ─────────────
          Obx(() {
            final isMining = controller.isMining.value;
            final secondsLeft = controller.secondsLeft.value;

            String label;
            VoidCallback? onTap;

            if (isMining) {
              if (secondsLeft > 0) {
                // ✅ FIX: Format time as HH:MM:SS or MM:SS depending on duration
                final hours = secondsLeft ~/ 3600;
                final minutes = (secondsLeft % 3600) ~/ 60;
                final seconds = secondsLeft % 60;

                String timeString;
                if (hours > 0) {
                  // Show hours if > 0
                  timeString =
                      '${hours.toString().padLeft(2, '0')}:'
                      '${minutes.toString().padLeft(2, '0')}:'
                      '${seconds.toString().padLeft(2, '0')}';
                } else {
                  // Show minutes:seconds if < 1 hour
                  timeString =
                      '${minutes.toString().padLeft(2, '0')}:'
                      '${seconds.toString().padLeft(2, '0')}';
                }

                label = '$timeString remaining';
                onTap = null; // Disable button while mining
              } else {
                label = 'Mining Complete • Tap to Claim';
                onTap = () {
                  // Add claim logic here
                  controller.refreshProfileAfterMining();
                };
              }
            } else {
              label = 'Tap to Start Mining';
              onTap = controller.tapStartMining;
            }

            return MiningButton(
              label: label,
              color: T.cyan,
              fullWidth: true,
              ontap: onTap,
            );
          }),
        ],
      ),
    );
  }
}
