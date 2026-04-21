import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/features/screens/auth/authController/auth_controller.dart';
import 'package:zic/features/screens/home/controller/referral_controller.dart';
import 'package:zic/features/screens/home/screens/faq/faqs_screen.dart';
import 'package:zic/features/screens/home/screens/feedback/feedback_screen.dart';
import 'package:zic/features/screens/home/screens/home/widgets/hero_balance_card.dart';
import 'package:zic/features/screens/home/screens/info/info_screen_one.dart';
import 'package:zic/features/screens/home/screens/levels/levels_screen.dart';
import 'package:zic/features/screens/home/news/news_detail_screen.dart';
import 'package:zic/features/screens/home/screens/referrals/referral_bottomSheet.dart';
import 'package:zic/features/screens/home/screens/referrals/referral_list_screen.dart';
import 'package:zic/features/screens/home/screens/support/support_screen.dart';
import 'package:zic/features/screens/home/screens/wallet/wallet_screen.dart';

class SettingsSection {
  final String title;
  final List<SettingsItem> items;

  const SettingsSection({required this.title, required this.items});
}

class SettingsItem {
  final String title;
  final String iconAsset;
  final String subtitle;
  final VoidCallback onTap;

  const SettingsItem({
    required this.title,
    required this.iconAsset,
    required this.onTap,
    this.subtitle = '',
  });
}

class SettingsScreen extends GetView<AuthController> {
  final String title;

  const SettingsScreen({super.key, this.title = 'SETTINGS'});

  List<SettingsSection> _sections(BuildContext context) {
    final refController = Get.find<ReferralController>();

    void _openInviteSheet(BuildContext context) {
      final code = refController.myReferralCode.value;
      showReferFriendBottomSheet(
        context,
        data: ReferFriendData(
          inviteCode: code.isNotEmpty ? code : 'Loading...',
          contacts: const [],
        ),
        onInviteAll: () => refController.invite(code),
        onSharePlatform: (_) => refController.invite(code),
        onInviteContact: (_) => refController.invite(code),
      );
    }

    return [
      SettingsSection(
        title: 'ZIC ECOSYSTEM',
        items: [
          SettingsItem(
            title: 'Invite Friends and Get extra Zic',
            subtitle: 'Unlock additional referral rewards',
            iconAsset: 'assets/icons/peoples.png',
            onTap: () => _openInviteSheet(context),
          ),
          SettingsItem(
            title: 'Zic Minnet!',
            subtitle: 'Read ecosystem news and updates',
            iconAsset: 'assets/icons/rocket.png',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NewsDetailScreen()),
            ),
          ),
          SettingsItem(
            title: 'Mine Zic',
            subtitle: 'Open mining information',
            iconAsset: 'assets/icons/earth.png',
            onTap: () => showDialog(
              context: context,
              builder: (context) {
                final height = MediaQuery.of(context).size.height;

                return Dialog(
                  child: SizedBox(
                    height: height * 0.5,
                    child: HeroBalanceCard(),
                  ),
                );
              },
            ),
          ),
          SettingsItem(
            title: 'Referral Team',
            subtitle: 'View your referral list',
            iconAsset: 'assets/icons/peoples.png',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReferralListScreen()),
            ),
          ),
          SettingsItem(
            title: 'Roles',
            subtitle: 'Check role and level details',
            iconAsset: 'assets/images/z.png',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LevelsScreen()),
            ),
          ),
        ],
      ),
      SettingsSection(
        title: 'HELP CENTER',
        items: [
          SettingsItem(
            title: 'Important Note',
            subtitle: 'Read key project information',
            iconAsset: 'assets/icons/question.png',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InfoScreenOne()),
            ),
          ),
          SettingsItem(
            title: 'Support',
            subtitle: 'Get help from the support team',
            iconAsset: 'assets/icons/peoples.png',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SupportScreen()),
            ),
          ),
          SettingsItem(
            title: 'FAQs',
            subtitle: 'Find quick answers',
            iconAsset: 'assets/icons/question.png',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FaqsScreen()),
            ),
          ),
          SettingsItem(
            title: 'Feedback',
            subtitle: 'Share your suggestions',
            iconAsset: 'assets/icons/feedback.png',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FeedBackScreen()),
            ),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final sections = _sections(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  _HeaderBar(
                    title: title,
                    onBackTap: () => Navigator.maybePop(context),
                  ),
                  SizedBox(height: 14.h),
                  ...sections.map(
                    (section) => Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: _SectionCard(section: section),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  _LogoutButton(onTap: controller.logout),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderBar extends StatelessWidget {
  final String title;
  final VoidCallback onBackTap;

  const _HeaderBar({required this.title, required this.onBackTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: _steelDecoration(radius: 22.r, glow: 0.18),
      child: Row(
        children: [
          SizedBox(height: 44.h, width: 44.w),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ZicColors.cyan,
                fontSize: 24.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
                shadows: [
                  Shadow(
                    color: ZicColors.cyan.withValues(alpha: 0.35),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 44.w),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final SettingsSection section;

  const _SectionCard({required this.section});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 8.h),
      decoration: _steelDecoration(radius: 18.r, glow: 0.2),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.tune_rounded,
                color: ZicColors.cyan.withValues(alpha: 0.9),
                size: 16.w,
              ),
              SizedBox(width: 6.w),
              Text(
                section.title,
                style: TextStyle(
                  color: ZicColors.cyan.withValues(alpha: 0.95),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ...section.items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: _SettingsTile(item: item),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final SettingsItem item;

  const _SettingsTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: item.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          gradient: const LinearGradient(
            colors: [Color(0xFF2A3A46), Color(0xFF17222D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: ZicColors.cyan.withValues(alpha: 0.28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.26),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 38.w,
              width: 38.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFAE8D4B), Color(0xFF816A31)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Image.asset(
                  item.iconAsset,
                  width: 20.w,
                  height: 20.w,
                  color: kWhiteColor.withValues(alpha: 0.9),
                  errorBuilder: (_, _, _) => Icon(
                    Icons.settings_rounded,
                    color: kWhiteColor.withValues(alpha: 0.9),
                    size: 18.w,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      color: kWhiteColor.withValues(alpha: 0.92),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (item.subtitle.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        color: kWhiteColor.withValues(alpha: 0.62),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: ZicColors.cyan.withValues(alpha: 0.86),
              size: 22.w,
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 56.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: const LinearGradient(
            colors: [Color(0xFF742F42), Color(0xFF521F2E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: const Color(0xFFFF839E).withValues(alpha: 0.6),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFC94F5D).withValues(alpha: 0.4),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'LOGOUT',
            style: TextStyle(
              color: kWhiteColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.7,
            ),
          ),
        ),
      ),
    );
  }
}

BoxDecoration _steelDecoration({required double radius, double glow = 0.2}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    gradient: const LinearGradient(
      colors: [Color(0xFF44515E), Color(0xFF2A3541), Color(0xFF3D4853)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    border: Border.all(color: const Color(0xFF85909C).withValues(alpha: 0.75)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.3),
        blurRadius: 10,
        offset: const Offset(0, 6),
      ),
      BoxShadow(
        color: ZicColors.cyan.withValues(alpha: glow),
        blurRadius: 12,
        spreadRadius: 0.6,
      ),
    ],
  );
}
