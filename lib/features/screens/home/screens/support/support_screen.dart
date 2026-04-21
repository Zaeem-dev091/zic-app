import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/customization/widgets/feedback_style_snackbar.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController _messageController = TextEditingController();

  final List<String> _topics = const [
    'Account Issue',
    'Mining/Streak',
    'Wallet/Transfer',
    'Referral Problem',
    'Other',
  ];

  String _selectedTopic = 'Account Issue';
  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _showStatusSnack(String text, {required bool success}) {
    showFeedbackStyleSnackbar(message: text, success: success);
  }

  Future<void> _submitSupportRequest() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      _showStatusSnack('Please describe your issue.', success: false);
      return;
    }

    if (message.length < 10) {
      _showStatusSnack(
        'Please provide at least 10 characters.',
        success: false,
      );
      return;
    }

    setState(() => _isSending = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    setState(() {
      _isSending = false;
      _selectedTopic = _topics.first;
    });
    _messageController.clear();

    _showStatusSnack(
      'Request sent. Support will review your message soon.',
      success: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/bg.png', fit: BoxFit.cover),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20.h),
                    _HeaderBar(
                      title: 'SUPPORT',
                      onBackTap: () => Navigator.maybePop(context),
                    ),
                    SizedBox(height: 14.h),
                    const _IntroCard(),
                    SizedBox(height: 12.h),
                    _ContactTile(
                      icon: Icons.email_outlined,
                      title: 'support@zicapp.com',
                      subtitle: 'Email support',
                    ),
                    SizedBox(height: 10.h),
                    _ContactTile(
                      icon: Icons.access_time_rounded,
                      title: '24 - 48 hours',
                      subtitle: 'Average response time',
                    ),
                    SizedBox(height: 14.h),
                    _SectionTitle(title: 'Issue Topic'),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.r),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF223744), Color(0xFF0E1721)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        border: Border.all(
                          color: ZicColors.cyan.withValues(alpha: 0.45),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedTopic,
                          isExpanded: true,
                          dropdownColor: const Color(0xFF162635),
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: ZicColors.cyan,
                          ),
                          borderRadius: BorderRadius.circular(14.r),
                          style: TextStyle(
                            color: kWhiteColor.withValues(alpha: 0.9),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          items: _topics
                              .map(
                                (topic) => DropdownMenuItem<String>(
                                  value: topic,
                                  child: Text(topic),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() => _selectedTopic = value);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    _SectionTitle(title: 'Message'),
                    SizedBox(height: 8.h),
                    _MessageInput(controller: _messageController),
                    SizedBox(height: 16.h),
                    _SubmitButton(
                      isLoading: _isSending,
                      onTap: _submitSupportRequest,
                    ),
                    SizedBox(height: 12.h),
                    const _FooterHint(),
                    SizedBox(height: 4.h),
                  ],
                ),
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
            child: Icon(
              Icons.support_agent_rounded,
              color: ZicColors.cyan,
              size: 22.w,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'Share your issue below and our team will respond as soon as possible.',
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

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        color: kWhiteColor.withValues(alpha: 0.82),
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.45,
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ContactTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF2A3A46), Color(0xFF17222D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: ZicColors.cyan.withValues(alpha: 0.32)),
      ),
      child: Row(
        children: [
          Container(
            height: 34.w,
            width: 34.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              gradient: const LinearGradient(
                colors: [Color(0xFF223744), Color(0xFF0E1721)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border.all(color: ZicColors.cyan.withValues(alpha: 0.45)),
            ),
            child: Icon(icon, color: ZicColors.cyan, size: 18.w),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: kWhiteColor.withValues(alpha: 0.9),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: kWhiteColor.withValues(alpha: 0.62),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
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

class _MessageInput extends StatelessWidget {
  final TextEditingController controller;

  const _MessageInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF223744), Color(0xFF0E1721)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(color: ZicColors.cyan.withValues(alpha: 0.45)),
      ),
      child: TextField(
        controller: controller,
        maxLines: 5,
        minLines: 4,
        style: TextStyle(
          color: kBlackColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Write details about your issue...',
          hintStyle: TextStyle(
            color: kBlackColor.withValues(alpha: 0.45),
            fontSize: 14.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(12.w),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _SubmitButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isLoading ? null : onTap,
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
        child: isLoading
            ? Center(
                child: SizedBox(
                  width: 18.w,
                  height: 18.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: ZicColors.cyan,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send_rounded, color: ZicColors.cyan, size: 18.w),
                  SizedBox(width: 7.w),
                  Text(
                    'SEND REQUEST',
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
        'Include details like timing, screenshots, and what you already tried.',
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
