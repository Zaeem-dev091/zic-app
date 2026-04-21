import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/features/screens/home/screens/home/home.dart';
import 'package:zic/features/screens/onboarding/controller/onboarding_controller.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OnboardingController());

    return Scaffold(
      backgroundColor: T.steelBorder,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final dotsBottom = (constraints.maxHeight * 0.18)
                .clamp(120.0, 190.0)
                .toDouble();
            final buttonBottom = (constraints.maxHeight * 0.05)
                .clamp(24.0, 56.0)
                .toDouble();
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: controller.pageController,
                        itemCount: controller.pages.length,
                        onPageChanged: controller.onPageChanged,
                        itemBuilder: (context, index) {
                          final page = controller.pages[index];

                          return SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    height: 200.h,
                                    width: 200.w,
                                    child: Image.asset(
                                      page.imageAsset,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, _, _) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.12,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20.r,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  Column(
                                    children: [
                                      Text(
                                        page.title,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 32.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 20),

                                      Text(
                                        page.description,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          height: 1.35,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: 70),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                Positioned(
                  bottom: dotsBottom,
                  left: 0,
                  right: 0,
                  child: Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(controller.pages.length, (
                        dotIndex,
                      ) {
                        final isActive =
                            controller.currentPage.value == dotIndex;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          margin: EdgeInsets.symmetric(horizontal: 6.w),
                          height: 14.h,
                          width: isActive ? 26.w : 14.w,
                          decoration: BoxDecoration(
                            color: isActive ? Colors.white : Colors.white30,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        );
                      }),
                    ),
                  ),
                ),

                Positioned(
                  bottom: buttonBottom,
                  left: 15.w,
                  right: 15.w,
                  child: SizedBox(
                    width: double.infinity,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.onNextTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: kPrimaryDark,
                          elevation: 0,
                          minimumSize: Size(0, 50.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          controller
                              .pages[controller.currentPage.value]
                              .buttonText,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
