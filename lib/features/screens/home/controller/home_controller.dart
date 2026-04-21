import 'dart:async';
import 'package:get/get.dart';
import 'package:zic/features/screens/home/controller/level_controller.dart';
import 'package:zic/features/screens/home/controller/profile_controller.dart';
import 'package:zic/features/screens/home/controller/reward_controller.dart';
import 'package:zic/features/screens/home/controller/social_controller.dart';
import 'package:zic/features/screens/home/controller/wallet_controller.dart';

class HomeController extends GetxController {
  // ── References to other controllers ──
  final ProfileController profileController = Get.find<ProfileController>();
  final LevelController levelController = Get.find<LevelController>();
  final WalletController walletController = Get.find<WalletController>();
  final RewardController rewardController = Get.find<RewardController>();
  final SocialController socialController = Get.find<SocialController>();

  // ── Local reactive state for mining session display ──
  final RxDouble displayBalance = 0.0.obs;
  final RxInt sessionSecondsLeft = 0.obs;

  final walletBalance = 0.0.obs;

  Timer? _sessionTimer;

  @override
  void onInit() {
    super.onInit();
    _bindProfileAndWallet();
    _restoreSession();
  }

  @override
  void onClose() {
    _sessionTimer?.cancel();
    super.onClose();
  }

  // ── Bind reactive values from profile and wallet controllers ──
  void _bindProfileAndWallet() {
    ever(profileController.walletBalance, (_) {
      displayBalance.value = profileController.walletBalance.value;
    });

    ever(profileController.secondsLeft, (_) {
      sessionSecondsLeft.value = profileController.secondsLeft.value;
      if (sessionSecondsLeft.value > 0) _startSessionCountdown();
    });
  }

  // ── Mining session timer ──
  void _restoreSession() {
    if (profileController.isMining.value &&
        profileController.secondsLeft.value > 0) {
      sessionSecondsLeft.value = profileController.secondsLeft.value;
      _startSessionCountdown();
    }
  }

  void _startSessionCountdown() {
    _sessionTimer?.cancel();

    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (sessionSecondsLeft.value <= 0) {
        _sessionTimer?.cancel();
      } else {
        sessionSecondsLeft.value--;
        displayBalance.value += profileController.ratePerSecond.value;
      }
    });
  }

  // ── Computed labels for UI ──
  String get balanceLabel => _format(displayBalance.value, 4);
  String get miningRateLabel =>
      _format(profileController.ratePerSecond.value, 8);
  String get sessionTimeLabel {
    final s = sessionSecondsLeft.value;
    final h = s ~/ 3600;
    final m = (s % 3600) ~/ 60;
    final sec = s % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  String _format(double val, int decimals) {
    final fixed = val.toStringAsFixed(decimals);
    return fixed
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }

  /// ────────────────────────────────────────────
  /// Add coins to wallet (e.g., from referrals, rewards)
  /// ────────────────────────────────────────────
  void addZic(double amount) {
    if (amount <= 0) return;
    walletBalance.value += amount;
  }

  /// ────────────────────────────────────────────
  /// Set wallet balance directly (from API)
  /// ────────────────────────────────────────────
  void setWalletBalance(double balance) {
    if (balance < 0) return;
    walletBalance.value = balance;
  }

  /// ────────────────────────────────────────────
  /// Optional: Helper to reset wallet
  /// ────────────────────────────────────────────
  void resetWallet() {
    walletBalance.value = 0.0;
  }

  // ── Social helpers ──
  Future<void> openTelegram() =>
      socialController.openUrl('https://t.me/your_channel');
  Future<void> openX() =>
      socialController.openUrl('https://x.com/your_profile');
}
