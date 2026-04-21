import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/features/screens/home/controller/daily_reward_controller.dart';
import 'package:zic/features/screens/home/controller/referral_controller.dart';
import 'package:zic/features/screens/home/screens/home/home.dart';
import 'package:zic/features/screens/home/screens/referrals/referral_bottomSheet.dart';
import 'package:zic/utils/models/dailyreward.dart';

class DailyRewardScreen extends StatelessWidget {
  const DailyRewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.isRegistered<DailyRewardController>()
        ? Get.find<DailyRewardController>()
        : Get.put(DailyRewardController());

    return Scaffold(
      backgroundColor: T.steelBorder,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF182430),
                    Color(0xFF0D1622),
                    Color(0xFF08111B),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 10.h),
                // ── Header ──
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Get.back(),
                        borderRadius: BorderRadius.circular(24.r),
                        child: Container(
                          height: 40.w,
                          width: 40.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.07),
                            border: Border.all(
                              color: ZicColors.cyan.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: ZicColors.cyan,
                            size: 18.w,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Daily Rewards',
                            style: TextStyle(
                              color: kWhiteColor,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 40.w),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                // ── Content ──
                Expanded(
                  child: Obx(() {
                    if (ctrl.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: ZicColors.cyan,
                          strokeWidth: 2,
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: ctrl.checkDailyReward,
                      color: ZicColors.cyan,
                      backgroundColor: const Color(0xFF1A2A36),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Info card ──
                            _InfoBanner(),
                            SizedBox(height: 20.h),

                            // ── Section title ──
                            Text(
                              'Your 7-Day Streak',
                              style: TextStyle(
                                color: kWhiteColor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Claim every day to keep your streak going',
                              style: TextStyle(
                                color: kWhiteColor.withValues(alpha: 0.55),
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 16.h),

                            // ── Rewards grid ──
                            if (ctrl.rewards.isEmpty)
                              _EmptyRewardsCard(ctrl: ctrl)
                            else
                              _RewardGrid(rewards: ctrl.rewards, ctrl: ctrl),

                            SizedBox(height: 24.h),

                            // ── Claim CTA if claimable ──
                            if (ctrl.claimableReward != null)
                              _ClaimButton(ctrl: ctrl),

                            SizedBox(height: 24.h),

                            // ── Referral promo card ──
                            _ReferralPromoCard(),

                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Info banner
// ─────────────────────────────────────────────────────────────

class _InfoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          colors: [
            ZicColors.cyan.withValues(alpha: 0.14),
            ZicColors.teal.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: ZicColors.cyan.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 44.w,
            width: 44.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [ZicColors.cyan, ZicColors.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(Icons.card_giftcard, color: Colors.black, size: 22.w),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Reward Available!',
                  style: TextStyle(
                    color: ZicColors.cyan,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Earn from 1 to 1000 Ziccoins every day you log in.',
                  style: TextStyle(
                    color: kWhiteColor.withValues(alpha: 0.68),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Reward Grid
// ─────────────────────────────────────────────────────────────

class _RewardGrid extends StatelessWidget {
  final List<DailyRewardItem> rewards;
  final DailyRewardController ctrl;

  const _RewardGrid({required this.rewards, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.72,
      ),
      itemCount: rewards.length,
      itemBuilder: (context, index) {
        final r = rewards[index];
        return _DayRewardTile(item: r, ctrl: ctrl);
      },
    );
  }
}

class _DayRewardTile extends StatelessWidget {
  final DailyRewardItem item;
  final DailyRewardController ctrl;

  const _DayRewardTile({required this.item, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final isToday = item.isClaimNow;
    final isClaimed = item.isClaimed;

    return Obx(() {
      final isClaiming = ctrl.isClaiming.value && isToday;

      return GestureDetector(
        onTap: isToday && !isClaiming ? () => ctrl.claimReward() : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            gradient: isClaimed
                ? LinearGradient(
                    colors: [
                      ZicColors.cyan.withValues(alpha: 0.22),
                      ZicColors.teal.withValues(alpha: 0.12),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : isToday
                ? const LinearGradient(
                    colors: [Color(0xFFFFD67A), Color(0xFFE8A020)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.06),
                      Colors.white.withValues(alpha: 0.03),
                    ],
                  ),
            border: Border.all(
              color: isClaimed
                  ? ZicColors.cyan.withValues(alpha: 0.6)
                  : isToday
                  ? const Color(0xFFFFD67A)
                  : Colors.white.withValues(alpha: 0.08),
              width: isToday ? 1.5 : 1,
            ),
            boxShadow: isToday
                ? [
                    BoxShadow(
                      color: const Color(0xFFFFD67A).withValues(alpha: 0.3),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]
                : isClaimed
                ? [
                    BoxShadow(
                      color: ZicColors.cyan.withValues(alpha: 0.15),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isClaiming
                    ? SizedBox(
                        key: const ValueKey('loading'),
                        width: 22.w,
                        height: 22.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : isClaimed
                    ? Icon(
                        Icons.check_circle,
                        key: const ValueKey('check'),
                        color: ZicColors.cyan,
                        size: 26.w,
                      )
                    : isToday
                    ? Text(
                        '🎁',
                        key: const ValueKey('gift'),
                        style: TextStyle(fontSize: 24.sp),
                      )
                    : Icon(
                        Icons.lock_outline,
                        key: const ValueKey('lock'),
                        color: Colors.white.withValues(alpha: 0.25),
                        size: 22.w,
                      ),
              ),
              SizedBox(height: 6.h),
              // Amount
              Text(
                '${item.amount}',
                style: TextStyle(
                  color: isClaimed
                      ? ZicColors.cyan
                      : isToday
                      ? Colors.black
                      : kWhiteColor.withValues(alpha: 0.4),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Day ${item.rewardNo}',
                style: TextStyle(
                  color: isClaimed
                      ? ZicColors.cyan.withValues(alpha: 0.7)
                      : isToday
                      ? Colors.black.withValues(alpha: 0.75)
                      : kWhiteColor.withValues(alpha: 0.28),
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isToday) ...[
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'CLAIM',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────

class _EmptyRewardsCard extends StatelessWidget {
  final DailyRewardController ctrl;

  const _EmptyRewardsCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Colors.white.withValues(alpha: 0.04),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Text('📅', style: TextStyle(fontSize: 40.sp)),
          SizedBox(height: 12.h),
          Text(
            'No rewards found',
            style: TextStyle(
              color: kWhiteColor.withValues(alpha: 0.7),
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Pull down to refresh',
            style: TextStyle(
              color: kWhiteColor.withValues(alpha: 0.4),
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: ctrl.checkDailyReward,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: ZicColors.cyan.withValues(alpha: 0.5),
                ),
              ),
              child: Text(
                'Retry',
                style: TextStyle(
                  color: ZicColors.cyan,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Claim button (shown when claimable reward exists)
// ─────────────────────────────────────────────────────────────

class _ClaimButton extends StatelessWidget {
  final DailyRewardController ctrl;

  const _ClaimButton({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final reward = ctrl.claimableReward;
      if (reward == null) return const SizedBox.shrink();

      final isClaiming = ctrl.isClaiming.value;

      return GestureDetector(
        onTap: isClaiming ? null : ctrl.claimReward,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            gradient: LinearGradient(
              colors: isClaiming
                  ? [Colors.grey.shade700, Colors.grey.shade900]
                  : [ZicColors.cyan, ZicColors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: ZicColors.cyan.withValues(
                  alpha: isClaiming ? 0.1 : 0.35,
                ),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isClaiming)
                SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.black,
                  ),
                )
              else ...[
                Icon(Icons.card_giftcard, color: Colors.black, size: 22.w),
                SizedBox(width: 10.w),
                Text(
                  'Claim ${reward.amount} Ziccoins — Day ${reward.rewardNo}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────
// Referral promo card
// ─────────────────────────────────────────────────────────────

class _ReferralPromoCard extends StatelessWidget {
  final refController = Get.find<ReferralController>();
  void _openInviteSheet(BuildContext context) {
    final code = refController.myReferralCode.value;
    showReferFriendBottomSheet(
      context,
      data: ReferFriendData(
        inviteCode: code.isNotEmpty ? code : 'Loading...',
        contacts: const [],
      ),
      onInviteAll: () => refController.invite(code),
      onSharePlatform: (_) => refController.invite(code),
      onInviteContact: (_) => refController.invite(code),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openInviteSheet(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          gradient: const LinearGradient(
            colors: [T.steelBorder, T.cyan],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: ZicColors.teal.withValues(alpha: 0.4),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: ZicColors.teal.withValues(alpha: 0.12),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 60.w,
              width: 60.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(Icons.group, color: ZicColors.teal, size: 30.w),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invite Friends & Earn Zic',
                    style: TextStyle(
                      color: kWhiteColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Claim extra ZIC by inviting your friends!',
                    style: TextStyle(
                      color: kWhiteColor.withValues(alpha: 0.68),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: ZicColors.teal.withValues(alpha: 0.7),
              size: 16.w,
            ),
          ],
        ),
      ),
    );
  }
}
