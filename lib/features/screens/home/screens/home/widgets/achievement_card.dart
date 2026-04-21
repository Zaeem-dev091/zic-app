import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/features/screens/home/screens/home/dailyReward/daily_reward_screen.dart';
import 'package:zic/features/screens/home/screens/home/home.dart';
import 'package:zic/features/screens/home/screens/home/widgets/steel_panel.dart';
import 'package:zic/features/screens/home/screens/home/widgets/top_handle.dart';

class AchievementCard extends StatelessWidget {
  static const _unlocked = [
    _AchievementBadge(
      label: 'Claimed',
      icon: Icons.workspace_premium_rounded,
      color: T.cyan,
    ),
    _AchievementBadge(
      label: 'Started Session',
      icon: Icons.bolt_rounded,
      color: T.gold,
    ),
  ];

  const AchievementCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(DailyRewardScreen()),

      child: SteelPanel(
        accent: T.purple,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Achievements Forge',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 12.h),
            // 3 locked slots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (i) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: _LockedSlot(highlighted: i == 1),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            // Unlocked badges
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _unlocked
                  .map((b) => Flexible(child: _BadgeWidget(badge: b)))
                  .toList(),
            ),
            SizedBox(height: 12.h),
            MiningButton(
              label: '(2/4 Complete)',
              color: T.cyan,
              fullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementBadge {
  final String label;
  final IconData icon;
  final Color color;
  const _AchievementBadge({
    required this.label,
    required this.icon,
    required this.color,
  });
}

class _LockedSlot extends StatelessWidget {
  final bool highlighted;
  const _LockedSlot({this.highlighted = false});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          gradient: const LinearGradient(
            colors: [Color(0xFF2A3541), Color(0xFF1A2530)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: highlighted
                ? T.cyan.withValues(alpha: 0.55)
                : T.steelBorder.withValues(alpha: 0.35),
          ),
          boxShadow: highlighted
              ? [BoxShadow(color: T.cyan.withValues(alpha: 0.2), blurRadius: 8)]
              : null,
        ),
        child: Center(child: Icon(Icons.check, color: kWhiteColor)),
      ),
    );
  }
}

class _BadgeWidget extends StatelessWidget {
  final _AchievementBadge badge;
  const _BadgeWidget({required this.badge});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60.w,
          height: 60.w,
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [T.goldBorder, T.gold, T.goldBorder],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: badge.color.withValues(alpha: 0.38),
                blurRadius: 14,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF1A3248), Color(0xFF0D1E2E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: badge.color.withValues(alpha: 0.5)),
            ),
            child: Icon(badge.icon, color: badge.color, size: 26.w),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          badge.label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.75),
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
