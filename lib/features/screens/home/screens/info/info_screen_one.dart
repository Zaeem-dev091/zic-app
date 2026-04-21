import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zic/customization/app_colors.dart';

class InfoScreenOne extends StatelessWidget {
  const InfoScreenOne({super.key});

  static const String _appBarTitle = 'IMPORTANT NOTE';
  static const String _nextTitle = 'WHAT IS COMING NEXT';
  static const String _nextSubtitle = 'Upcoming features include:';
  static const String _supportTitle = 'SUPPORT THE MISSION';
  static const String _supportBody =
      'Support is not always financial. It is showing up, participating, and inviting others. Together we are building a virtual ecosystem that puts people first. Thank you for walking this journey with us.';

  static const List<String> _features = [
    'Zic Pool Integration',
    'Utility-based features',
    'Enhanced session automation',
    'Mainnet Integration',
    'Referral leaderboard',
    'Improved security and performance',
  ];

  static const List<_InfoSection> _sections = [
    _InfoSection(
      title: 'WELCOME TO ZIC',
      body:
          'Your consistent daily activity matters. By tapping the mining button every day, you contribute to the growth of the Zic community and unlock your potential in the ecosystem.',
    ),
    _InfoSection(
      title: 'DAILY REWARDS',
      body:
          'Stay active to earn daily ZIC rewards. Regular participation boosts your streaks, increases bonuses, and keeps your session momentum alive.',
    ),
    _InfoSection(
      title: 'INVITE FRIENDS',
      body:
          'Invite your friends to join ZIC and earn extra Zic through referrals. A growing network means stronger community support and shared progress.',
    ),
    _InfoSection(
      title: 'SHOW YOUR LOYALTY',
      body:
          'Every day you check in and tap, you are showing commitment to a long-term vision. Early loyalty may open up future opportunities in the ecosystem.',
    ),
    _InfoSection(
      title: 'BUILDING TOGETHER',
      body:
          'ZIC is in an exciting phase of community-driven growth. While key features like migration, utility, and rewards are being shaped, your role today is essential.',
    ),
    _InfoSection(
      title: 'DEVELOPER PROGRESS',
      body:
          'Our developer is actively working on advanced features, including future transfers and app enhancements. As milestones are reached, users will be notified in-app.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 430.w),
          child: Container(
            decoration: _screenShellDecoration(),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.r),
                    child: Image.asset(
                      'assets/images/bg.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.r),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.18),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.22),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(12.w, 20.h, 12.w, 22.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 30.h),
                        _HeaderBar(
                          title: _appBarTitle,
                          onBackTap: () => Navigator.maybePop(context),
                        ),
                        SizedBox(height: 14.h),
                        const _IntroCard(),
                        SizedBox(height: 12.h),
                        ..._sections.map(
                          (section) => Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: _InfoSectionCard(section: section),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        _NextFeaturesCard(
                          title: _nextTitle,
                          subtitle: _nextSubtitle,
                          features: _features,
                        ),
                        SizedBox(height: 12.h),
                        _SupportCard(title: _supportTitle, body: _supportBody),
                        SizedBox(height: 14.h),
                        _BackButton(onTap: () => Navigator.maybePop(context)),
                        SizedBox(height: 4.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoSection {
  final String title;
  final String body;

  const _InfoSection({required this.title, required this.body});
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
          GestureDetector(
            onTap: onBackTap,
            child: Container(
              height: 44.w,
              width: 44.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                gradient: const LinearGradient(
                  colors: [Color(0xFF4D5966), Color(0xFF273340)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: ZicColors.cyan.withValues(alpha: 0.45),
                ),
                boxShadow: [
                  BoxShadow(
                    color: ZicColors.cyan.withValues(alpha: 0.24),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: ZicColors.cyan,
                size: 26.w,
              ),
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ZicColors.cyan,
                fontSize: 22.sp,
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

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: _steelDecoration(radius: 18.r, glow: 0.14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 44.w,
            width: 44.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              gradient: const LinearGradient(
                colors: [Color(0xFF223744), Color(0xFF0E1721)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border.all(color: ZicColors.cyan.withValues(alpha: 0.65)),
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: ZicColors.cyan,
              size: 22.w,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'Keep mining daily, build your streak, and stay connected with ecosystem updates.',
              style: TextStyle(
                color: kWhiteColor.withValues(alpha: 0.8),
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoSectionCard extends StatelessWidget {
  final _InfoSection section;

  const _InfoSectionCard({required this.section});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(11.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF2A3A46), Color(0xFF18232D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: ZicColors.cyan.withValues(alpha: 0.34)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: TextStyle(
              color: ZicColors.cyan,
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.35,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            section.body,
            style: TextStyle(
              color: kWhiteColor.withValues(alpha: 0.78),
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _NextFeaturesCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> features;

  const _NextFeaturesCard({
    required this.title,
    required this.subtitle,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: _steelDecoration(radius: 18.r, glow: 0.14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: ZicColors.cyan,
              fontSize: 13.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.4,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: TextStyle(
              color: kWhiteColor.withValues(alpha: 0.8),
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          ...features.map(
            (feature) => Padding(
              padding: EdgeInsets.only(bottom: 5.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 1.h),
                    child: Icon(
                      Icons.check_circle_outline_rounded,
                      color: ZicColors.cyan,
                      size: 14.w,
                    ),
                  ),
                  SizedBox(width: 7.w),
                  Expanded(
                    child: Text(
                      feature,
                      style: TextStyle(
                        color: kWhiteColor.withValues(alpha: 0.82),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  final String title;
  final String body;

  const _SupportCard({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF2A3A46), Color(0xFF18232D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: ZicColors.cyan.withValues(alpha: 0.34)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.favorite_border_rounded,
                color: ZicColors.cyan,
                size: 16.w,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: ZicColors.cyan,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.35,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Text(
            body,
            style: TextStyle(
              color: kWhiteColor.withValues(alpha: 0.8),
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: const LinearGradient(
            colors: [Color(0xFF223744), Color(0xFF0E1721)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border.all(
            color: ZicColors.cyan.withValues(alpha: 0.76),
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: ZicColors.cyan.withValues(alpha: 0.24),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_back_rounded, color: ZicColors.cyan, size: 18.w),
            SizedBox(width: 7.w),
            Text(
              'BACK',
              style: TextStyle(
                color: ZicColors.cyan,
                fontSize: 13.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

BoxDecoration _screenShellDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(30.r),
    gradient: const LinearGradient(
      colors: [Color(0xFF182430), Color(0xFF0D1622), Color(0xFF08111B)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    border: Border.all(color: const Color(0xFF203243), width: 1.2),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.42),
        blurRadius: 26,
        offset: const Offset(0, 18),
      ),
    ],
  );
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
