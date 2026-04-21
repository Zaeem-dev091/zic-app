import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/features/screens/home/screens/referrals/widgets/referral_theme.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240.h,
      alignment: Alignment.center,
      decoration: steelDecoration(radius: 22.r, glow: 0.15),
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
            'Loading referrals...',
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
