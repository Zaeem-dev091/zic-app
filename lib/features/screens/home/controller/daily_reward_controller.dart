import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zic/features/screens/home/controller/profile_controller.dart';
import 'package:zic/utils/app_constants/app_constants.dart';
import 'package:zic/utils/models/dailyreward.dart';
import 'package:zic/utils/services/base_api_services.dart';

class DailyRewardController extends GetxController {
  BaseApiService get _api => Get.find<BaseApiService>();

  final isLoading = false.obs;
  final isClaiming = false.obs;
  final showOverlay = false.obs;
  final hasClaimed = false.obs;
  final claimedAmount = 0.obs;
  final rewards = <DailyRewardItem>[].obs;

  // FIX: make claimableReward observable so UI always reads latest value
  final _claimableReward = Rxn<DailyRewardItem>();
  DailyRewardItem? get claimableReward => _claimableReward.value;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 100), () {
      checkDailyReward();
    });
  }

  Future<void> checkDailyReward() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse(AppConstants.getDailyReward),
        headers: _api.authHeaders,
      );

      debugPrint("📥 Daily Reward Check Response: ${response.body}");

      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        final model = DailyRewardModel.fromJson(data);
        rewards.value = model.rewards;
        // FIX: assign to observable
        _claimableReward.value = model.claimableReward;

        if (_claimableReward.value != null) {
          await Future.delayed(const Duration(milliseconds: 500));
          showOverlay.value = true;
        }
      }
    } catch (e) {
      debugPrint('Daily reward check error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> claimReward() async {
    if (isClaiming.value) return;
    isClaiming.value = true;

    // FIX: capture the amount BEFORE the API call from the claimable reward
    // This ensures new users also see the correct amount
    final amountToShow = _claimableReward.value?.amount ?? 0;

    try {
      final response = await http.post(
        Uri.parse(AppConstants.dailyReward),
        headers: _api.authHeaders,
      );

      debugPrint("📥 Daily Reward Claim Response: ${response.body}");

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        // FIX: use pre-captured amount so it's never 0
        claimedAmount.value = amountToShow;
        hasClaimed.value = true;
        // Refresh rewards list to update streak bar
        await _refreshRewards();
        // FIX: notify home balance controller to refresh
        _notifyBalanceRefresh();
      } else {
        // Already claimed — show panel but with 0 coins
        claimedAmount.value = 0;
        hasClaimed.value = true;
      }
    } catch (e) {
      debugPrint('Claim error: $e');
      // Even on error, show panel so user is not stuck on gift box
      claimedAmount.value = amountToShow;
      hasClaimed.value = true;
    } finally {
      isClaiming.value = false;
    }
  }

  Future<void> _refreshRewards() async {
    try {
      final response = await http.get(
        Uri.parse(AppConstants.getDailyReward),
        headers: _api.authHeaders,
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        final model = DailyRewardModel.fromJson(data);
        rewards.value = model.rewards;
        // FIX: also update claimableReward after refresh
        _claimableReward.value = model.claimableReward;
      }
    } catch (e) {
      debugPrint('Refresh rewards error: $e');
    }
  }

  void _notifyBalanceRefresh() {
    try {
      Get.find<ProfileController>().totalBalance();
      // Get.find<WalletController>().fetchUserBalance();
      debugPrint('✅ Reward claimed — update balance controller here');
    } catch (e) {
      debugPrint('Balance refresh error: $e');
    }
  }

  void dismissOverlay() {
    showOverlay.value = false;
    hasClaimed.value = false;
    claimedAmount.value = 0;
  }
}


// import 'dart:convert';
// import 'pa ckage:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:zic/features/screens/home/controller/profile_controller.dart';
// import 'package:zic/utils/app_constants/app_constants.dart';
// import 'package:zic/utils/models/dailyreward.dart';
// import 'package:zic/utils/services/base_api_services.dart';

