import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zic/customization/app_colors.dart';

class AvatarBadge extends StatelessWidget {
  final String name;
  const AvatarBadge({super.key, required this.name});

  String get _initials {
    final parts = name
        .split(' ')
        .where((p) => p.trim().isNotEmpty)
        .map((p) => p.trim().replaceAll('.', ''))
        .toList();
    if (parts.isEmpty) return 'NA';
    if (parts.length == 1) {
      return parts.first
          .substring(0, parts.first.length > 2 ? 2 : parts.first.length)
          .toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.w,
      width: 52.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFFC9B074), Color(0xFF726242)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.24),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(2.w),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF38414D), Color(0xFF1F2730)],
          ),
        ),
        child: ClipOval(
          child: Center(
            child: Text(
              _initials,
              style: TextStyle(
                color: kWhiteColor.withValues(alpha: 0.85),
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
