import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zic/features/screens/home/screens/home/home.dart';

class DarkPanel extends StatelessWidget {
  final Widget child;
  final Color accent;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;

  const DarkPanel({
    super.key,
    required this.child,
    required this.accent,
    this.borderColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: const LinearGradient(
          colors: T.panelGrad,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(
          color: const Color(0xFFE8D59B).withValues(alpha: 0.62),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.22),
            blurRadius: 18,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class SteelPanel extends StatelessWidget {
  final Widget child;
  final Color accent;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final double radius;

  const SteelPanel({
    super.key,
    required this.child,
    required this.accent,
    this.padding,
    this.onTap,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    final inner = Container(
      padding: padding ?? EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF424B56), Color(0xFF7D8791), Color(0xFF424B56)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.black.withOpacity(0.3),
          width: 5,
          style: BorderStyle.solid,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: accent.withValues(alpha: 0.2),
            blurRadius: 14,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return inner;
    return GestureDetector(onTap: onTap, child: inner);
  }
}
