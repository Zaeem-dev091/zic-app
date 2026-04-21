import 'package:get/get.dart';
import 'package:zic/features/screens/auth/authController/auth_controller.dart';
import 'package:zic/features/screens/home/controller/daily_reward_controller.dart';
import 'package:zic/features/screens/home/controller/feedback_controller.dart';
import 'package:zic/features/screens/home/controller/home_controller.dart';
import 'package:zic/features/screens/home/controller/level_controller.dart';
import 'package:zic/features/screens/home/controller/profile_controller.dart';
import 'package:zic/features/screens/home/controller/referral_controller.dart';
import 'package:zic/features/screens/home/controller/reward_controller.dart';
import 'package:zic/features/screens/home/controller/social_controller.dart';
import 'package:zic/features/screens/home/controller/streak_controller.dart';
import 'package:zic/features/screens/home/controller/wallet_controller.dart';
import 'package:zic/features/screens/splash/controller/splash_controller.dart';
import 'package:zic/utils/services/api_services.dart';
import 'package:zic/utils/services/base_api_services.dart';

class ScreenBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashScreenController());
    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<ReferralController>(() => ReferralController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    Get.lazyPut<LevelController>(() => LevelController(), fenix: true);
    Get.lazyPut<RewardController>(() => RewardController(), fenix: true);
    Get.lazyPut<SocialController>(() => SocialController(), fenix: true);
    Get.lazyPut<WalletController>(() => WalletController(), fenix: true);
    Get.lazyPut<StreakController>(() => StreakController(), fenix: true);
    Get.lazyPut<FeedbackController>(() => FeedbackController(), fenix: true);
    Get.lazyPut<DailyRewardController>(
      () => DailyRewardController(),
      fenix: true,
    );
    Get.lazyPut<BaseApiService>(() => BaseApiService(), fenix: true);
  }
}
