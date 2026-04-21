import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zic/customization/app_colors.dart';

class FaqsScreen extends StatefulWidget {
  const FaqsScreen({super.key});

  @override
  State<FaqsScreen> createState() => _FaqsScreenState();
}

class _FaqsScreenState extends State<FaqsScreen> {
  int? _expandedFaqIndex;

  static const List<_FaqItem> _faqs = [
    _FaqItem(
      question: 'How do I mine ZIC daily?',
      answer:
          'Open the app every day and tap the mining button. Daily activity helps maintain your streak and increases your progress in the ecosystem.',
    ),
    _FaqItem(
      question: 'Why is my streak important?',
      answer:
          'Your streak tracks consistency. Higher consistency can unlock better reward opportunities and improve your long-term progress.',
    ),
    _FaqItem(
      question: 'How do referral rewards work?',
      answer:
          'Invite friends with your referral code. When they join and meet reward conditions, referral milestones become claimable from the referral section.',
    ),
    _FaqItem(
      question: 'Where can I see transaction history?',
      answer:
          'Go to Wallet or Transaction History from the home and settings flow to view transfer records and activity details.',
    ),
    _FaqItem(
      question: 'What should I do if something is not working?',
      answer:
          'Check your internet connection first, then reopen the app. If the issue continues, use support or feedback with details and screenshots.',
    ),
  ];

  void _toggleFaq(int index) {
    setState(() {
      _expandedFaqIndex = _expandedFaqIndex == index ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/images/bg.png', fit: BoxFit.cover),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20.h),
                  _HeaderBar(
                    title: 'FAQS',
                    onBackTap: () => Navigator.maybePop(context),
                  ),
                  SizedBox(height: 14.h),
                  const _IntroCard(),
                  SizedBox(height: 12.h),
                  ..._faqs.asMap().entries.map((entry) {
                    final faqIndex = entry.key;
                    final faq = entry.value;
                    final isExpanded = _expandedFaqIndex == faqIndex;

                    return Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: _FaqCard(
                        item: faq,
                        isExpanded: isExpanded,
                        onTap: () => _toggleFaq(faqIndex),
                      ),
                    );
                  }),
                  SizedBox(height: 2.h),
                  const _FooterHint(),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FaqItem {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});
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

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: _steelDecoration(radius: 18.r, glow: 0.15),
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
            child: Icon(Icons.quiz_outlined, color: ZicColors.cyan, size: 22.w),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'Find quick answers about mining, rewards, transfers, and account usage.',
              style: TextStyle(
                color: kWhiteColor.withValues(alpha: 0.78),
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqCard extends StatelessWidget {
  final _FaqItem item;
  final bool isExpanded;
  final VoidCallback onTap;

  const _FaqCard({
    required this.item,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeInOut,
      constraints: BoxConstraints(minHeight: 60.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF2A3A46), Color(0xFF18232D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: isExpanded
              ? ZicColors.cyan.withValues(alpha: 0.76)
              : ZicColors.cyan.withValues(alpha: 0.32),
          width: isExpanded ? 1.4 : 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: isExpanded
                ? ZicColors.cyan.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    item.question,
                    maxLines: isExpanded ? 3 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: kWhiteColor.withValues(alpha: 0.9),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: ZicColors.cyan,
                    size: 25.w,
                  ),
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 180),
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                item.answer,
                style: TextStyle(
                  color: kWhiteColor.withValues(alpha: 0.74),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                ),
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          ),
        ],
      ),
    );
  }
}

class _FooterHint extends StatelessWidget {
  const _FooterHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF101C27), Color(0xFF0A1119)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(color: ZicColors.cyan.withValues(alpha: 0.16)),
      ),
      child: Text(
        'Still need help? Open Support from settings and send us your issue.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: kWhiteColor.withValues(alpha: 0.74),
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          height: 1.35,
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
