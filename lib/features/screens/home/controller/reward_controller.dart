import 'package:get/get.dart';
import 'package:zic/utils/services/api_services.dart';

class RewardController extends GetxController {
  final ApiService _api = Get.find<ApiService>();

  var canClaim = false.obs;
  var message = ''.obs;

  Future<void> fetchRewardStatus() async {
    final res = await _api.getWeekendRewardStatus();

    final data = res['data'];
    canClaim.value = data['is_claimable'] == true;
    message.value = data['message'] ?? '';
  }

  Future<void> claimReward() async {
    final res = await _api.claimWeekendReward();

    if (res['success']) {
      await fetchRewardStatus();
    }
  }
}
