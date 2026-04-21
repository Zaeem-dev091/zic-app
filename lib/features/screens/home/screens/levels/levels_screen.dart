import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/features/screens/home/controller/level_controller.dart';
import 'package:zic/features/screens/home/screens/home/home.dart';
import 'package:zic/utils/models/levels.dart';

class LevelsScreen extends GetView<LevelController> {
  const LevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/images/bg.png', fit: BoxFit.cover),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: RefreshIndicator(
            onRefresh: () => controller.refreshLevels(),
            color: ZicColors.cyan,
            backgroundColor: const Color(0xFF1A2A36),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20),
                child: Obx(() {
                  final levels = controller.levels;
                  final totalZic = controller.myZic;
                  final myLio = controller.myZic;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 30.h),
                      _HeaderBar(
                        title: 'LEVELS',
                        onBackTap: () => Navigator.maybePop(context),
                      ),
                      SizedBox(height: 14.h),
                      _SummaryCard(
                        totalBalance: totalZic,
                        currentLevelName: controller.currentLevelName.value,
                        currentLevelTitle: controller.currentLevelTitle.value,
                        nextLevelName: controller.nextLevelName.value,
                        nextLevelMin: controller.nextLevelMin.value,
                        nextLevelMax: controller.nextLevelMax.value,
                        progress: controller.progress.value,
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14.r),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF122130), Color(0xFF0C1721)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: ZicColors.cyan.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Text(
                          'Collect ZIC, climb ranks, become a boss!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.86),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 14.h),
                      if (controller.isLoading.value && levels.isEmpty)
                        const _LoadingState()
                      else if (levels.isEmpty)
                        const _EmptyState()
                      else
                        ...levels.map((level) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: _LevelCard(level: level, myLio: myLio),
                          );
                        }),
                      SizedBox(height: 6.h),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Keep _HeaderBar exactly as is
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

// Keep _SummaryCard exactly as is
class _SummaryCard extends StatelessWidget {
  final double totalBalance;
  final String currentLevelName;
  final String currentLevelTitle;
  final String nextLevelName;
  final int nextLevelMin;
  final int nextLevelMax;
  final double progress;

  const _SummaryCard({
    required this.totalBalance,
    required this.currentLevelName,
    required this.currentLevelTitle,
    required this.nextLevelName,
    required this.nextLevelMin,
    required this.nextLevelMax,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: _steelDecoration(radius: 20.r, glow: 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'YOUR ZIC',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.78),
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            '$totalBalance',
            style: TextStyle(
              color: T.gold,
              fontSize: 34.sp,
              fontWeight: FontWeight.w900,
              height: 1,
              shadows: [
                Shadow(
                  color: ZicColors.cyan.withValues(alpha: 0.32),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'CURRENT: $currentLevelName',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (currentLevelTitle.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Text(
              currentLevelTitle,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          SizedBox(height: 10.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(50.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7.h,
              backgroundColor: Colors.white.withValues(alpha: 0.16),
              valueColor: const AlwaysStoppedAnimation<Color>(ZicColors.cyan),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'NEXT: $nextLevelName (${nextLevelMin == nextLevelMax ? '$nextLevelMin+' : '$nextLevelMin - $nextLevelMax'} ZIC)',
            style: TextStyle(
              color: ZicColors.cyan.withValues(alpha: 0.92),
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// Updated _LevelCard using LevelModel
class _LevelCard extends StatelessWidget {
  final LevelModel level;
  final double myLio;

  const _LevelCard({required this.level, required this.myLio});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LevelController>();
    final isUnlocked = level.levelNo <= controller.currentLevelNo;

    String statusText;
    Color statusColor;

    if (level.isCurrent) {
      statusText = 'CURRENT';
      statusColor = ZicColors.cyan;
    } else if (level.isClaimed) {
      statusText = 'CLAIMED';
      statusColor = Colors.green;
    } else if (isUnlocked) {
      statusText = 'UNLOCKED';
      statusColor = const Color(0xFF60F7A7);
    } else {
      statusText = 'LOCKED';
      statusColor = Colors.white.withValues(alpha: 0.5);
    }

    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF2A3A46), Color(0xFF18232D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: level.isCurrent
              ? ZicColors.cyan.withValues(alpha: 0.85)
              : const Color(0xFF8A949F).withValues(alpha: 0.62),
          width: level.isCurrent ? 1.5 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: level.isCurrent
                ? ZicColors.cyan.withValues(alpha: 0.25)
                : Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      level.displayTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.72),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (level.rewardAmount > 0) ...[
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Icon(
                            Icons.card_giftcard,
                            size: 12.w,
                            color: Colors.amber.withValues(alpha: 0.9),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${level.rewardAmount.toStringAsFixed(0)} ZIC',
                            style: TextStyle(
                              color: Colors.amber.withValues(alpha: 0.9),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: statusColor.withValues(alpha: 0.12),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.45),
                  ),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            level.name,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.92),
              fontSize: 17.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            level.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.66),
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
          // Progress bar for current level
          if (level.isCurrent) ...[
            SizedBox(height: 10.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(50.r),
              child: LinearProgressIndicator(
                value: level.getProgress(myLio),
                minHeight: 4.h,
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(ZicColors.cyan),
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$myLio / ${level.maxLio ?? '∞'} ZIC',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${(level.getProgress(myLio) * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: ZicColors.cyan.withValues(alpha: 0.7),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
          // Claim button
          if (level.canClaim && !level.isClaimed) ...[
            SizedBox(height: 10.h),
            Obx(() {
              final isClaiming = controller.isClaimingLevel(level.levelNo);

              return Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: isClaiming
                      ? null
                      : () => controller.claimLevelReward(level.levelNo),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      gradient: LinearGradient(
                        colors: isClaiming
                            ? [Colors.grey, Colors.grey.shade700]
                            : const [Color(0xFF00BCD4), Color(0xFF0097A7)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ZicColors.cyan.withValues(
                            alpha: isClaiming ? 0.1 : 0.3,
                          ),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isClaiming)
                          SizedBox(
                            width: 16.w,
                            height: 16.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        else ...[
                          const Icon(
                            Icons.card_giftcard,
                            size: 16,
                            color: Colors.white,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'CLAIM REWARD',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
          // Show claimed status
          if (level.isClaimed && level.rewardAmount > 0) ...[
            SizedBox(height: 10.h),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: Colors.green.withValues(alpha: 0.15),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.green,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'REWARD CLAIMED',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Keep _LoadingState exactly as is
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220.h,
      alignment: Alignment.center,
      decoration: _steelDecoration(radius: 20.r, glow: 0.12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 30.w,
            width: 30.w,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: ZicColors.cyan,
              backgroundColor: ZicColors.cyan.withValues(alpha: 0.15),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Loading levels...',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}

// Keep _EmptyState exactly as is
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
      decoration: _steelDecoration(radius: 20.r, glow: 0.12),
      child: Column(
        children: [
          Icon(Icons.emoji_events_rounded, size: 44.w, color: ZicColors.cyan),
          SizedBox(height: 10.h),
          Text(
            'No levels available',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.86),
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// Keep _steelDecoration exactly as is
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
