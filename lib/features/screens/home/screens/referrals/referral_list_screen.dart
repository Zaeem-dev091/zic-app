import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/features/screens/home/controller/referral_controller.dart';
import 'package:zic/features/screens/home/screens/referrals/referral_bottomSheet.dart';
import 'package:zic/features/screens/home/screens/referrals/widgets/emptyState.dart';
import 'package:zic/features/screens/home/screens/referrals/widgets/loadingState.dart';
import 'package:zic/features/screens/home/screens/referrals/widgets/referButton.dart';
import 'package:zic/features/screens/home/screens/referrals/widgets/referralCard.dart';
import 'package:zic/features/screens/home/screens/referrals/widgets/referralHeader.dart';
import 'package:zic/features/screens/home/screens/referrals/widgets/sectionLable.dart';

class ReferralListScreen extends GetView<ReferralController> {
  const ReferralListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/images/bg.png', fit: BoxFit.cover),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Obx(() {
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 30.h),
                      HeaderBar(
                        title: 'REFERRAL LIST',
                        onBackTap: () => Navigator.maybePop(context),
                      ),
                      SizedBox(height: 16.h),
                      ReferButtonRow(),
                      SizedBox(height: 16.h),
                      SectionLabel(label: 'MY REFERRAL TEAM'),
                      SizedBox(height: 12.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${controller.totalReferrals}',
                                style: TextStyle(
                                  color: ZicColors.cyan,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              TextSpan(
                                text: ' Referrals',
                                style: TextStyle(
                                  color: kWhiteColor.withValues(alpha: 0.82),
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      if (controller.isFetching.value &&
                          controller.referralUsers.isEmpty)
                        const LoadingState()
                      else if (controller.referralUsers.isEmpty)
                        const EmptyState(
                          title: 'No referrals yet',
                          subtitle:
                              'Share your code and start earning rewards when friends join!',
                        )
                      else
                        ...controller.referralUsers.map(
                          (user) => Padding(
                            padding: EdgeInsets.only(bottom: 14.h),
                            child: ReferralCard(user: user),
                          ),
                        ),
                      SizedBox(height: 8.h),
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
}
