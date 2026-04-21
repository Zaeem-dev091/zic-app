import 'package:get/get.dart';
import 'package:zic/customization/app_strings.dart';
import 'package:zic/customization/bindings.dart';
import 'package:zic/features/screens/auth/login/view/login_screen.dart';
import 'package:zic/features/screens/auth/register/view/signup_screen.dart';
import 'package:zic/features/screens/home/screens/bottom_bar.dart';
import 'package:zic/features/screens/onboarding/view/onboarding_screen.dart';
import 'package:zic/features/screens/splash/view/splash_screen.dart';

class RouteGenerator {
  static List<GetPage> getPages() {
    return [
      GetPage(
        name: kSplashRoute,
        page: () => SplashScreen(),
        binding: ScreenBindings(),
      ),
      GetPage(
        name: kOnboardingRoute,
        page: () => OnboardingScreen(),
        binding: ScreenBindings(),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: kSignupRoute,
        page: () => SignupScreen(),
        binding: ScreenBindings(),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: kLoginRoute,
        page: () => LoginScreen(),
        binding: ScreenBindings(),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: kHomeRoute,
        page: () => BottomBar(),
        binding: ScreenBindings(),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: kLogout,
        page: () => LoginScreen(),
        binding: ScreenBindings(),
        transition: Transition.fadeIn,
      ),
    ];
  }
}
