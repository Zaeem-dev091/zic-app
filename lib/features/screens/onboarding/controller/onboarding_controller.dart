import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zic/customization/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zic/utils/app_constants/app_constants.dart';

class OnboardingController extends GetxController {
  final currentPage = 0.obs;
  final PageController pageController = PageController();

  final List<OnboardingItem> pages = const [
    OnboardingItem(
      imageAsset: 'assets/images/z.png',
      title: 'Welcome to Zic',
      description:
          'Zic is a miner app that can start with your phone. Zic is owned and operated by every day users like yourself.',
      buttonText: 'Next',
    ),
    OnboardingItem(
      imageAsset: 'assets/images/minings.png',
      title: 'Stay Connected',
      description:
          'Tap Zic for daily check-in with our free, energy-light mobile app. Your daily tap ensures that Zic ends up in the hands of real humans, not bots.',
      buttonText: 'Next Step',
    ),
    OnboardingItem(
      imageAsset: 'assets/images/loc.png',
      title: 'Refer & Claim',
      description:
          'Invite your friends and earn (both of you) up to 25% bonus on your base mining rate for each friend that joins your team.',
      buttonText: 'Next Step',
    ),
    OnboardingItem(
      imageAsset: 'assets/images/coin.png',
      title: 'Welcome reward',
      description:
          'Congratulations, you have received your first 10.00 Ziccoins which proves our trust in you.',
      buttonText: 'Complete',
    ),
  ];

  bool get isLastPage => currentPage.value == pages.length - 1;

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  Future<void> onNextTap() async {
    if (isLastPage) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.onboardingCompletedKey, true);
      Get.offAllNamed(kLoginRoute);
      return;
    }

    pageController.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class OnboardingItem {
  final String imageAsset;
  final String title;
  final String description;
  final String buttonText;

  const OnboardingItem({
    required this.imageAsset,
    required this.title,
    required this.description,
    required this.buttonText,
  });
}
