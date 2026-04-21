import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/customization/app_colors.dart';
// import 'package:zic/customization/widgets/rolling_balance.dart';
import 'package:zic/features/screens/home/controller/profile_controller.dart';
import 'package:zic/features/screens/home/screens/home/widgets/balanceIncrease_pill.dart';
import 'package:zic/features/screens/home/screens/home/widgets/rolling_balance.dart';

class HomeTestTopCard extends StatelessWidget {
  const HomeTestTopCard({super.key});

  Widget _buildMiningSpeedRow() {
    final controller = Get.find<ProfileController>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 4,
          child: InkWell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mining Speed:',
                  style: TextStyle(
                    color: kWhiteColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.bolt_rounded, color: ZicColors.cyan, size: 20.w),
                    SizedBox(width: 4.w),
                    Obx(
                      () => Text(
                        '',
                        style: TextStyle(
                          color: ZicColors.cyan,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Image.asset(
                      'assets/images/z.png',
                      width: 13.w,
                      height: 13.h,
                      color: ZicColors.cyan,
                    ),
                    Text(
                      ' /sec',
                      style: TextStyle(
                        color: ZicColors.cyan,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        Expanded(
          flex: 5,
          child: Obx(() {
            final progress = controller.ratePerSecond.value.clamp(0.0, 1.0);
            return ClipRRect(
              borderRadius: BorderRadius.circular(50.r),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6.h,
                backgroundColor: kWhiteColor.withOpacity(0.15),
                valueColor: AlwaysStoppedAnimation<Color>(ZicColors.cyan),
              ),
            );
          }),
        ),
        SizedBox(width: 10.w),
        Expanded(
          flex: 4,
          child: InkWell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Streak:',
                  style: TextStyle(
                    color: kWhiteColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      color: ZicColors.cyan,
                      size: 20.w,
                    ),
                    SizedBox(width: 4.w),
                    Obx(
                      () => Text(
                        'Day ${controller.streak.value}',
                        style: TextStyle(
                          color: ZicColors.cyan,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Container(
      height: 300.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: kWhiteColor.withOpacity(0.4),
            blurRadius: 4,
            spreadRadius: 2,
            blurStyle: BlurStyle.outer,
          ),
        ],
        border: Border.all(
          strokeAlign: 0,
          color: Color(0xff68eee6).withOpacity(0.8),
        ),
        gradient: LinearGradient(
          colors: [
            Color(0xff68eee6).withOpacity(0.6),
            Color(0xff584f85).withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'CURRENT ZIC Balance ',
                style: TextStyle(
                  color: kWhiteColor,
                  fontSize: 16.sp,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: 5.h),

              InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: RollingBalance(
                              controller: ProfileController(),
                              fontSize: 48,
                              color: const Color(0xff68eee6),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Image.asset(
                          'assets/images/z.png',
                          width: 25.w,
                          height: 25.h,
                          color: Color(0xff68eee6),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    BalanceIncreasePill(controller: controller),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildMiningSpeedRow()],
          ),

          // Rate row
        ],
      ),
    );
  }
}
