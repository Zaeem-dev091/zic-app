class ProfileModel {
  final String name;
  final String email;
  final String referralNo;
  final int totalReferrals;
  final int activeMiners;
  final double walletBalance;
  final String walletAddress;
  final int streak;
  final int currentLevel;
  final DateTime createdAt;
  final bool isMining;
  final double ratePerSecond;
  final int secondsLeft;
  final int totalMiningDuration;
  final double? totalBalance;

  ProfileModel({
    required this.name,
    required this.email,
    required this.referralNo,
    required this.totalReferrals,
    required this.activeMiners,
    required this.walletBalance,
    required this.walletAddress,
    required this.streak,
    required this.currentLevel,
    required this.createdAt,
    required this.isMining,
    required this.ratePerSecond,
    required this.secondsLeft,
    required this.totalMiningDuration,
    this.totalBalance,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic v) => double.tryParse(v.toString()) ?? 0.0;

    // 🔧 FIX: Handle nested data structure
    final data = json['data'] ?? json;

    // 🔧 FIX: Parse time_left with HH:MM:SS format
    final timeStr = data['time_left']?.toString() ?? '00:00:00';
    final timeParts = timeStr.split(':');
    int parsedSeconds;

    if (timeParts.length == 3) {
      // Format: HH:MM:SS
      parsedSeconds =
          (int.tryParse(timeParts[0]) ?? 0) * 3600 + // hours to seconds
          (int.tryParse(timeParts[1]) ?? 0) * 60 + // minutes to seconds
          (int.tryParse(timeParts[2]) ?? 0); // seconds
    } else if (timeParts.length == 2) {
      // Format: MM:SS (legacy fallback)
      parsedSeconds =
          (int.tryParse(timeParts[0]) ?? 0) * 60 +
          (int.tryParse(timeParts[1]) ?? 0);
    } else {
      parsedSeconds = 0;
    }

    // 🔧 FIX: Parse duration with HH:MM:SS format
    final durationStr =
        data['duration']?.toString() ?? '00:05:00'; // Default 5 min
    final durationParts = durationStr.split(':');
    int totalDuration;

    if (durationParts.length == 3) {
      // Format: HH:MM:SS
      totalDuration =
          (int.tryParse(durationParts[0]) ?? 0) * 3600 +
          (int.tryParse(durationParts[1]) ?? 0) * 60 +
          (int.tryParse(durationParts[2]) ?? 0);
    } else if (durationParts.length == 2) {
      // Format: MM:SS (legacy fallback)
      totalDuration =
          (int.tryParse(durationParts[0]) ?? 0) * 60 +
          (int.tryParse(durationParts[1]) ?? 0);
    } else {
      totalDuration = 300; // Default 5 minutes
    }

    // Debug prints
    print(
      '⏰ time_left raw: $timeStr → parsed: $parsedSeconds seconds (${parsedSeconds ~/ 3600}h ${(parsedSeconds % 3600) ~/ 60}m ${parsedSeconds % 60}s)',
    );
    print(
      '⏰ duration raw: $durationStr → parsed: $totalDuration seconds (${totalDuration ~/ 3600}h ${(totalDuration % 3600) ~/ 60}m)',
    );

    return ProfileModel(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      referralNo: data['referral_no'] ?? '',
      totalReferrals: data['total_referrals'] ?? 0,
      activeMiners: data['active_miners'] ?? 0,
      walletBalance: toDouble(data['wallet_balance']),
      totalBalance: toDouble(data['wallet_balance']),
      walletAddress: data['wallet_address'] ?? '',
      streak: data['streak'] ?? 0,
      currentLevel: data['current_level'] ?? 0,
      createdAt: DateTime.tryParse(data['created_at'] ?? '') ?? DateTime.now(),
      isMining: data['is_mining'] ?? false,
      ratePerSecond: toDouble(data['rate']),
      secondsLeft: parsedSeconds,
      totalMiningDuration: totalDuration,
    );
  }
}
