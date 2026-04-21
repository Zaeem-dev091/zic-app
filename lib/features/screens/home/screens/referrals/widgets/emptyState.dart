import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/features/screens/home/screens/referrals/widgets/referral_theme.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  const EmptyState({required this.title, required this.subtitle, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
      decoration: steelDecoration(radius: 22.r, glow: 0.16),
      child: Column(
        children: [
          Container(
            height: 54.w,
            width: 54.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ZicColors.cyan.withValues(alpha: 0.08),
              border: Border.all(color: ZicColors.cyan.withValues(alpha: 0.35)),
            ),
            child: Icon(
              Icons.groups_rounded,
              color: ZicColors.cyan,
              size: 28.w,
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kWhiteColor.withValues(alpha: 0.9),
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kWhiteColor.withValues(alpha: 0.65),
              fontSize: 13.sp,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
