import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spinning_wheel/models/wheel_segment.dart';
import 'package:zic/customization/widgets/feedback_style_snackbar.dart';
import 'package:zic/utils/models/spinwheel.dart';
import 'package:zic/utils/services/api_services.dart';

class SpinWheelControllerX extends GetxController {
  final StreamController<int> spinStream = StreamController<int>.broadcast();
  final RxInt targetIndex = 0.obs;

  final _api = Get.find<ApiService>();

  // ─── UI STATE ───
  final isLoading = true.obs;
  final isSpinning = false.obs;
  final isClaiming = false.obs;
  final hasSpunOnce = false.obs;

  // ─── DATA ───
  final spinsLeft = 1.obs;
  final totalBalance = '0.00'.obs;
  final selectedReward = ''.obs;

  final wheelItems = <SpinWheelItem>[].obs;
  final segments = <WheelSegment>[].obs;

  SpinResult? _pendingResult;

  final _rewardToIndicesMap = <double, List<int>>{};

  // ─── CONFIG ───
  static const _palette = [
    Color(0xFF1E88E5),
    Color(0xFFFFD700),
    Color(0xFF00C853),
    Color(0xFFFF6D00),
    Color(0xFF9C27B0),
    Color(0xFFEC407A),
    Color(0xFF26C6DA),
    Color(0xFFFF7043),
  ];

  @override
  void onInit() {
    super.onInit();

    _loadRewards();
  }

  @override
  void onClose() {
    spinStream.close();
    super.onClose();
  }

  void loadRewardsPublic() => _loadRewards();

  // ─── LOAD REWARDS ───
  Future<void> _loadRewards() async {
    isLoading.value = true;

    final data = await _api.getSpinRewards();

    if (data == null || data.rewards.isEmpty) {
      isLoading.value = false;
      _showError('Could not load spin rewards');
      return;
    }

    _buildSegments(data.rewards);
    isLoading.value = false;
  }

  // ─── BUILD SEGMENTS ───
  void _buildSegments(List<double> rewards) {
    final items = <SpinWheelItem>[];
    final segs = <WheelSegment>[];

    _rewardToIndicesMap.clear();

    for (int i = 0; i < rewards.length; i++) {
      final coins = rewards[i];
      final label = coins > 0 ? '🪙 ${coins.toInt()}' : 'Try Again!';

      items.add(SpinWheelItem(label: label, coins: coins, index: i));

      // Accumulate all indices for this reward value (e.g. 0 → [1, 2, 3])
      _rewardToIndicesMap.putIfAbsent(coins, () => []).add(i);

      segs.add(
        WheelSegment(
          label,
          coins.toInt(),
          color: _palette[i % _palette.length],

          probability: 1.0 / rewards.length,
        ),
      );
    }

    wheelItems.assignAll(items);
    segments.assignAll(segs);

    debugPrint('─── Reward Index Map ───');
    _rewardToIndicesMap.forEach((coins, indices) {
      debugPrint('  ${coins.toInt()} coins → segments $indices');
    });
    debugPrint('────────────────────────');
  }

  // ─── SPIN ───
  Future<void> spin() async {
    if (isSpinning.value || isClaiming.value) return;
    if (segments.isEmpty) {
      _showError('Wheel not ready');
      return;
    }

    isClaiming.value = true;
    selectedReward.value = 'Connecting...';

    try {
      final result = await _api.claimSpin().timeout(
        const Duration(seconds: 10),
      );

      if (result == null) throw Exception('Spin failed');

      _pendingResult = result;
      spinsLeft.value = result.spinsLeft;
      totalBalance.value = _formatBalance(result.totalBalance);
      hasSpunOnce.value = true;
      final idx = _findTargetIndexForReward(result.addedCoins);
      targetIndex.value = idx;

      isClaiming.value = false;
      isSpinning.value = true;

      spinStream.add(idx);
    } catch (e) {
      isClaiming.value = false;
      selectedReward.value = '';
      _showError(e.toString());
    }
  }

  int _findTargetIndexForReward(double rewardAmount) {
    final indices = _rewardToIndicesMap[rewardAmount] ?? [];

    if (indices.isEmpty) {
      debugPrint('⚠️ No match for $rewardAmount, defaulting to 0');
      return 0;
    }

    final picked = indices[Random().nextInt(indices.length)];
    debugPrint(
      '🎯 Reward $rewardAmount → candidates $indices → picked $picked',
    );
    return picked;
  }

  void onSpinComplete() {
    isSpinning.value = false;

    final result = _pendingResult;
    _pendingResult = null;

    if (result == null) return;

    // Backend result is the truth — visual segment is irrelevant
    selectedReward.value = result.isWinner
        ? 'You won ${result.addedCoins.toStringAsFixed(0)} coins! 🎉'
        : 'Better luck next time';

    _showRewardDialog(
      coins: result.addedCoins,
      balance: result.totalBalance,
      isWinner: result.isWinner,
      isBigWin: result.isBigWin,
    );
  }

  // ─── REWARD DIALOG ───
  void _showRewardDialog({
    required double coins,
    required double balance,
    required bool isWinner,
    required bool isBigWin,
  }) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF182430),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isWinner ? const Color(0xFFE8D59B) : const Color(0xFFFF9E9E),
            width: 1.2,
          ),
        ),
        title: Text(
          isBigWin
              ? 'MEGA WIN! 🏆'
              : isWinner
              ? 'You Won! 🎉'
              : 'Better Luck Next Time 😅',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isBigWin
                ? const Color(0xFFFFD700)
                : isWinner
                ? const Color(0xFFE8D59B)
                : const Color(0xFFFFC7C7),
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isWinner) ...[
              Text(
                '+${coins.toStringAsFixed(0)} coins',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.paid_rounded,
                  color: Color(0xFFE8D59B),
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'Balance: ${_formatBalance(balance)}',
                  style: const TextStyle(
                    color: Color(0xFFA9B7C6),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.casino_rounded,
                  color: Color(0xFF53F7FF),
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'Spins Left: ${spinsLeft.value}',
                  style: const TextStyle(
                    color: Color(0xFFA9B7C6),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: Get.back,
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF53F7FF),
              ),
              child: const Text(
                'OK',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── HELPERS ───
  String _formatBalance(double val) =>
      val.toStringAsFixed(val.truncateToDouble() == val ? 0 : 2);

  void _showError(String msg) =>
      showFeedbackStyleSnackbar(message: msg, success: false);
}
