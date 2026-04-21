// features/screens/home/screens/streak/streak_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/features/screens/home/controller/streak_controller.dart';
import 'package:zic/features/screens/home/screens/home/widgets/steel_panel.dart';
import 'package:zic/features/screens/home/screens/streak/streak_claim_dialoge.dart';
import 'package:zic/features/screens/home/screens/widgets/coin_animation.dart';
import 'package:zic/utils/models/streak.dart';

class StreakRewardScreen extends StatelessWidget {
  const StreakRewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StreakController>();
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/images/bg.png', fit: BoxFit.cover),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Obx(() {
            final tiers = controller.tiers;
            final claimableTier = controller.nextClaimableTier;

            return RefreshIndicator(
              onRefresh: () => controller.refresh(),
              color: ZicColors.cyan,
              backgroundColor: const Color(0xFF1A2A36),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 30.h),

                      // ── Header ──
                      _HeaderBar(
                        title: 'STREAK REWARD',
                        onBackTap: () => Navigator.maybePop(context),
                      ),
                      SizedBox(height: 14.h),

                      // ── Summary panel ──
                      _SummaryPanel(
                        streakDays: controller.currentStreak,
                        totalRewardsEarned: controller.totalRewardsEarned,
                      ),
                      SizedBox(height: 12.h),

                      // ── Claim button — only visible when a tier is claimable ──
                      if (claimableTier != null)
                        _ClaimRewardButton(
                          days: claimableTier.days,
                          reward: claimableTier.reward,
                          onTap: () => _handleClaim(context, claimableTier),
                        ),

                      if (claimableTier != null) SizedBox(height: 10.h),

