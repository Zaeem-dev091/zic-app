import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/customization/app_routes.dart';
import 'package:zic/customization/responsive.dart';
import 'package:zic/customization/app_strings.dart';
import 'package:zic/customization/bindings.dart';
import 'package:zic/features/screens/splash/view/splash_screen.dart';
import 'package:zic/utils/services/api_services.dart';
import 'package:zic/utils/services/base_api_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  runApp(const MyApp());
}

Future<void> initDependencies() async {
  final apiService = ApiService();
  Get.put<BaseApiService>(apiService, permanent: true);
  Get.put<ApiService>(apiService, permanent: true);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      splitScreenMode: true,
      minTextAdapt: true,
      designSize: Size(393, 852),
      builder: (context, child) {
        ScreenUtil.enableScale(
          enableWH: () =>
              ScreenUtil().screenWidth <= AppBreakpoints.scaleCutoffWidth,
          enableText: () => true,
        );
        return GetMaterialApp(
          builder: (context, child) {
            return ScrollConfiguration(
              behavior: const MaterialScrollBehavior().copyWith(
                overscroll: false,
              ),
              child: ResponsiveFrame(child: child ?? const SizedBox.shrink()),
            );
          },

          getPages: RouteGenerator.getPages(),
          initialBinding: ScreenBindings(),
          initialRoute: kSplashRoute,
          theme: ThemeData(
            useMaterial3: false,
            scaffoldBackgroundColor: kBackgroundLight,
            cardColor: kBackgroundCard,
            textTheme: TextTheme(
              bodyMedium: TextStyle(color: kPrimaryTextColor),
              titleMedium: TextStyle(color: kPrimaryTextColor),
              bodyLarge: TextStyle(color: kPrimaryTextColor),
            ),
            colorScheme: ColorScheme.light(
              primary: kPrimaryDark,
              secondary: kSecondaryColor,
              surface: kBackgroundCard,
              onPrimary: kTextWhite,
              onSecondary: kTextPrimary,
              onSurface: kTextPrimary,
              error: kErrorRed,
            ),
            inputDecorationTheme: InputDecorationTheme(
              hintStyle: TextStyle(
                color: kTextfieldTextColor,
                fontWeight: FontWeight.w400,
              ),
              fillColor: kTextfieldColor,
              isDense: true,
              filled: true,
              contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: kBorderLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: kBorderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: kPrimaryLight),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: kErrorRed),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: kErrorRed),
              ),
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: kPrimaryLight,
              foregroundColor: kTextWhite,
              elevation: 0,
              centerTitle: true,
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: kBackgroundCard,
              selectedItemColor: kPrimaryDark,
              unselectedItemColor: kTextLight,
              type: BottomNavigationBarType.fixed,
            ),
            snackBarTheme: SnackBarThemeData(
              backgroundColor: kPrimaryDark,
              contentTextStyle: TextStyle(color: kTextWhite),
              actionTextColor: kSecondaryColor,
            ),
            dividerColor: kDividerColor,
            dialogTheme: DialogThemeData(
              backgroundColor: kBackgroundCard,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: child,
        );
      },
      child: SplashScreen(),
    );
  }
}
