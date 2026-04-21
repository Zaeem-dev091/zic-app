import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/features/screens/home/controller/referral_controller.dart';
import 'package:zic/features/screens/home/screens/referrals/referral_bottomSheet.dart';
import 'package:zic/features/screens/home/screens/referrals/widgets/referButton.dart';
import 'package:zic/features/screens/home/screens/referrals/widgets/referralHeader.dart';
import 'package:zic/features/screens/home/screens/referrals/widgets/sectionLable.dart';
import 'package:zic/features/screens/home/screens/referrals/widgets/summaryCard.dart';
import 'package:zic/features/screens/home/screens/referrals/widgets/tierCard.dart';

class ReferralInviteScreen extends GetView<ReferralController> {
  const ReferralInviteScreen({super.key});

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
                        title: 'REFERRAL INVITE',
                        onBackTap: () => Navigator.maybePop(context),
                      ),
                      SizedBox(height: 18.h),
                      SummaryCard(
                        totalReferrals: controller.totalReferrals,
                        tiers: controller.tiers,
                      ),
                      SizedBox(height: 10.h),
                      ReferButtonRow(),
                      SizedBox(height: 18.h),
                      if (controller.tiers.isNotEmpty) ...[
                        SectionLabel(label: 'Referral MILESTONE REWARDS'),
                        SizedBox(height: 10.h),
                        ...controller.tiers.map(
                          (tier) => Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: TierCard(tier: tier),
                          ),
                        ),
                        SizedBox(height: 10.h),
                      ],
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