// class DailyRewardController extends GetxController {
//   BaseApiService get _api => Get.find<BaseApiService>();

//   final isLoading = false.obs;
//   final isClaiming = false.obs;
//   final showOverlay = false.obs;
//   final hasClaimed = false.obs;
//   final claimedAmount = 0.obs;
//   final rewards = <DailyRewardItem>[].obs;

//   final _claimableReward = Rxn<DailyRewardItem>();
//   DailyRewardItem? get claimableReward => _claimableReward.value;

//   @override
//   void onInit() {
//     super.onInit();
//     Future.delayed(const Duration(milliseconds: 100), () {
//       checkDailyReward();
//     });
//   }

//   Future<void> checkDailyReward() async {
//     isLoading.value = true;
//     try {
//       final response = await http.get(
//         Uri.parse(AppConstants.getDailyReward),
//         headers: _api.authHeaders,
//       );

//       debugPrint("📥 Daily Reward Check Response: ${response.body}");

//       final data = jsonDecode(response.body);
//       if (data['success'] == true) {
//         final model = DailyRewardModel.fromJson(data);
//         rewards.value = model.rewards;
//         _claimableReward.value = model.claimableReward;

//         if (_claimableReward.value != null) {
//           await Future.delayed(const Duration(milliseconds: 500));
//           showOverlay.value = true;
//         }
//       }
//     } catch (e) {
//       debugPrint('Daily reward check error: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> claimReward() async {
//     if (isClaiming.value) return;
//     isClaiming.value = true;

//     final amountToShow = _claimableReward.value?.amount ?? 0;

//     try {
//       final response = await http.post(
//         Uri.parse(AppConstants.dailyReward),
//         headers: _api.authHeaders,
//       );

//       debugPrint("📥 Daily Reward Claim Response: ${response.body}");

//       final data = jsonDecode(response.body);

//       if (data['success'] == true) {
//         claimedAmount.value = amountToShow;
//         hasClaimed.value = true;
        
//         // Refresh rewards list
//         await _refreshRewards();
        
//         // 🔑 KEY FIX: Refresh user profile to update balance
//         await _refreshUserProfile();
        
//       } else {
//         claimedAmount.value = 0;
//         hasClaimed.value = true;
//       }
//     } catch (e) {
//       debugPrint('Claim error: $e');
//       claimedAmount.value = amountToShow;
//       hasClaimed.value = true;
//     } finally {
//       isClaiming.value = false;
//     }
//   }

//   Future<void> _refreshRewards() async {
//     try {
//       final response = await http.get(
//         Uri.parse(AppConstants.getDailyReward),
//         headers: _api.authHeaders,
//       );
//       final data = jsonDecode(response.body);
//       if (data['success'] == true) {
//         final model = DailyRewardModel.fromJson(data);
//         rewards.value = model.rewards;
//         _claimableReward.value = model.claimableReward;
//       }
//     } catch (e) {
//       debugPrint('Refresh rewards error: $e');
//     }
//   }

//   // 🔑 NEW METHOD: Refresh user profile to update balance
//   Future<void> _refreshUserProfile() async {
//     try {
//       // Check if ProfileController is registered
//       if (Get.isRegistered<ProfileController>()) {
//         final profileController = Get.find<ProfileController>();
//         await profileController.loadUserProfile();
//         debugPrint('✅ Profile refreshed after reward claim');
//       }
      
//       // Also refresh home controller if needed
//       if (Get.isRegistered<HomeController>()) {
//         final homeController = Get.find<HomeController>();
//         await homeController.loadHomeData();
//         debugPrint('✅ Home data refreshed after reward claim');
//       }
      
//     } catch (e) {
//       debugPrint('Error refreshing profile: $e');
//     }
//   }

//   void dismissOverlay() {
//     showOverlay.value = false;
//     hasClaimed.value = false;
//     claimedAmount.value = 0;
//   }
// }