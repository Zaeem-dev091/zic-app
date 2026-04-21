import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/features/screens/home/screens/home/widgets/steel_panel.dart';
import 'package:zic/features/screens/home/screens/referrals/widgets/avatarBadge.dart';
import 'package:zic/utils/models/referrals.dart';

class ReferralCard extends StatelessWidget {
  final ReferralUserModel user;
  const ReferralCard({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return SteelPanel(
      accent: kLightGrey,
      child: Row(
        children: [
          AvatarBadge(name: user.name),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: kWhiteColor.withValues(alpha: 0.9),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  user.status.toUpperCase(),
                  style: TextStyle(
                    color: user.isVerified
                        ? const Color(0xFF60F7A7)
                        : kWhiteColor.withValues(alpha: 0.5),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            '${user.reward} ZIC',
            style: TextStyle(
              color: ZicColors.cyan.withValues(alpha: 0.92),
              fontSize: 15.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
