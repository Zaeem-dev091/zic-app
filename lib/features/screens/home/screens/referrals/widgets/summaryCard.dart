import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/features/screens/home/screens/referrals/widgets/matrixRow.dart';
import 'package:zic/features/screens/home/screens/referrals/widgets/referral_theme.dart';
import 'package:zic/features/screens/home/screens/widgets/coin_animation.dart';
import 'package:zic/utils/models/referrals.dart';

class SummaryCard extends StatelessWidget {
  final int totalReferrals;
  final List<TierModel> tiers;

  const SummaryCard({
    required this.totalReferrals,
    required this.tiers,
    super.key,
  });

  int get _totalRewardsEarned {
    return tiers.where((t) => t.isClaimed).fold(0, (sum, t) => sum + t.reward);
  }

  int get _pendingCount {
    return tiers.where((t) => !t.isClaimed).length;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: steelDecoration(radius: 22.r, glow: 0.2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 86.w,
            width: 86.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFAE8D4B),
                  Color(0xFFE8D59B),
                  Color(0xFF816A31),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsets.all(3.w),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF23384C), Color(0xFF0D2133)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: ZicColors.cyan.withValues(alpha: 0.4),
                  width: 1.2,
                ),
              ),
              child: ClipOval(
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: AutoFlipImage(),
                ),
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Zic Digital',
                  style: TextStyle(
                    color: kWhiteColor.withValues(alpha: 0.9),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    shadows: const [
                      Shadow(color: Colors.black45, blurRadius: 3),
                    ],
                  ),
                ),
                SizedBox(height: 6.h),
                MetricRow(label: 'TOTAL REFERRALS', value: '$totalReferrals'),
                SizedBox(height: 4.h),
                MetricRow(label: 'MILESTONES PENDING', value: '$_pendingCount'),
                SizedBox(height: 4.h),
                MetricRow(
                  label: 'REWARDS EARNED',
                  value: '$_totalRewardsEarned ZIC',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