                      Center(
                        child: Icon(
                          Icons.toys_rounded,
                          size: 26.w,
                          color: ZicColors.cyan.withValues(alpha: 0.7),
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // ── Loading state ──
                      if (controller.isLoading.value && tiers.isEmpty)
                        _LoadingState()
                      // ── Tier grid ──
                      else if (tiers.isNotEmpty)
                        _RewardGrid(tiers: tiers)
                      else
                        _EmptyState(),

                      SizedBox(height: 18.h),

                      // ── Next reward footer ──
                      _NextRewardFooter(
                        nextRewardLabel: controller.nextRewardLabel,
                        progress: controller.progressToNext,
                      ),

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ✅ Show dialog first, THEN call API on confirm
  void _handleClaim(BuildContext context, StreakTierModel tier) {
    final controller = Get.find<StreakController>();

    showTestStreakClaimSuccessDialog(
      context,
      data: TestClaimSuccessDialogData(
        title: 'CLAIM REWARD',
        totalClaimedReward: '+ ${tier.reward} ZIC',
        totalClaimedLabel: 'Day ${tier.days} Streak Reward',
        dayBonusLabel: 'Streak Day:',
        dayBonusValue: '${tier.days} Days',
        streakBonusLabel: 'Reward:',
        streakBonusValue: '+ ${tier.reward} ZIC',
        description:
            'Claim your Day ${tier.days} streak reward of ${tier.reward} ZIC. '
            'Keep mining daily to unlock more rewards!',
        doneButtonText: 'CLAIM & CONTINUE',
      ),
      onDoneTap: () => controller.claimStreakReward(tier.days),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Reward Grid — uses real StreakTierModel
// ─────────────────────────────────────────────────────────────

class _RewardGrid extends StatelessWidget {
  final List<StreakTierModel> tiers;
  const _RewardGrid({required this.tiers});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tiers.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) => _RewardDayCard(tier: tiers[index]),
    );
  }
}

class _RewardDayCard extends StatelessWidget {
  final StreakTierModel tier;
  const _RewardDayCard({required this.tier});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF2A3B47), Color(0xFF1A2732), Color(0xFF273642)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: tier.isClaimNow
              ? const Color(0xFFE8D59B).withValues(alpha: 0.9)
              : tier.isClaimed
              ? ZicColors.cyan.withValues(alpha: 0.5)
              : ZicColors.cyan.withValues(alpha: 0.2),
          width: tier.isClaimNow ? 2.0 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: ZicColors.cyan.withValues(
              alpha: tier.isClaimNow ? 0.3 : 0.1,
            ),
            blurRadius: tier.isClaimNow ? 14 : 8,
            spreadRadius: tier.isClaimNow ? 0.6 : 0.2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Claimed / locked icon
          Positioned(
            right: 2.w,
            top: 2.h,
            child: Icon(
              tier.isClaimed
                  ? Icons.check_rounded
                  : tier.isClaimNow
                  ? Icons.card_giftcard
                  : Icons.lock_outline_rounded,
              color: tier.isClaimed
                  ? ZicColors.cyan.withValues(alpha: 0.88)
                  : tier.isClaimNow
                  ? Colors.amber.withValues(alpha: 0.9)
                  : kWhiteColor.withValues(alpha: 0.25),
              size: 14.w,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _MiniWingedBadge(),
              SizedBox(height: 6.h),
              Text(
                'Day ${tier.days}',
                style: TextStyle(
                  color: kWhiteColor.withValues(alpha: 0.82),
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                '${tier.reward} ZIC',
                style: TextStyle(
                  color: tier.isClaimNow ? Colors.amber : ZicColors.cyan,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Claim button — shows days and reward
// ─────────────────────────────────────────────────────────────

class _ClaimRewardButton extends GetView<StreakController> {
  final int days;
  final int reward;
  final VoidCallback onTap;

  const _ClaimRewardButton({
    required this.days,
    required this.reward,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isClaiming = controller.isClaimingDay(days);

      return SizedBox(
        height: 62.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                height: 2.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      ZicColors.cyan.withValues(alpha: 0.2),
                      ZicColors.cyan.withValues(alpha: 0.48),
                      ZicColors.cyan.withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: isClaiming ? null : onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  gradient: LinearGradient(
                    colors: isClaiming
                        ? [Colors.grey, Colors.grey.shade700]
                        : const [Color(0xFF223744), Color(0xFF0E1721)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  border: Border.all(
                    color: ZicColors.cyan.withValues(alpha: 0.72),
                    width: 1.4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ZicColors.cyan.withValues(alpha: 0.26),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 7.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: ZicColors.cyan.withValues(alpha: 0.8),
                    ),
                  ),
                  child: isClaiming
                      ? SizedBox(
                          height: 18.w,
                          width: 18.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'CLAIM DAY $days REWARD  (+$reward ZIC)',
                          style: TextStyle(
                            color: ZicColors.cyan,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.4,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────
//  Summary Panel — real data
// ─────────────────────────────────────────────────────────────

class _SummaryPanel extends StatelessWidget {
  final int streakDays;
  final int totalRewardsEarned;

  const _SummaryPanel({
    required this.streakDays,
    required this.totalRewardsEarned,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF52606D), Color(0xFF313D48), Color(0xFF4A5662)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: const Color(0xFFE8D59B).withValues(alpha: 0.8),
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: ZicColors.cyan.withValues(alpha: 0.14),
            blurRadius: 12,
            spreadRadius: 0.6,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: const LinearGradient(
            colors: [Color(0xFF1D3442), Color(0xFF122736)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: const Color(0xFFE8D59B).withValues(alpha: 0.62),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            const _WingedBadge(),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'STREAK DAYS: ',
                          style: TextStyle(
                            color: kWhiteColor.withValues(alpha: 0.82),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: '$streakDays',
                          style: TextStyle(
                            color: ZicColors.cyan,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'TOTAL REWARDS EARNED: ',
                          style: TextStyle(
                            color: kWhiteColor.withValues(alpha: 0.72),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: '$totalRewardsEarned ZIC',
                          style: TextStyle(
                            color: ZicColors.cyan,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Next Reward Footer — real progress
// ─────────────────────────────────────────────────────────────

class _NextRewardFooter extends StatelessWidget {
  final String nextRewardLabel;
  final double progress;

  const _NextRewardFooter({
    required this.nextRewardLabel,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return SteelPanel(
      accent: kLightGrey,
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'NEXT REWARD: ',
                  style: TextStyle(
                    color: kWhiteColor.withValues(alpha: 0.8),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: nextRewardLabel,
                  style: TextStyle(
                    color: ZicColors.cyan,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            height: 12.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: const Color(0xFF1A2A37),
              border: Border.all(
                color: kWhiteColor.withValues(alpha: 0.35),
                width: 1.0,
              ),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5EECFF), Color(0xFF9CFFFF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ZicColors.cyan.withValues(alpha: 0.45),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            '${(progress * 100).toStringAsFixed(0)}% to $nextRewardLabel',
            style: TextStyle(
              color: kWhiteColor.withValues(alpha: 0.55),
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Loading & Empty states
// ─────────────────────────────────────────────────────────────

class _LoadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 30.w,
            width: 30.w,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: ZicColors.cyan,
              backgroundColor: ZicColors.cyan.withValues(alpha: 0.15),
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            'Loading streak data...',
            style: TextStyle(
              color: kWhiteColor.withValues(alpha: 0.8),
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
      child: Column(
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            color: ZicColors.cyan,
            size: 44.w,
          ),
          SizedBox(height: 14.h),
          Text(
            'No streak data available',
            style: TextStyle(
              color: kWhiteColor.withValues(alpha: 0.9),
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Start mining daily to build your streak!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kWhiteColor.withValues(alpha: 0.6),
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Keep original decorative widgets unchanged
// ─────────────────────────────────────────────────────────────

class _HeaderBar extends StatelessWidget {
  final String title;
  final VoidCallback onBackTap;
  const _HeaderBar({required this.title, required this.onBackTap});

  @override
  Widget build(BuildContext context) {
    return SteelPanel(
      accent: kLightGrey,
      child: Row(
        children: [
          GestureDetector(
            onTap: onBackTap,
            child: Container(
              height: 44.w,
              width: 44.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                gradient: const LinearGradient(
                  colors: [Color(0xFF4D5966), Color(0xFF273340)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: ZicColors.cyan.withValues(alpha: 0.45),
                ),
                boxShadow: [
                  BoxShadow(
                    color: ZicColors.cyan.withValues(alpha: 0.24),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: ZicColors.cyan,
                size: 26.w,
              ),
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ZicColors.cyan,
                fontSize: 24.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
                shadows: [
                  Shadow(
                    color: ZicColors.cyan.withValues(alpha: 0.35),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 44.w),
        ],
      ),
    );
  }
}

class _WingedBadge extends StatelessWidget {
  const _WingedBadge();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.keyboard_double_arrow_left_rounded,
          color: const Color(0xFFE8D59B).withValues(alpha: 0.9),
          size: 20.w,
        ),
        Container(
          height: 50.w,
          width: 50.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFAE8D4B), Color(0xFFE8D59B), Color(0xFF816A31)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.all(2.2.w),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF1D2E40), Color(0xFF102233)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: ZicColors.cyan.withValues(alpha: 0.5),
                width: 1.1,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: AutoFlipImage(),
            ),
          ),
        ),
        Icon(
          Icons.keyboard_double_arrow_right_rounded,
          color: const Color(0xFFE8D59B).withValues(alpha: 0.9),
          size: 20.w,
        ),
      ],
    );
  }
}

class _MiniWingedBadge extends StatelessWidget {
  const _MiniWingedBadge();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.arrow_left_rounded,
          size: 13.w,
          color: const Color(0xFFE8D59B).withValues(alpha: 0.82),
        ),
        Container(
          height: 34.w,
          width: 34.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFAE8D4B), Color(0xFFE8D59B), Color(0xFF816A31)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.all(1.5.w),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF1D2E40), Color(0xFF102233)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: ZicColors.cyan.withValues(alpha: 0.45),
                width: 0.9,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(5.w),
              child: AutoFlipImage(),
            ),
          ),
        ),
        Icon(
          Icons.arrow_right_rounded,
          size: 13.w,
          color: const Color(0xFFE8D59B).withValues(alpha: 0.82),
        ),
      ],
    );
  }
}
