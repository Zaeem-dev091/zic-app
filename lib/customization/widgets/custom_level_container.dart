import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zic/customization/app_colors.dart';

class LevelContainer extends StatelessWidget {
  final String headerText;
  final String title;
  final String description;
  final Border? outlineBorder;
  const LevelContainer({
    super.key,
    required this.headerText,
    required this.title,
    required this.description,
    this.outlineBorder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: 110.h),
        decoration: BoxDecoration(
          border:
              outlineBorder ?? Border.all(color: kTransparentColor, width: 2),
          borderRadius: BorderRadius.circular(30.r),
          color: kTextfieldColor,
          boxShadow: [
            BoxShadow(
              color: kBlackColor.withOpacity(0.1),
              blurRadius: 3,
              spreadRadius: 2,
              blurStyle: BlurStyle.normal,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textAlign: TextAlign.start,
                headerText,
                style: TextStyle(
                  color: kBlackColor,
                  fontWeight: FontWeight.w300,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                textAlign: TextAlign.start,
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: kBlackColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                textAlign: TextAlign.start,
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: kTextfieldTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
