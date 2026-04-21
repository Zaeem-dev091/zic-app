import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/features/screens/home/controller/profile_controller.dart';
import 'package:zic/features/screens/home/screens/home/home.dart';
import 'package:zic/features/screens/home/screens/home/widgets/steel_panel.dart';
import 'package:zic/features/screens/home/screens/home/widgets/top_handle.dart';
import 'package:zic/features/screens/home/screens/streak/streak_reward_screen.dart';

class StreakCard extends StatelessWidget {
  final ProfileController controller;
  const StreakCard({super.key, required this.controller});

  static const _bars = [0.28, 0.46, 0.55, 0.67, 0.75, 0.84, 0.93];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final streak = math.max(1, math.min(7, controller.streak.value));
      return SteelPanel(
        accent: T.purple,
        onTap: () => Get.to(
          () => const StreakRewardScreen(),
          transition: Transition.fadeIn,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Daily Streak',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 14.h),
            SizedBox(
              height: 90.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(7, (i) {
                  final isActive = i < streak;
                  final isCurrent = i == streak - 1;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              // Max bar height leaves room for 'day' label (~14.h)
                              height: (16.h + (52.h * _bars[i])).clamp(
                                0.0,
                                74.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.r),
                                gradient: LinearGradient(
                                  colors: isActive
                                      ? [
                                          const Color(0xFF7BFFF3),
                                          const Color(0xFF4DD6FF),
                                        ]
                                      : [
                                          const Color(0xFF233447),
                                          const Color(0xFF18232E),
                                        ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                                border: Border.all(
                                  color: isActive
                                      ? (isCurrent
                                            ? const Color(0xFFFFF1B7)
                                            : T.cyan.withValues(alpha: 0.5))
                                      : Colors.white.withValues(alpha: 0.1),
                                ),
                                boxShadow: isActive
                                    ? [
                                        BoxShadow(
                                          color: T.cyan.withValues(alpha: 0.35),
                                          blurRadius: 8,
                                        ),
                                      ]
                                    : null,
                              ),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'day',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.55),
                              fontSize: 7.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 12.h),
            MiningButton(
              label: 'Daily Streak Reactor: Day $streak (Active)',
              color: T.cyan,
              fullWidth: true,
            ),
          ],
        ),
      );
    });
  }
}
