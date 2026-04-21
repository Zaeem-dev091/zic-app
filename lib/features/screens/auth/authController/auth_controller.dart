import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/customization/app_strings.dart';
import 'package:zic/customization/widgets/feedback_style_snackbar.dart';
import 'package:zic/utils/services/api_services.dart';

class AuthController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final referralController = TextEditingController();

  final obscurePassword = true.obs;
  final isLoading = false.obs;

  // Validity state
  final isNameValid = false.obs;
  final isEmailValid = false.obs;
  final isPasswordValid = false.obs;

  // Dirty state — only show error after user has touched the field
  final isNameDirty = false.obs;
  final isEmailDirty = false.obs;
  final isPasswordDirty = false.obs;

  final ApiService apiService = Get.find<ApiService>();

  String? get nameError {
    if (!isNameDirty.value) return null;
    if (nameController.text.trim().isEmpty) return 'Name is required';
    if (nameController.text.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  String? get emailError {
    if (!isEmailDirty.value) return null;
    if (emailController.text.trim().isEmpty) return 'Email is required';
    if (!GetUtils.isEmail(emailController.text.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? get passwordError {
    if (!isPasswordDirty.value) return null;
    if (passwordController.text.isEmpty) return 'Password is required';
    if (passwordController.text.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  // ---------------- UI Helpers ----------------

  void _showLoader() {
    if (!(Get.isDialogOpen ?? false)) {
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: kSecondaryGold)),
        barrierDismissible: false,
      );
    }
  }

  void _hideLoader() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  void togglePasswordVisibility() => obscurePassword.toggle();

  // ---------------- Validation ----------------

  void validateName(String value) {
    isNameDirty.value = true;
    isNameValid.value = value.trim().length >= 3;
  }

  void validateEmail(String value) {
    isEmailDirty.value = true;
    isEmailValid.value = GetUtils.isEmail(value.trim());
  }

  void validatePassword(String value) {
    isPasswordDirty.value = true;
    isPasswordValid.value = value.length >= 8;
  }

  bool get isLoggedIn => apiService.token.value.isNotEmpty;

  void resetForm() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    referralController.clear();

    isNameValid.value = false;
    isEmailValid.value = false;
    isPasswordValid.value = false;

    isNameDirty.value = false;
    isEmailDirty.value = false;
    isPasswordDirty.value = false;

    obscurePassword.value = true;
  }

  // ---------------- REGISTER ----------------

  Future<void> register() async {
    isNameDirty.value = true;
    isEmailDirty.value = true;
    isPasswordDirty.value = true;

    validateName(nameController.text);
    validateEmail(emailController.text);
    validatePassword(passwordController.text);

    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      showFeedbackStyleSnackbar(
        message: 'Please fill in all required fields',
        success: false,
      );
      return;
    }

    if (!isNameValid.value) {
      showFeedbackStyleSnackbar(
        message: 'Name must be at least 3 characters',
        success: false,
      );
      return;
    }

    if (!isEmailValid.value) {
      showFeedbackStyleSnackbar(
        message: 'Please enter a valid email address',
        success: false,
      );
      return;
    }

    if (!isPasswordValid.value) {
      showFeedbackStyleSnackbar(
        message: 'Password must be at least 8 characters',
        success: false,
      );
      return;
    }

    isLoading.value = true;

    final String referralCode = referralController.text.trim();

    final result = await apiService.register(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      referralCode: referralCode.isEmpty ? null : referralCode,
    );

    isLoading.value = false;
    _hideLoader();

    if (result['success'] == true) {
      resetForm();
      showFeedbackStyleSnackbar(
        message: 'Account created successfully! Please log in.',
        success: true,
        duration: const Duration(seconds: 3),
      );
      Get.offAllNamed(kHomeRoute);
    } else {
      showFeedbackStyleSnackbar(
        message: result['message'] ?? 'Registration failed. Please try again.',
        success: false,
      );
    }
  }

  // ---------------- LOGIN ----------------

  Future<void> login() async {
    FocusManager.instance.primaryFocus?.unfocus();

    isEmailDirty.value = true;
    isPasswordDirty.value = true;

    validateEmail(emailController.text);
    validatePassword(passwordController.text);

    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      showFeedbackStyleSnackbar(
        message: 'Please enter your email and password',
        success: false,
      );
      return;
    }

    if (!isEmailValid.value) {
      showFeedbackStyleSnackbar(
        message: 'Please enter a valid email address',
        success: false,
      );
      return;
    }

    if (!isPasswordValid.value) {
      showFeedbackStyleSnackbar(
        message: 'Password must be at least 8 characters',
        success: false,
      );
      return;
    }

    isLoading.value = true;

    final result = await apiService.login(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    isLoading.value = false;
    _hideLoader();

    if (result['success'] == true) {
      passwordController.clear();
      isPasswordDirty.value = false;
      Get.offAllNamed(kHomeRoute);
    } else {
      showFeedbackStyleSnackbar(
        message:
            result['message'] ?? 'Login failed. Please check your credentials.',
        success: false,
      );
    }
  }

  // ---------------- LOGOUT ----------------

  Future<void> logout() async {
    _showLoader();

    final result = await apiService.logout();

    _hideLoader();

    resetForm();
    Get.offAllNamed(kLoginRoute);
    debugPrint(result['message']?.toString() ?? 'Logged out');
  }
}
