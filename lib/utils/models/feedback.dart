class FeedbackModel {
  final String message;
  final int rating;
  final String category;

  FeedbackModel({
    required this.message,
    required this.rating,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
    'description': message,
    'rating': rating,
    'category': category,
  };
}

class FeedbackResponse {
  final bool success;
  final String? message;

  FeedbackResponse({required this.success, this.message});

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) {
    return FeedbackResponse(
      success: json['success'] == true,
      message: json['message'] as String?,
    );
  }
}
