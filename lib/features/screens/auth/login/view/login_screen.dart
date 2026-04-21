import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/customization/app_strings.dart';
import 'package:zic/features/screens/auth/authController/auth_controller.dart';
import 'package:zic/features/screens/home/screens/widgets/coin_animation.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFF4A5662),
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 63.h),

                  // ── Logo ──
                  Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      height: 90.h,
                      width: 90.w,
                      child: AutoFlipImage(),
                    ),
                  ),

                  SizedBox(height: 30.h),

                  // ── Title ──
                  Text(
                    'Log In with Email',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      fontSize: 30.sp,
                      color: ZicColors.cyan,
                      shadows: [
                        Shadow(
                          color: ZicColors.cyan.withValues(alpha: 0.28),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Enter your information to login your account',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: kWhiteColor.withValues(alpha: 0.76),
                    ),
                  ),
                  SizedBox(height: 34.h),

                  // ── Email Field ──
                  Obx(
                    () => _InputShell(
                      child: TextField(
                        cursorColor: ZicColors.cyan,
                        controller: controller.emailController,
                        textInputAction: TextInputAction.next,
                        onChanged: (v) => controller.validateEmail(v),
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: kWhiteColor.withValues(alpha: 0.9),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                            size: 20.w,
                            color: ZicColors.cyan.withValues(alpha: 0.8),
                          ),
                          hintText: 'Email Address',
                          hintStyle: TextStyle(
                            color: kWhiteColor.withValues(alpha: 0.58),
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 20.h,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: BorderSide(
                              color: kTransparentColor,
                              width: 1.2,
                            ),
                          ),
                          errorText: controller.emailError,
                          errorStyle: TextStyle(
                            color: const Color(0xFFFF9EA5),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: BorderSide(
                              color: kErrorRed.withValues(alpha: 0.86),
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: BorderSide(
                              color: kErrorRed.withValues(alpha: 0.94),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // ── Password Field ──
                  Obx(
                    () => _InputShell(
                      child: TextField(
                        cursorColor: ZicColors.cyan,
                        controller: controller.passwordController,

                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) {
                          FocusScope.of(context).unfocus();
                          controller.login();
                        },
                        onChanged: (v) => controller.validatePassword(v),
                        obscureText: controller.obscurePassword.value,
                        style: TextStyle(
                          color: kWhiteColor.withValues(alpha: 0.9),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            size: 20.w,
                            color: ZicColors.cyan.withValues(alpha: 0.8),
                          ),
                          suffixIcon: InkWell(
                            onTap: () => controller.togglePasswordVisibility(),
                            child: Icon(
                              controller.obscurePassword.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: kWhiteColor.withValues(alpha: 0.72),
                            ),
                          ),
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: kWhiteColor.withValues(alpha: 0.58),
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 20.h,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: BorderSide(
                              color: kTransparentColor,
                              width: 1.2,
                            ),
                          ),
                          errorText: controller.passwordError,
                          errorStyle: TextStyle(
                            color: const Color(0xFFFF9EA5),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: BorderSide(
                              color: kErrorRed.withValues(alpha: 0.86),
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: BorderSide(
                              color: kErrorRed.withValues(alpha: 0.94),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 60.h),

                  // ── Login Button ──
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      controller.login();
                    },
                    child: Container(
                      height: 56.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF223744), Color(0xFF0E1721)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        border: Border.all(
                          color: ZicColors.cyan.withValues(alpha: 0.72),
                          width: 1.4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: ZicColors.cyan.withValues(alpha: 0.26),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Obx(
                          () => controller.isLoading.value
                              ? SizedBox(
                                  height: 22.h,
                                  width: 22.h,
                                  child: CircularProgressIndicator(
                                    color: ZicColors.cyan,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 19.sp,
                                    letterSpacing: 0.4,
                                    color: ZicColors.cyan,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30.h),

                  // ── Signup Link ──
                  Center(
                    child: GestureDetector(
                      onTap: () => Get.toNamed(kSignupRoute),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Don't have an account?",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp,
                                color: kWhiteColor.withValues(alpha: 0.75),
                              ),
                            ),
                            TextSpan(
                              text: ' Signup Now',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14.sp,
                                color: ZicColors.cyan,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  // ── Privacy Policy ──
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                'By creating an account or signing you agree to our',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12.5.sp,
                              color: kWhiteColor.withValues(alpha: 0.68),
                            ),
                          ),
                          TextSpan(
                            text: ' Privacy Policy',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12.5.sp,
                              color: ZicColors.cyan,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InputShell extends StatelessWidget {
  final Widget child;

  const _InputShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF52606D), Color(0xFF313D48), Color(0xFF4A5662)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: const Color(0xFFE8D59B).withValues(alpha: 0.74),
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: ZicColors.cyan.withValues(alpha: 0.14),
            blurRadius: 10,
            spreadRadius: 0.3,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: const LinearGradient(
            colors: [Color(0xFF1D3442), Color(0xFF122736)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: const Color(0xFFE8D59B).withValues(alpha: 0.55),
            width: 0.95,
          ),
        ),
        child: child,
      ),
    );
  }
}
