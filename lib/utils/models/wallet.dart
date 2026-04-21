// ─────────────────────────────────────────────────────────────
// WALLET DATA MODEL
// ─────────────────────────────────────────────────────────────
class WalletData {
  final bool status;
  final double totalBalance;
  final double todayZic;
  final double weeklyZic;
  final List<MiningReward> dailyMiningReward;
  final List<dynamic> dailyReward;
  final List<dynamic> referralBonus;

  WalletData({
    required this.status,
    required this.totalBalance,
    required this.todayZic,
    required this.weeklyZic,
    required this.dailyMiningReward,
    required this.dailyReward,
    required this.referralBonus,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) {
    return WalletData(
      status: json['status'] ?? false,
      totalBalance: _toDouble(json['total_balance']),
      todayZic: _toDouble(json['today_zic']),
      weeklyZic: _toDouble(json['weekly_zic']),
      dailyMiningReward: _parseMiningRewards(json['daily_mining_reward']),
      dailyReward: json['daily_reward'] ?? [],
      referralBonus: json['referral_bonus'] ?? [],
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static List<MiningReward> _parseMiningRewards(dynamic data) {
    if (data == null) return [];
    final list = data is List ? data : [];
    return list.map((item) => MiningReward.fromJson(item)).toList();
  }
}

// ─────────────────────────────────────────────────────────────
// MINING REWARD MODEL
// ─────────────────────────────────────────────────────────────
class MiningReward {
  final double amount;
  final String source;
  final String time;
  final String day;

  MiningReward({
    required this.amount,
    required this.source,
    required this.time,
    required this.day,
  });

  factory MiningReward.fromJson(Map<String, dynamic> json) {
    return MiningReward(
      amount: WalletData._toDouble(json['amount']),
      source: json['source'] ?? 'Daily Mining',
      time: json['time'] ?? '',
      day: json['day'] ?? '',
    );
  }

  String get formattedAmount => '+${amount.toStringAsFixed(2)} Z';
  String get displayTitle => source;
  String get displaySubtitle => '$day • $time';
}

// ─────────────────────────────────────────────────────────────
// ZICPOOL DATA MODEL
// ─────────────────────────────────────────────────────────────
class ZicPoolData {
  final double lio;
  final String walletAddress;

  ZicPoolData({required this.lio, required this.walletAddress});

  factory ZicPoolData.fromJson(Map<String, dynamic> json) {
    return ZicPoolData(
      lio: WalletData._toDouble(json['lio']),
      walletAddress: json['wallet_address'] ?? '',
    );
  }

  bool get hasWallet => walletAddress.isNotEmpty;
  String get formattedLio => '${lio.toStringAsFixed(2)} LIO';
}

// ─────────────────────────────────────────────────────────────
// TRANSFER RESULT MODEL
// ─────────────────────────────────────────────────────────────
class TransferResult {
  final bool success;
  final String message;
  final double newBalance;

  TransferResult({
    required this.success,
    required this.message,
    required this.newBalance,
  });

  factory TransferResult.fromJson(Map<String, dynamic> json) {
    return TransferResult(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      newBalance: WalletData._toDouble(json['new_balance']),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// TRANSFER HISTORY ITEM MODEL
// ─────────────────────────────────────────────────────────────
class TransferHistoryItem {
  final String toName;
  final String toWallet;
  final double amount;
  final double fee;
  final double totalDeducted;
  final String date;

  TransferHistoryItem({
    required this.toName,
    required this.toWallet,
    required this.amount,
    required this.fee,
    required this.totalDeducted,
    required this.date,
  });

  factory TransferHistoryItem.fromJson(Map<String, dynamic> json) {
    return TransferHistoryItem(
      toName: json['to_name'] ?? 'Unknown',
      toWallet: json['to_wallet'] ?? '',
      amount: WalletData._toDouble(json['amount']),
      fee: WalletData._toDouble(json['fee']),
      totalDeducted: WalletData._toDouble(json['total_deducted']),
      date: json['date'] ?? '',
    );
  }

  String get formattedAmount => '-${amount.toStringAsFixed(2)} LIO';
  String get formattedTotal => '${totalDeducted.toStringAsFixed(2)} LIO';
  String get displayTitle => 'Sent to $toName';
  String get displaySubtitle => date;
  String get walletShort => toWallet.length > 20
      ? '${toWallet.substring(0, 10)}...${toWallet.substring(toWallet.length - 10)}'
      : toWallet;
}

// ─────────────────────────────────────────────────────────────
// UNIFIED TRANSACTION MODEL (For UI Display)
// ─────────────────────────────────────────────────────────────
abstract class UnifiedTransaction {
  String get title;
  String get subtitle;
  String get amount;
  bool get isPositive;
  String get type;
}

class MiningTransaction extends UnifiedTransaction {
  final MiningReward reward;

  MiningTransaction(this.reward);

  @override
  String get title => reward.displayTitle;
  @override
  String get subtitle => reward.displaySubtitle;
  @override
  String get amount => reward.formattedAmount;
  @override
  bool get isPositive => true;
  @override
  String get type => 'mining';
}

class TransferTransaction extends UnifiedTransaction {
  final TransferHistoryItem transfer;

  TransferTransaction(this.transfer);

  @override
  String get title => transfer.displayTitle;
  @override
  String get subtitle => transfer.displaySubtitle;
  @override
  String get amount => transfer.formattedAmount;
  @override
  bool get isPositive => false;
  @override
  String get type => 'transfer';
}
