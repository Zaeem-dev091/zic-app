import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/features/screens/home/screens/widgets/coin_animation.dart';

@immutable
class TestClaimSuccessDialogData {
  final String title;
  final String totalClaimedReward;
  final String totalClaimedLabel;
  final String dayBonusLabel;
  final String dayBonusValue;
  final String streakBonusLabel;
  final String streakBonusValue;
  final String description;
  final String doneButtonText;

  const TestClaimSuccessDialogData({
    this.title = 'CLAIM SUCCESSFUL',
    this.totalClaimedReward = '+ 2,500 Z',
    this.totalClaimedLabel = 'Total Claimed Reward',
    this.dayBonusLabel = 'Day 14 Bonus:',
    this.dayBonusValue = '+ 2,000 Z',
    this.streakBonusLabel = 'Streak Bonus:',
    this.streakBonusValue = '+ 500 Z',
    this.description =
        'You have successfully claimed your complete Day 14 and streak bonuses. '
        'This amount has been added to your balance. Your continued loyalty is appreciated.',
    this.doneButtonText = 'DONE & CONTINUE',
  });
}

void showTestStreakClaimSuccessDialog(
  BuildContext context, {
  TestClaimSuccessDialogData data = const TestClaimSuccessDialogData(),
  VoidCallback? onDoneTap,
}) {
  showDialog<void>(
    context: context,
    useRootNavigator: true,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.66),
    builder: (dialogContext) =>
        _ClaimSuccessDialog(data: data, onDoneTap: onDoneTap),
  );
}

class _ClaimSuccessDialog extends StatelessWidget {
  final TestClaimSuccessDialogData data;
  final VoidCallback? onDoneTap;

  const _ClaimSuccessDialog({required this.data, this.onDoneTap});

  void _handleDone(BuildContext context) {
    Navigator.of(context).pop();
    onDoneTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 350.w),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF4C5964),
                    Color(0xFF2B3641),
                    Color(0xFF3D4852),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                border: Border.all(
                  color: const Color(0xFF95A0AA).withValues(alpha: 0.82),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 25,
                    offset: const Offset(0, 18),
                  ),
                  BoxShadow(
                    color: ZicColors.cyan.withValues(alpha: 0.18),
                    blurRadius: 20,
                    spreadRadius: 0.8,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _DialogHeader(title: data.title),
                  Padding(
                    padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 16.h),
                    child: Column(
                      children: [
                        const _DialogWingedBadge(),
                        SizedBox(height: 12.h),
                        Text(
                          data.totalClaimedReward,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ZicColors.cyan,
                            fontSize: 56.sp,
                            fontWeight: FontWeight.w900,
                            height: 1,
                            shadows: [
                              Shadow(
                                color: ZicColors.cyan.withValues(alpha: 0.45),
                                blurRadius: 14,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          data.totalClaimedLabel,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: kWhiteColor.withValues(alpha: 0.88),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 14.h),
                        Container(
                          height: 1.h,
                          color: kWhiteColor.withValues(alpha: 0.15),
                        ),
                        SizedBox(height: 14.h),
                        Row(
                          children: [
                            Expanded(
                              child: _BonusCard(
                                title: data.dayBonusLabel,
                                value: data.dayBonusValue,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: _BonusCard(
                                title: data.streakBonusLabel,
                                value: data.streakBonusValue,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          data.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: kWhiteColor.withValues(alpha: 0.87),
                            fontSize: 15.sp,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        _DialogDoneButton(
                          text: data.doneButtonText,
                          onTap: () => _handleDone(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogHeader extends StatelessWidget {
  final String title;

  const _DialogHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 13.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        gradient: const LinearGradient(
          colors: [Color(0xFF818A94), Color(0xFF626C76), Color(0xFF7C868F)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(
          bottom: BorderSide(color: ZicColors.cyan.withValues(alpha: 0.32)),
        ),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: ZicColors.cyan,
          fontSize: 24.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.7,
          shadows: [
            Shadow(
              color: ZicColors.cyan.withValues(alpha: 0.35),
              blurRadius: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class _BonusCard extends StatelessWidget {
  final String title;
  final String value;

  const _BonusCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF273744), Color(0xFF162533)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: const Color(0xFFE8D59B).withValues(alpha: 0.8),
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kWhiteColor.withValues(alpha: 0.9),
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ZicColors.cyan,
              fontSize: 13.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _DialogDoneButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _DialogDoneButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 66.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 8.w,
            right: 8.w,
            child: Container(
              height: 2.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    ZicColors.cyan.withValues(alpha: 0.32),
                    ZicColors.cyan.withValues(alpha: 0.6),
                    ZicColors.cyan.withValues(alpha: 0.32),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                gradient: const LinearGradient(
                  colors: [Color(0xFF223744), Color(0xFF0E1721)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                border: Border.all(
                  color: ZicColors.cyan.withValues(alpha: 0.84),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: ZicColors.cyan.withValues(alpha: 0.3),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: ZicColors.cyan.withValues(alpha: 0.82),
                  ),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: ZicColors.cyan,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DialogWingedBadge extends StatelessWidget {
  const _DialogWingedBadge();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.keyboard_double_arrow_left_rounded,
          color: const Color(0xFFE8D59B).withValues(alpha: 0.9),
          size: 28.w,
        ),
        Container(
          height: 82.w,
          width: 82.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFAE8D4B), Color(0xFFE8D59B), Color(0xFF816A31)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.all(3.w),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF1D2E40), Color(0xFF102233)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: ZicColors.cyan.withValues(alpha: 0.5),
                width: 1.1,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: AutoFlipImage(),
            ),
          ),
        ),
        Icon(
          Icons.keyboard_double_arrow_right_rounded,
          color: const Color(0xFFE8D59B).withValues(alpha: 0.9),
          size: 28.w,
        ),
      ],
    );
  }
}
