import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/features/screens/home/screens/home/home.dart';
import 'package:zic/features/screens/splash/controller/splash_controller.dart';

class SplashScreen extends GetView<SplashScreenController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: kBlackColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: AnimatedContainer(
                duration: const Duration(seconds: 3),
                curve: Curves.easeOut,
                width: controller.flagImageSize.value,
                height: controller.logoImageSize.value,
                child: Center(
                  child: Image.asset(
                    'assets/images/3d.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            AnimatedScale(
              scale: controller.textScale.value,
              duration: const Duration(seconds: 3),
              curve: Curves.easeInOutSine,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Welcome to',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,

                        fontSize: 35.sp,
                        color: kWhiteColor,
                      ),
                    ),
                    TextSpan(
                      text: ' ZIC',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 5,
                        fontSize: 35.sp,
                        color: T.cyan,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
