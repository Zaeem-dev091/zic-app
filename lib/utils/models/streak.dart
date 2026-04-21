// utils/models/streak_model.dart

class StreakStatusModel {
  final bool success;
  final int currentStreak;
  final List<StreakTierModel> tiers;

  StreakStatusModel({
    required this.success,
    required this.currentStreak,
    required this.tiers,
  });

  factory StreakStatusModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final List tiersList = data['tiers'] ?? [];

    return StreakStatusModel(
      success: json['success'] == true,
      currentStreak: _parseInt(data['current_streak']),
      tiers: tiersList
          .map((t) => StreakTierModel.fromJson(t as Map<String, dynamic>))
          .toList(),
    );
  }

  // Total rewards earned from claimed tiers
  int get totalRewardsEarned {
    return tiers.where((t) => t.isClaimed).fold(0, (sum, t) => sum + t.reward);
  }

  // Next claimable tier
  StreakTierModel? get nextClaimableTier {
    try {
      return tiers.firstWhere((t) => t.isClaimNow);
    } catch (_) {
      return null;
    }
  }

  // Next locked tier after current
  StreakTierModel? get nextLockedTier {
    try {
      return tiers.firstWhere((t) => t.isLocked);
    } catch (_) {
      return null;
    }
  }

  // Progress toward next locked tier
  double getProgressToNext(int currentStreak) {
    final next = nextLockedTier ?? nextClaimableTier;
    if (next == null) return 1.0;

    // Find previous tier
    final idx = tiers.indexOf(next);
    final prevDays = idx > 0 ? tiers[idx - 1].days : 0;
    final span = next.days - prevDays;
    if (span <= 0) return 1.0;

    return ((currentStreak - prevDays) / span).clamp(0.0, 1.0);
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class StreakTierModel {
  final int days;
  final int reward;
  final String status; // "claimed" | "claim Now" | "locked"

  StreakTierModel({
    required this.days,
    required this.reward,
    required this.status,
  });

  factory StreakTierModel.fromJson(Map<String, dynamic> json) {
    return StreakTierModel(
      days: _parseInt(json['days']),
      reward: _parseInt(json['reward']),
      status: json['status']?.toString() ?? 'locked',
    );
  }

  // ── Computed properties ──
  bool get isClaimed => status.toLowerCase() == 'claimed';
  bool get isClaimNow => status.toLowerCase() == 'claim now';
  bool get isLocked => status.toLowerCase() == 'locked';

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class ClaimStreakResponseModel {
  final bool success;
  final String message;
  final double newBalance;

  ClaimStreakResponseModel({
    required this.success,
    required this.message,
    required this.newBalance,
  });

  factory ClaimStreakResponseModel.fromJson(Map<String, dynamic> json) {
    return ClaimStreakResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      // ✅ "new_balance" at root level
      newBalance: _parseDouble(json['new_balance']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
