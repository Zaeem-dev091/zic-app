import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zic/features/screens/home/screens/home/home.dart';

class TopHandle extends StatelessWidget {
  final Color color;
  const TopHandle({super.key, this.color = T.cyan});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36.w,
        height: 4.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.2),
              color.withValues(alpha: 0.7),
              color.withValues(alpha: 0.2),
            ],
          ),
        ),
      ),
    );
  }
}

class MiningButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool fullWidth;
  final VoidCallback? ontap;

  const MiningButton({
    super.key,
    required this.label,
    required this.color,
    this.fullWidth = false,
    this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: fullWidth ? double.infinity : null,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: color.withValues(alpha: 0.07),
          border: Border.all(color: color.withValues(alpha: 0.45)),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: color,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}

class GlowOrb extends StatelessWidget {
  final Color color;
  final double size;
  const GlowOrb({super.key, required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0.04), Colors.transparent],
        ),
      ),
    );
  }
}

class Pedestal extends StatelessWidget {
  final Color color;
  const Pedestal({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128.w,
      height: 18.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.r),
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.06),
            color.withValues(alpha: 0.38),
            color.withValues(alpha: 0.06),
          ],
        ),
        border: Border.all(color: color.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.45),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}

class NodeCounter extends StatelessWidget {
  final String value;
  final Color color;
  const NodeCounter({super.key, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: color.withValues(alpha: 0.08),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: 18.sp,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class MiningProgressBar extends StatelessWidget {
  /// 0.0 → 1.0 — driven by miningRate / maxRate
  final double progress;
  final bool isActive;

  const MiningProgressBar({
    super.key,
    required this.progress,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    // Center it — leave space for the metric labels on left and right
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 80.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Track
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Background track
              Container(
                height: 7.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  color: Colors.white.withValues(alpha: 0.08),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
              ),
              // Filled portion
              AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutCubic,
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  height: 7.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    gradient: LinearGradient(
                      colors: isActive
                          ? [
                              T.cyan.withValues(alpha: 0.6),
                              T.cyan,
                              Colors.white.withValues(alpha: 0.9),
                            ]
                          : [T.purple.withValues(alpha: 0.4), T.purple],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isActive ? T.cyan : T.purple).withValues(
                          alpha: 0.55,
                        ),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),

              // Glowing head dot
            ],
          ),
          SizedBox(height: 4.h),
          // Percentage label
          Text(
            isActive
                ? '${(progress * 100).toStringAsFixed(0)}% Complete'
                : 'Inactive',
            style: TextStyle(
              color: (isActive ? T.cyan : T.purple).withValues(alpha: 0.75),
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
