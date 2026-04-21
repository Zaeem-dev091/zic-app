import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/features/screens/home/controller/home_controller.dart';

class FloatingDialog extends StatefulWidget {
  const FloatingDialog({super.key});

  @override
  State<FloatingDialog> createState() => _FloatingDialogState();
}

class _FloatingDialogState extends State<FloatingDialog> {
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

            Text(
              textAlign: TextAlign.start,
              'Keep Mining!',
              style: TextStyle(
                color: kBlackColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),

            Text(
              textAlign: TextAlign.center,
              'Your next 12/6-hour zic session is starting now. You will get 1+ Zic during this session.\nReady to Start?',
              style: TextStyle(
                color: kBlackColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () async {
                // if (controller.isStartingSession.value) return;
                // final bool started = await controller.startMiningSession();
                // if (started && (Get.isDialogOpen ?? false)) {
                //   Get.back();
                // }
              },
              // child: Container(
              //   height: 45.h,
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(12.r),
              //     color: kPrimaryLight,
              //   ),
              //   child: Obx(
              //     () => controller.isStartingSession.value
              //         ? Center(
              //             child: SizedBox(
              //               height: 20.w,
              //               width: 20.w,
              //               child: CircularProgressIndicator(
              //                 strokeWidth: 2.2,
              //                 valueColor: AlwaysStoppedAnimation<Color>(
              //                   kWhiteColor,
              //                 ),
              //               ),
              //             ),
              //           )
              //         : Center(
              //             child: Text(
              //               'Start!',
              //               style: TextStyle(
              //                 color: kWhiteColor,
              //                 fontSize: 18.sp,
              //                 fontWeight: FontWeight.w700,
              //               ),
              //             ),
              //           ),
              //   ),
              // ),
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
