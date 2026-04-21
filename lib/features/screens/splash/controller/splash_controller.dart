import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/customization/app_strings.dart';
import 'package:zic/utils/app_constants/app_constants.dart';
import 'package:zic/utils/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenController extends GetxController {
  final RxDouble flagImageSize = 40.0.obs;
  final RxDouble textScale = 0.5.obs;
  final RxDouble logoImageSize = 40.0.obs;

  @override
  void onInit() {
    super.onInit();
    _startAnimation();
  }

  void _startAnimation() async {
    Future.delayed(const Duration(milliseconds: 200), () {
      flagImageSize.value = 140.w;
      textScale.value = 1.0;
      logoImageSize.value = 140.h;
    });

    await Future.delayed(const Duration(seconds: 5));

    final prefs = await SharedPreferences.getInstance();
    final isOnboardingCompleted =
        prefs.getBool(AppConstants.onboardingCompletedKey) ?? false;

    final apiService = Get.find<ApiService>();
    await apiService.loadUserData();

    final hasToken = apiService.token.value.isNotEmpty;

    if (hasToken) {
      Get.offNamed(kHomeRoute);
      return;
    }

    if (isOnboardingCompleted) {
      Get.offNamed(kLoginRoute);
      return;
    }

    Get.offNamed(kOnboardingRoute);
  }
}
