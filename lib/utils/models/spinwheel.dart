class SpinRewardsData {
  final List<double> rewards;

  SpinRewardsData({required this.rewards});

  factory SpinRewardsData.fromJson(Map<String, dynamic> json) {
    final raw = json['data'] as List<dynamic>;
    return SpinRewardsData(
      rewards: raw.map((e) => (e as num).toDouble()).toList(),
    );
  }
}

class SpinResult {
  final double addedCoins;
  final double totalBalance;
  final int spinsLeft;

  SpinResult({
    required this.addedCoins,
    required this.totalBalance,
    required this.spinsLeft,
  });

  factory SpinResult.fromJson(Map<String, dynamic> json) {
    return SpinResult(
      addedCoins: (json['coins'] as num).toDouble(),
      totalBalance: double.tryParse(json['total_balance'].toString()) ?? 0,
      spinsLeft: json['spins_left'] ?? 0,
    );
  }

  bool get isWinner => addedCoins > 0;
  bool get isBigWin => addedCoins >= 200;
}

class SpinWheelItem {
  final String label;
  final double coins;
  final int index;

  SpinWheelItem({
    required this.label,
    required this.coins,
    required this.index,
  });
}
