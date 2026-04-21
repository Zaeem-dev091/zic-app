import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/utils/models/referrals.dart';

class StatusBadge extends StatelessWidget {
  final TierModel tier;
  const StatusBadge({required this.tier, super.key});

  @override
  Widget build(BuildContext context) {
    final String text;
    final Color color;

    if (tier.isClaimed) {
      text = 'CLAIMED';
      color = Colors.green;
    } else if (tier.isEligible) {
      text = 'CLAIM NOW';
      color = ZicColors.cyan;
    } else {
      // ✅ Shows "3/5" from model's progressStr
      text = tier.progressStr;
      color = kWhiteColor.withValues(alpha: 0.5);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 9.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
