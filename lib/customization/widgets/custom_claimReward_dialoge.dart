import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/features/screens/home/controller/home_controller.dart';

class CustomDialoge extends StatefulWidget {
  const CustomDialoge({super.key});

  @override
  State<CustomDialoge> createState() => _CustomDialogeState();
}

class _CustomDialogeState extends State<CustomDialoge> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());

    return Container(
      height: 220.h,
      width: 300.w,
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
            SizedBox(height: 10),
            Text(
              textAlign: TextAlign.start,
              'Weekend Reward!',
              style: TextStyle(
                color: kBlackColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            Text(
              textAlign: TextAlign.center,
              '50 Zic!',
              style: TextStyle(
                color: kSecondaryColor,
                fontSize: 21.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            Text(
              textAlign: TextAlign.center,
              'Congratulations!\nYour Earned 50 Zic Reward',
              style: TextStyle(
                color: kBlackColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: _isLoading
                  ? null
                  : () async {
                      setState(() => _isLoading = true);
                      // final bool claimed = await controller.claimReward();
                      // if (claimed && (Get.isDialogOpen ?? false)) {
                      //   Get.back();
                      //   return;
                      // }
                      // if (!claimed) {
                      //   // final String message =
                      //   //     controller.weekendRewardMessage.value.isNotEmpty
                      //   //     ? controller.weekendRewardMessage.value
                      //   //     : 'Reward is not claimable right now';
                      //   // Get.snackbar('Info', message);
                      // }
                      if (mounted) {
                        setState(() => _isLoading = false);
                      }
                    },
              child: Container(
                height: 40.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: kPrimaryLight,
                ),
                child: _isLoading
                    ? Center(
                        child: SizedBox(
                          height: 20.w,
                          width: 20.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              kWhiteColor,
                            ),
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/coins.png',
                            width: 20.w,
                            height: 20.h,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Claim Zic!',
                            style: TextStyle(
                              color: kWhiteColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
