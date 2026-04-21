import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zic/customization/app_colors.dart';

class CustomCard extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? borderColor;
  final Widget child;
  final BorderRadius? radius;
  const CustomCard({
    super.key,
    this.height,
    this.width,
    this.borderColor,
    required this.child,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 120.h,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor ?? Color(0xff68eee6), width: 1.5),
        color: kBlackColor.withOpacity(0.3),
        borderRadius: radius ?? BorderRadius.circular(20.r),
      ),

      child: child,
    );
  }
}
