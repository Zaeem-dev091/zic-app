import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/features/screens/home/controller/referral_controller.dart';
import 'package:zic/features/screens/home/screens/referrals/referral_bottomSheet.dart';

class ReferButtonRow extends GetView<ReferralController> {
  final VoidCallback? onTap;
  const ReferButtonRow({this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64.h,
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
                    ZicColors.cyan.withValues(alpha: 0.28),
                    ZicColors.cyan.withValues(alpha: 0.5),
                    ZicColors.cyan.withValues(alpha: 0.28),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _openInviteSheet(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 11.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.r),
                gradient: const LinearGradient(
                  colors: [Color(0xFF223744), Color(0xFF0E1721)],
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
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: ZicColors.cyan.withValues(alpha: 0.8),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ZicColors.cyan.withValues(alpha: 0.2),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Text(
                  'REFER NEW FRIENDS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ZicColors.cyan,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 10.w,
            child: Container(
              height: 30.w,
              width: 30.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF15202B),
                border: Border.all(
                  color: ZicColors.cyan.withValues(alpha: 0.45),
                ),
              ),
              child: Icon(
                Icons.bubble_chart_rounded,
                size: 18.w,
                color: ZicColors.cyan.withValues(alpha: 0.75),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openInviteSheet(BuildContext context) {
    final code = controller.myReferralCode.value;
    showReferFriendBottomSheet(
      context,
      data: ReferFriendData(
        inviteCode: code.isNotEmpty ? code : 'Loading...',
        contacts: const [],
      ),
      onInviteAll: () => controller.invite(code),
      onSharePlatform: (_) => controller.invite(code),
      onInviteContact: (_) => controller.invite(code),
    );
  }
}
