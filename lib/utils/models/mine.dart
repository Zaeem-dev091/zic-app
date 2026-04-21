class MiningModel {
  final bool success;
  final bool isMining; // ADDED
  final String message;
  final double ratePerSecond; // Will come from profile, not startMining
  final int secondsLeft; // From time_left
  final int totalDuration; // From duration (THIS IS THE KEY!)
  final double walletBalance; // Will come from profile, not startMining

  MiningModel({
    required this.success,
    required this.isMining,
    required this.message,
    required this.ratePerSecond,
    required this.secondsLeft,
    required this.totalDuration,
    required this.walletBalance,
  });

  factory MiningModel.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic v) => double.tryParse(v.toString()) ?? 0.0;

    // Parse time_left (e.g., "04:44" → 284 seconds)
    final timeLeftStr = json['time_left']?.toString() ?? '00:00';
    final timeLeftParts = timeLeftStr.split(':');
    final secondsLeft =
        (int.tryParse(timeLeftParts[0]) ?? 0) * 60 +
        (int.tryParse(timeLeftParts[1]) ?? 0);

    // Parse duration (e.g., "05:00" → 300 seconds)
    final durationStr = json['duration']?.toString() ?? '05:00';
    final durationParts = durationStr.split(':');
    final totalDuration =
        (int.tryParse(durationParts[0]) ?? 0) * 60 +
        (int.tryParse(durationParts[1]) ?? 0);

    return MiningModel(
      success: json['success'] ?? false,
      isMining: json['is_mining'] ?? false,
      message: json['message'] ?? '',
      ratePerSecond: toDouble(json['rate']), // May be null from this endpoint
      secondsLeft: secondsLeft,
      totalDuration: totalDuration,
      walletBalance: toDouble(json['wallet_balance']), // May be null
    );
  }
}
