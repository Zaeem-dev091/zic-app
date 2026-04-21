import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/features/screens/home/controller/home_controller.dart';
import 'package:zic/features/screens/home/controller/referral_controller.dart';
import 'package:zic/features/screens/home/screens/home/home.dart';
import 'package:zic/features/screens/home/screens/home/widgets/steel_panel.dart';
import 'package:zic/features/screens/home/screens/referrals/referral_list_screen.dart';

class FeedCard extends StatelessWidget {
  const FeedCard({super.key});

  static const _items = [
    FeedItem(text: '– Final Listing soon 2026 –', isCyan: true),
    FeedItem(text: '+ You Get-2 Zic every 6 hours', isCyan: false),
    FeedItem(text: '+ Increase speed by inviting', isCyan: false),
  ];

  @override
  Widget build(BuildContext context) {
    return SteelPanel(
      accent: T.cyan,
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TopHandle(color: T.cyan),
          SizedBox(height: 10.h),
          Text(
            'Feed Core',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          ..._items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 5.h),
              child: Text(
                item.text,
                style: TextStyle(
                  color: item.isCyan ? T.cyan : T.green,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          // News image with caption overlay
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/miningpic.jpg',
                  width: double.infinity,
                  height: 80.h,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.84),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'The Future of Digital Finance',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Cryptocurrency is rapidly reshaping...',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.65),
                            fontSize: 8.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FeedItem {
  final String text;
  final bool isCyan;
  const FeedItem({required this.text, required this.isCyan});
}

class SocialRail extends StatelessWidget {
  const SocialRail({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final items = [
      SocialEntry(
        icon: Icons.telegram,
        color: const Color(0xFF29B6F6),
        label: 'Link\nTelegram',
        onTap: () => homeController.openTelegram(),
      ),
      SocialEntry(
        icon: Icons.close_rounded,
        color: Colors.white,
        label: 'Follow on X',
        onTap: () => homeController.openX(),
      ),
    ];

    return SteelPanel(
      accent: T.purple,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 14.h),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            SocialBtn(item: items[i]),
            if (i < items.length - 1) ...[
              SizedBox(height: 3.h),
              ConnectorDot(),
              _ConnectorLine(),
              ConnectorDot(),
              SizedBox(height: 3.h),
            ],
          ],
        ],
      ),
    );
  }
}

class SocialEntry {
  final IconData icon;
  final Color color;
  final String label;
  final Future<void> Function() onTap;
  const SocialEntry({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });
}

class SocialBtn extends StatelessWidget {
  final SocialEntry item;
  const SocialBtn({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => item.onTap(),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              color: item.color.withValues(alpha: 0.1),
              border: Border.all(color: item.color.withValues(alpha: 0.45)),
              boxShadow: [
                BoxShadow(
                  color: item.color.withValues(alpha: 0.2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Icon(item.icon, color: item.color, size: 22.w),
          ),
          SizedBox(height: 4.h),
          Text(
            item.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.72),
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class ConnectorDot extends StatelessWidget {
  const ConnectorDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7.w,
      height: 7.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: T.cyan.withValues(alpha: 0.5),
        border: Border.all(color: T.cyan.withValues(alpha: 0.8)),
      ),
    );
  }
}

class _ConnectorLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.5.w,
      height: 16.h,
      color: T.cyan.withValues(alpha: 0.35),
    );
  }
}

class DroneCard extends StatelessWidget {
  final ReferralController referral;
  const DroneCard({super.key, required this.referral});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/drone.png',
          width: 100.w,
          height: 70.w,
          fit: BoxFit.contain,
        ),
        SteelPanel(
          accent: T.teal,
          onTap: () => Get.to(
            () => const ReferralListScreen(),
            transition: Transition.fadeIn,
          ),
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 14.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TopHandle(color: T.teal),
              SizedBox(height: 10.h),

              Stack(
                alignment: Alignment.center,
                children: [
                  // Outer glow
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          T.cyan.withValues(alpha: 0.22),
                          T.cyan.withValues(alpha: 0.05),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/3d.png',
                    width: 68.w,
                    height: 68.w,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
