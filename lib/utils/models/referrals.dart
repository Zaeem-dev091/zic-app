class ReferralStatusModel {
  final bool success;
  final int totalReferrals;
  final List<TierModel> tiers;

  ReferralStatusModel({
    required this.success,
    required this.totalReferrals,
    required this.tiers,
  });

  factory ReferralStatusModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final List tiersList = data['tiers'] ?? [];

    return ReferralStatusModel(
      success: json['success'] == true,
      totalReferrals: _parseInt(data['total_referrals']),
      tiers: tiersList
          .map((t) => TierModel.fromJson(t as Map<String, dynamic>))
          .toList(),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class TierModel {
  final int tier;
  final int reward;
  final String status;
  final int progressCurrent;
  final int progressTarget;

  TierModel({
    required this.tier,
    required this.reward,
    required this.status,
    required this.progressCurrent,
    required this.progressTarget,
  });

  factory TierModel.fromJson(Map<String, dynamic> json) {
    // ✅ Parse "0/5" string into two ints
    final progressStr = json['progress']?.toString() ?? '0/0';
    final parts = progressStr.split('/');
    final current = int.tryParse(parts[0]) ?? 0;
    final target = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;

    return TierModel(
      tier: _parseInt(json['tier']),
      reward: _parseInt(json['reward']),
      status: json['status']?.toString() ?? 'locked',
      progressCurrent: current,
      progressTarget: target,
    );
  }

  // ── Computed properties ──

  // e.g. "0/5"
  String get progressStr => '$progressCurrent/$progressTarget';

  // 0.0 → 1.0
  double get progressFraction {
    if (progressTarget <= 0) return 0.0;
    return (progressCurrent / progressTarget).clamp(0.0, 1.0);
  }

  bool get isLocked => status == 'locked';

  // isEligible: API may return 'eligible', 'completed', 'pending', or 'unlocked'
  // when target is reached. We also check progress as a fallback so the claim
  // button always appears when the user has hit the milestone.
  bool get isEligible =>
      status == 'eligible' ||
      status == 'completed' ||
      status == 'unlocked' ||
      (!isClaimed && progressTarget > 0 && progressCurrent >= progressTarget);

  bool get isClaimed => status == 'claimed';

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class ReferralUserModel {
  final String name;
  final String status;
  final double reward;

  ReferralUserModel({
    required this.name,
    required this.status,
    required this.reward,
  });

  factory ReferralUserModel.fromJson(Map<String, dynamic> json) {
    return ReferralUserModel(
      name: json['name']?.toString() ?? 'Unknown',
      status: json['status']?.toString() ?? 'pending',
      reward: _parseDouble(json['reward']),
    );
  }

  bool get isVerified =>
      status.toLowerCase() == 'verified' || status.toLowerCase() == 'active';

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

class ClaimReferralResponseModel {
  final bool success;
  final String message;
  final double balance;

  ClaimReferralResponseModel({
    required this.success,
    required this.message,
    required this.balance,
  });

  factory ClaimReferralResponseModel.fromJson(Map<String, dynamic> json) {
    return ClaimReferralResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      // ✅ balance is at root level per your API response
      balance: _parseDouble(json['balance']),
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
