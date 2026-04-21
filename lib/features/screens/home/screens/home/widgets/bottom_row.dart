import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/features/screens/home/controller/referral_controller.dart';
import 'package:zic/features/screens/home/news/news_detail_screen.dart';
import 'package:zic/features/screens/home/screens/home/widgets/feed_card.dart';
import 'package:zic/features/screens/home/screens/info/info_screen_one.dart';

class BottomRow extends StatelessWidget {
  final ReferralController referral;
  const BottomRow({super.key, required this.referral});

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 370;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: compact ? 7 : 6,
          child: GestureDetector(
            onTap: () => Get.to(NewsDetailScreen()),
            child: const FeedCard(),
          ),
        ),
        SizedBox(width: 10.w),
        SizedBox(width: compact ? 68.w : 78.w, child: const SocialRail()),
        SizedBox(width: 10.w),
        Expanded(
          flex: compact ? 4 : 5,
          child: DroneCard(referral: referral),
        ),
      ],
    );
  }
}
