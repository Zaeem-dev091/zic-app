import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zic/customization/app_colors.dart';

class SettingRow extends StatelessWidget {
  final String text;
  final String icon;
  const SettingRow({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(icon, width: 30.w, height: 30.h, color: kWhiteColor),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20.sp,
                color: kWhiteColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
