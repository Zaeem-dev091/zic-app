import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zic/customization/app_colors.dart';

class CustomContainer extends StatelessWidget {
  final Widget widget;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final VoidCallback? ontap;
  const CustomContainer({
    super.key,
    this.height,
    this.width,
    this.margin,
    this.color,
    required this.widget,
    this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          margin ?? const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(30.r),
        onTap: ontap ?? () {},
        child: Container(
          height: height ?? 180.h,
          width: width ?? double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            color: color ?? kBlackColor,
            boxShadow: [
              BoxShadow(
                color: kBlackColor.withOpacity(0.5),
                blurRadius: 4,
                blurStyle: BlurStyle.outer,
                spreadRadius: 2,
              ),
            ],
          ),
          child: widget,
        ),
      ),
    );
  }
}
