class DailyRewardItem {
  final int rewardNo;
  final int amount;
  final String status;

  DailyRewardItem({
    required this.rewardNo,
    required this.amount,
    required this.status,
  });

  factory DailyRewardItem.fromJson(Map<String, dynamic> json) {
    return DailyRewardItem(
      rewardNo: json['reward_no'] ?? 0,
      amount: json['amount'] ?? 0,
      status: json['status'] ?? '',
    );
  }

  bool get isClaimed => status == 'claimed';
  bool get isClaimNow => status == 'claim now';
}

class DailyRewardModel {
  final bool success;
  final List<DailyRewardItem> rewards;

  DailyRewardModel({required this.success, required this.rewards});

  factory DailyRewardModel.fromJson(Map<String, dynamic> json) {
    return DailyRewardModel(
      success: json['success'] ?? false,
      rewards: (json['daily_rewards'] as List<dynamic>? ?? [])
          .map((e) => DailyRewardItem.fromJson(e))
          .toList(),
    );
  }

  // The reward that's available to claim right now
  DailyRewardItem? get claimableReward =>
      rewards.where((r) => r.isClaimNow).isNotEmpty
      ? rewards.firstWhere((r) => r.isClaimNow)
      : null;
}
