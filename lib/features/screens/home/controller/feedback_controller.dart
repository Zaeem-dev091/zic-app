import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zic/utils/models/feedback.dart';
import 'package:zic/utils/services/api_services.dart';

class FeedbackController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  // ── Form State ──
  final TextEditingController feedbackTextController = TextEditingController();
  final rating = 0.0.obs;
  final selectedCategory = 'Suggestion'.obs;
  final isSubmitting = false.obs;

  final List<String> categories = const [
    'Suggestion',
    'Bug Report',
    'Feature Request',
    'UI/UX Feedback',
    'Other',
  ];

  @override
  void onClose() {
    feedbackTextController.dispose();
    super.onClose();
  }

  // ── Actions ──

  void setRating(int value) => rating.value = value.toDouble();

  void setCategory(String value) => selectedCategory.value = value;

  void resetForm() {
    feedbackTextController.clear();
    rating.value = 0;
    selectedCategory.value = categories.first;
  }

  Future<void> submitFeedback({
    required void Function(String message, {required bool success}) onResult,
  }) async {
    if (isSubmitting.value) return;

    if (rating.value == 0) {
      onResult(
        'Please rate your experience before submitting.',
        success: false,
      );
      return;
    }

    final feedbackText = feedbackTextController.text.trim();
    if (feedbackText.isEmpty) {
      onResult('Please enter your feedback.', success: false);
      return;
    }

    isSubmitting.value = true;

    final model = FeedbackModel(
      message: feedbackText,
      rating: rating.value.toInt(),
      category: selectedCategory.value,
    );

    final result = await _apiService.submitFeedback(
      message: model.message,
      rating: model.rating,
      category: model.category,
    );

    isSubmitting.value = false;

    if (result['success'] == true) {
      resetForm();
      onResult('Thanks! Your feedback was submitted.', success: true);
    } else {
      onResult(
        result['message'] ?? 'Something went wrong. Please try again.',
        success: false,
      );
    }
  }
}
