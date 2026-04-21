import 'dart:async';
import 'package:get/get.dart';
import 'package:zic/utils/models/profile.dart';
import 'package:zic/utils/services/api_services.dart';

class ProfileController extends GetxController {
  final ApiService _api = Get.find<ApiService>();

  // ───────────── Profile Info ─────────────
  var totalBalance = 0.0.obs;
  var shouldUpdateTotalBalance = false.obs;

  var name = ''.obs;
  var email = ''.obs;
  var referralNo = ''.obs;

  var totalReferrals = 0.obs;
  var activeMiners = 0.obs;

  var walletBalance = 0.0.obs;
  var walletAddress = ''.obs;

  var streak = 0.obs;
  var currentLevel = 0.obs;

  // ───────────── Mining Info ─────────────
  var isMining = false.obs;
  var ratePerSecond = 0.0.obs;
  var secondsLeft = 0.obs;
  var totalMiningDuration = 300.obs;

  DateTime? _miningEndTime;
  double _initialBalance = 0;
  DateTime? _miningStartTime;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  // ───────────── Load profile on app open ─────────────
  Future<void> loadUserProfile() async {
    try {
      final profile = await _api.getProfile();
      print('🔍 Backend totalMiningDuration: ${profile?.totalMiningDuration}');
      print(
        '🔍 Cached totalMiningDuration: ${_api.user.value['total_mining_duration']}',
      );

      if (profile != null) {
        _applyProfile(profile);

        return;
      }

      // fallback to cache
      final cached = _api.user.value;
      if (cached.isNotEmpty) {
        _applyProfile(
          ProfileModel.fromJson(Map<String, dynamic>.from(cached)),
          syncSession: false,
        );
      }
    } catch (e) {
      print("loadUserProfile error: $e");
    }
  }

  // ───────────── Apply profile ─────────────
  void _applyProfile(ProfileModel p, {bool syncSession = true}) {
    name.value = p.name;
    email.value = p.email;
    referralNo.value = p.referralNo;
    totalReferrals.value = p.totalReferrals;
    activeMiners.value = p.activeMiners;
    walletBalance.value = p.walletBalance;
    walletAddress.value = p.walletAddress;
    streak.value = p.streak;
    currentLevel.value = p.currentLevel;
    isMining.value = p.isMining;
    ratePerSecond.value = p.ratePerSecond;
    secondsLeft.value = p.secondsLeft;
    totalMiningDuration.value = p.totalMiningDuration;
    totalBalance.value = p.totalBalance ?? p.walletBalance;

    // if already mining when app opens → resume local timer
    if (p.isMining && p.secondsLeft > 0) {
      _initialBalance = p.walletBalance;
      _miningStartTime = DateTime.now();
      _miningEndTime = DateTime.now().add(Duration(seconds: p.secondsLeft));
      _runTimer();
    } else {
      isMining.value = false;
      secondsLeft.value = 0;
    }

    if (syncSession) _persistProfile(p);
  }

  // ───────────── Tap Start Mining button ─────────────
  Future<void> tapStartMining() async {
    try {
      final mining = await _api.startMining();

      if (mining == null) return;

      // Handle case where mining is already in progress
      if (mining.isMining && mining.message == "Mining in progress...") {
        print('⛏️ Mining already in progress');
        // Parse the duration from the response
        // You might need to update your startMining response model too
      }

      // Refresh profile to get updated time_left and duration
      await loadUserProfile();
    } catch (e) {
      print("tapStartMining error: $e");
    }
  }

  // ───────────── Local Timer ─────────────
  void _runTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (_miningEndTime == null || _miningStartTime == null) return;

      final now = DateTime.now();

      // how many seconds left
      final remaining = _miningEndTime!
          .difference(now)
          .inSeconds
          .clamp(0, 99999);

      secondsLeft.value = remaining;

      final elapsed = now.difference(_miningStartTime!).inSeconds;

      // balance = initial + (rate × elapsed)
      walletBalance.value = _initialBalance + (ratePerSecond.value * elapsed);

      // stop when time runs out
      if (remaining <= 0) {
        isMining.value = false;
        _timer?.cancel();

        // Auto-refresh profile from API
        refreshProfileAfterMining();
      }

      // how many seconds passed since mining started
    });
  }

  Future<void> refreshProfileAfterMining() async {
    try {
      // Fetch fresh profile from API
      final profile = await _api.getProfile();

      if (profile != null) {
        // Update all values with fresh data
        _applyProfile(profile);

        // Trigger UI update flag
        shouldUpdateTotalBalance.value = true;

        // Reset flag after animation
        Future.delayed(const Duration(seconds: 2), () {
          shouldUpdateTotalBalance.value = false;
        });

        // Show success message
        print(
          '✅ Success!\n'
          'Your total balance has been updated!',
        );
      }
    } catch (e) {
      print("Error refreshing profile after mining: $e");

      // Even if API fails, update total balance with local calculation
      totalBalance.value = walletBalance.value;
      shouldUpdateTotalBalance.value = true;
    }
  }

  // ───────────── Persist to cache ─────────────
  void _persistProfile(ProfileModel p) {
    final m = (secondsLeft.value ~/ 60).toString().padLeft(2, '0');
    final s = (secondsLeft.value % 60).toString().padLeft(2, '0');

    _api.user.value = {
      'name': p.name,
      'email': p.email,
      'referral_no': p.referralNo,
      'total_referrals': p.totalReferrals,
      'active_miners': p.activeMiners,
      'wallet_balance': walletBalance.value,
      'wallet_address': p.walletAddress,
      'streak': p.streak,
      'current_level': p.currentLevel,
      'is_mining': isMining.value,
      'rate': p.ratePerSecond.toString(),
      'time_left': '$m:$s',
      'created_at': p.createdAt.toIso8601String(),
    };
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
