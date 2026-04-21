// features/screens/home/controller/streak_controller.dart

import 'package:get/get.dart';
import 'package:zic/customization/widgets/feedback_style_snackbar.dart';
import 'package:zic/features/screens/home/controller/home_controller.dart';
import 'package:zic/utils/models/streak.dart';
import 'package:zic/utils/services/api_services.dart';

class StreakController extends GetxController {
  static StreakController get to => Get.find();

  final ApiService _api = Get.find<ApiService>();
  HomeController get _home => Get.find<HomeController>();

  final Rxn<StreakStatusModel> streakStatus = Rxn<StreakStatusModel>();
  final RxBool isLoading = false.obs;
  final RxSet<int> claimingDays = <int>{}.obs;

  // ── Convenience getters ──
  int get currentStreak => streakStatus.value?.currentStreak ?? 0;
  List<StreakTierModel> get tiers => streakStatus.value?.tiers ?? [];
  int get totalRewardsEarned => streakStatus.value?.totalRewardsEarned ?? 0;
  StreakTierModel? get nextClaimableTier =>
      streakStatus.value?.nextClaimableTier;
  StreakTierModel? get nextLockedTier => streakStatus.value?.nextLockedTier;

  // Progress bar toward next tier
  double get progressToNext =>
      streakStatus.value?.getProgressToNext(currentStreak) ?? 0.0;

  // Next reward label e.g. "DAY 30"
  String get nextRewardLabel {
    final next = nextLockedTier;
    if (next == null) return 'MAX';
    return 'DAY ${next.days}';
  }

  // Whether any tier is currently claimable
  bool get hasClaimableTier => nextClaimableTier != null;

  @override
  void onInit() {
    super.onInit();
    fetchStreakStatus();
  }

  // ────────────────────────────────────────────
  // GET /getdays
  // ────────────────────────────────────────────
  Future<void> fetchStreakStatus() async {
    isLoading.value = true;
    try {
      final result = await _api.getStreakStatus();

      if (result['success'] == true) {
        streakStatus.value = StreakStatusModel.fromJson(result);
      } else {
        print('fetchStreakStatus failed: ${result['message']}');
      }
    } catch (e) {
      print('fetchStreakStatus error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ────────────────────────────────────────────
  // POST /claimstreakreward
  // ✅ Shows dialog first, then calls API
  // ────────────────────────────────────────────
  Future<ClaimStreakResponseModel?> claimStreakReward(int days) async {
    if (claimingDays.contains(days)) return null;
    claimingDays.add(days);

    try {
      final result = await _api.claimStreakReward(days);
      final response = ClaimStreakResponseModel.fromJson(result);

      if (response.success) {
        // Update wallet balance in HomeController
        _home.setWalletBalance(response.newBalance);

        // Refresh streak data to reflect new claimed status
        await fetchStreakStatus();

        return response;
      } else {
        showFeedbackStyleSnackbar(
          message: response.message.isNotEmpty
              ? response.message
              : 'Unable to claim reward',
          success: false,
          position: SnackPosition.TOP,
        );
        return null;
      }
    } catch (e) {
      print('claimStreakReward error: $e');
      showFeedbackStyleSnackbar(
        message: 'An error occurred: $e',
        success: false,
      );
      return null;
    } finally {
      claimingDays.remove(days);
    }
  }

  bool isClaimingDay(int days) => claimingDays.contains(days);

  @override
  Future<void> refresh() => fetchStreakStatus();
}
