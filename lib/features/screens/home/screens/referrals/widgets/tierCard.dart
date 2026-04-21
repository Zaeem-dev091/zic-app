import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/features/screens/home/controller/referral_controller.dart';
import 'package:zic/features/screens/home/screens/referrals/widgets/statusBadge.dart';
import 'package:zic/utils/models/referrals.dart';

class TierCard extends GetView<ReferralController> {
  // ✅ TierModel instead of Map<String, dynamic>
  final TierModel tier;
  const TierCard({required this.tier, super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isClaiming = controller.isClaiming(tier.tier);

      return Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          gradient: const LinearGradient(
            colors: [Color(0xFF2A3A46), Color(0xFF18232D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: tier.isEligible
                ? ZicColors.cyan.withValues(alpha: 0.85)
                : tier.isClaimed
                ? Colors.green.withValues(alpha: 0.5)
                : const Color(0xFF8A949F).withValues(alpha: 0.45),
            width: tier.isEligible ? 1.5 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: tier.isEligible
                  ? ZicColors.cyan.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              spreadRadius: 0.5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Milestone icon
                Container(
                  height: 40.w,
                  width: 40.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: tier.isClaimed
                          ? [Colors.green.shade700, Colors.green.shade900]
                          : tier.isEligible
                          ? [const Color(0xFF00BCD4), const Color(0xFF0097A7)]
                          : [const Color(0xFF3A4A56), const Color(0xFF222E38)],
                    ),
                    border: Border.all(
                      color: tier.isClaimed
                          ? Colors.green.withValues(alpha: 0.5)
                          : ZicColors.cyan.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Icon(
                    tier.isClaimed ? Icons.check_circle : Icons.groups_rounded,
                    color: Colors.white,
                    size: 20.w,
                  ),
                ),
                SizedBox(width: 12.w),

                // Milestone info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Invite ${tier.tier} Friends',
                        style: TextStyle(
                          color: kWhiteColor.withValues(alpha: 0.92),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Icon(
                            Icons.card_giftcard,
                            size: 12.w,
                            color: Colors.amber.withValues(alpha: 0.9),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${tier.reward} ZIC reward',
                            style: TextStyle(
                              color: Colors.amber.withValues(alpha: 0.9),
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Status badge
                StatusBadge(tier: tier),
              ],
            ),

            // ✅ Progress bar using model's progressFraction + progressStr
            if (!tier.isClaimed) ...[
              SizedBox(height: 10.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(50.r),
                child: LinearProgressIndicator(
                  value: tier.progressFraction,
                  minHeight: 5.h,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    tier.isEligible
                        ? ZicColors.cyan
                        : ZicColors.cyan.withValues(alpha: 0.5),
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // ✅ Uses progressStr from model e.g. "3/5"
                    '${tier.progressStr} referrals',
                    style: TextStyle(
                      color: kWhiteColor.withValues(alpha: 0.5),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${(tier.progressFraction * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: ZicColors.cyan.withValues(alpha: 0.7),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],

            // Claim button
            if (tier.isEligible && !tier.isClaimed) ...[
              SizedBox(height: 10.h),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: isClaiming
                      ? null
                      : () => controller.claimMilestoneReward(
                          milestone: tier.tier,
                          coins: tier.reward,
                        ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      gradient: LinearGradient(
                        colors: isClaiming
                            ? [Colors.grey, Colors.grey.shade700]
                            : const [Color(0xFF00BCD4), Color(0xFF0097A7)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ZicColors.cyan.withValues(
                            alpha: isClaiming ? 0.1 : 0.3,
                          ),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isClaiming)
                          SizedBox(
                            width: 16.w,
                            height: 16.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        else ...[
                          const Icon(
                            Icons.card_giftcard,
                            size: 16,
                            color: Colors.white,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'CLAIM REWARD',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],

            // Claimed state
            if (tier.isClaimed) ...[
              SizedBox(height: 10.h),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: Colors.green.withValues(alpha: 0.15),
                    border: Border.all(
                      color: Colors.green.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Colors.green,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'REWARD CLAIMED',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}
