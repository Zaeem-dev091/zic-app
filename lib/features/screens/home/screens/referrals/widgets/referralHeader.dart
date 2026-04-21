import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/features/screens/home/screens/home/widgets/steel_panel.dart';

class HeaderBar extends StatelessWidget {
  final String title;
  final VoidCallback onBackTap;
  const HeaderBar({required this.title, required this.onBackTap, super.key});

  @override
  Widget build(BuildContext context) {
    return SteelPanel(
      accent: kLightGrey,
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
