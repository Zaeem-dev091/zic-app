import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/features/screens/home/controller/home_controller.dart';

class ActivationDialog extends StatelessWidget {
  const ActivationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());

    return Container(
      height: 310.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.r),
        color: kWhiteColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => Get.back(),
                child: Icon(Icons.cancel, size: 25.w, color: kBlackColor),
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/flash.png',
                  color: kSecondaryColor,
                  width: 20.w,
                  height: 20.h,
                ),
                SizedBox(width: 5),
                Text(
                  textAlign: TextAlign.start,
                  'Activate Session Boost!',
                  style: TextStyle(
                    color: kBlackColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            Text(
              textAlign: TextAlign.center,
              'Watch a short video ad to activate a 50% session time boost. This boost can be used once per session.\nAfter the ad ends your session time will be updated.',
              style: TextStyle(
                color: kBlackColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 20),
            Obx(
              () => Text(
                'Session Ends In ${controller.sessionTimeLabel}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kPrimaryLight,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 14),
            Container(
              height: 45.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: kPrimaryLight,
              ),
              child: Center(
                child: Text(
                  'Watch Ad & Activate Boost!',
                  style: TextStyle(
                    color: kWhiteColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () => Get.back(),
              child: Container(
                height: 45.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: kPrimaryColor),
                ),
                child: Center(
                  child: Text(
                    'Not Now',
                    style: TextStyle(
                      color: kBlackColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
