// models/level_model.dart
class LevelModel {
  final int levelNo;
  final String title;
  final String name;
  final String description;
  final int minZic;
  final int? maxLio;
  final double rewardAmount;
  final bool isCurrent;
  final bool isClaimed;
  final bool canClaim;

  LevelModel({
    required this.levelNo,
    required this.title,
    required this.name,
    required this.description,
    required this.minZic,
    this.maxLio,
    required this.rewardAmount,
    required this.isCurrent,
    required this.isClaimed,
    required this.canClaim,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      levelNo: _parseInt(json['level_no']),
      title: json['title']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      minZic: _parseInt(json['min_lio']),
      maxLio: json['max_lio'] != null ? _parseInt(json['max_lio']) : null,
      rewardAmount: _parseDouble(json['reward_amount']),
      isCurrent: json['is_current'] == true,
      isClaimed: json['is_claimed'] == true,
      canClaim: json['can_claim'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level_no': levelNo,
      'title': title,
      'name': name,
      'description': description,
      'min_lio': minZic,
      'max_lio': maxLio,
      'reward_amount': rewardAmount,
      'is_current': isCurrent,
      'is_claimed': isClaimed,
      'can_claim': canClaim,
    };
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  // Computed properties
  String get displayTitle {
    if (title.isNotEmpty) return title;
    if (maxLio == null || maxLio! >= 999999) {
      return 'Level-$levelNo $minZic+ Zic';
    }
    return 'Level-$levelNo $minZic-$maxLio Zic';
  }

  String get rangeText {
    if (maxLio == null || maxLio! >= 999999) {
      return '$minZic+ ZIC';
    }
    return '$minZic - $maxLio ZIC';
  }

  double getProgress(double currentZic) {
    if (maxLio == null || maxLio! >= 999999) return 1.0;
    final span = maxLio! - minZic;
    if (span <= 0) return 1.0;
    final progress = (currentZic - minZic) / span;
    return progress.clamp(0.0, 1.0);
  }

  bool get isMaxLevel => maxLio == null || maxLio! >= 999999;
}

class LevelResponseModel {
  final bool success;
  final double myLio;
  final int currentLevelNo;
  final List<LevelModel> levels;

  LevelResponseModel({
    required this.success,
    required this.myLio,
    required this.currentLevelNo,
    required this.levels,
  });

  factory LevelResponseModel.fromJson(Map<String, dynamic> json) {
    final levelsList = json['levels'] as List? ?? [];

    return LevelResponseModel(
      success: json['success'] == true,
      myLio: LevelModel._parseDouble(json['my_lio']),
      currentLevelNo: LevelModel._parseInt(json['current_level_no']),
      levels: levelsList
          .map((item) => LevelModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  // Computed properties
  LevelModel? get currentLevel {
    try {
      return levels.firstWhere((level) => level.isCurrent);
    } catch (e) {
      return levels.firstWhere(
        (level) => level.levelNo == currentLevelNo,
        orElse: () => levels.first,
      );
    }
  }

  LevelModel? get nextLevel {
    if (levels.isEmpty) return null;

    final current = currentLevel;
    if (current == null) return null;

    final currentIndex = levels.indexWhere((l) => l.levelNo == current.levelNo);
    if (currentIndex != -1 && currentIndex + 1 < levels.length) {
      return levels[currentIndex + 1];
    }
    return null;
  }
}
