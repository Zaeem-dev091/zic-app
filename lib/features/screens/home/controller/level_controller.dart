// features/screens/home/controller/level_controller.dart

import 'package:get/get.dart';
import 'package:zic/customization/widgets/feedback_style_snackbar.dart';
import 'package:zic/utils/models/levels.dart';
import 'package:zic/utils/services/api_services.dart';

class LevelController extends GetxController {
  final ApiService _api = Get.find<ApiService>();

  final isLoading = false.obs;

  // ✅ FIX: Track WHICH levels are being claimed, not just a single bool.
  // This means only the tapped card shows a loader — others stay unaffected.
  final claimingLevels = <int>{}.obs;

  // Helper: check if a specific level is currently being claimed
  bool isClaimingLevel(int levelNo) => claimingLevels.contains(levelNo);

  final levelResponse = Rxn<LevelResponseModel>();

  // Convenience getters
  double get myZic => levelResponse.value?.myLio ?? 0;
  int get currentLevelNo => levelResponse.value?.currentLevelNo ?? 0;
  List<LevelModel> get levels => levelResponse.value?.levels ?? [];
  LevelModel? get currentLevel => levelResponse.value?.currentLevel;
  LevelModel? get nextLevel => levelResponse.value?.nextLevel;

  // Computed observables for UI
  final currentLevelName = ''.obs;
  final currentLevelTitle = ''.obs;
  final nextLevelName = ''.obs;
  final nextLevelMin = 0.obs;
  final nextLevelMax = 0.obs;
  final progress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLevels();
  }

  // GET request - Fetch levels
  Future<void> fetchLevels() async {
    isLoading.value = true;

    try {
      final res = await _api.getUserLevels();

      if (res['success'] == true) {
        levelResponse.value = LevelResponseModel.fromJson(res);
        _updateComputedProperties();
      } else {
        print('Failed to load levels');
        return;
      }
    } catch (e) {
      print("Error fetching levels: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _updateComputedProperties() {
    final response = levelResponse.value;
    if (response == null) return;

    final current = response.currentLevel;
    final next = response.nextLevel;

    print("=== LEVEL DEBUG ===");
    print("Current Level: ${current?.levelNo} - ${current?.name}");
    print("My LIO: ${response.myLio}");
    print("Can claim current level? ${current?.canClaim}");
    print("Is current level claimed? ${current?.isClaimed}");
    print("==================");

    currentLevelName.value = current?.name ?? 'Unknown';
    currentLevelTitle.value = current?.title ?? '';

    progress.value = current?.getProgress(response.myLio) ?? 0.0;

    if (next != null) {
      nextLevelName.value = next.name;
      nextLevelMin.value = next.minZic;
      nextLevelMax.value = next.maxLio ?? 0;
    } else {
      nextLevelName.value = 'Max Level';
      nextLevelMin.value = current?.minZic ?? 0;
      nextLevelMax.value = current?.maxLio ?? 0;
    }
  }

  Future<void> claimLevelReward(int levelNo) async {
    // ✅ FIX: Guard per-level, not globally
    if (isClaimingLevel(levelNo)) return;

    // ✅ FIX: Only mark THIS level as loading
    claimingLevels.add(levelNo);
    print("🎯 Attempting to claim level: $levelNo");

    try {
      final res = await _api.claimLevelReward(levelNo);

      if (res['success'] == true) {
        await fetchLevels();
        showFeedbackStyleSnackbar(
          message: res['message'] ?? 'Reward claimed successfully!',
          success: true,
          duration: const Duration(seconds: 3),
        );
      } else {
        String errorMessage = res['message'] ?? 'Failed to claim reward';

        if (errorMessage.contains('pehle hi le chuke')) {
          await fetchLevels();
        } else {
          print(errorMessage);
        }
      }
    } catch (e) {
      print("Error claiming reward: $e");
    } finally {
      // ✅ FIX: Only remove THIS level from loading set
      claimingLevels.remove(levelNo);
    }
  }

  // Pull-to-refresh
  Future<void> refreshLevels() async {
    await fetchLevels();
  }
}
