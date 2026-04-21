import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zic/customization/widgets/feedback_style_snackbar.dart';
import 'package:zic/features/screens/home/controller/home_controller.dart';
import 'package:zic/utils/models/referrals.dart';
import 'package:zic/utils/services/api_services.dart';

class ReferralController extends GetxController {
  static ReferralController get to => Get.find();

  final RxString myReferralCode = ''.obs;
  final Rxn<ReferralStatusModel> referralStatus = Rxn<ReferralStatusModel>();
  final RxList<ReferralUserModel> referralUsers = <ReferralUserModel>[].obs;
  final RxSet<int> claimedMilestones = <int>{}.obs;
  final RxMap<int, bool> claimingMilestones = <int, bool>{}.obs;
  final RxBool isFetching = false.obs;

  Worker? _profileWorker;

  final ApiService _apiService = Get.find<ApiService>();
  HomeController get _home => Get.find<HomeController>();

  // ── Convenience getters ──
  int get totalReferrals => referralStatus.value?.totalReferrals ?? 0;
  List<TierModel> get tiers => referralStatus.value?.tiers ?? [];

  @override
  void onInit() {
    super.onInit();
    _loadCodeFromStoredUser();
    _profileWorker = ever<Map<String, dynamic>>(
      _apiService.user,
      (_) => _loadCodeFromStoredUser(),
    );
    fetchReferralStatus();
    fetchMyReferrals();
  }

  @override
  void onClose() {
    _profileWorker?.dispose();
    super.onClose();
  }

  // ────────────────────────────────────────────
  // GET /getreferrals
  // ────────────────────────────────────────────
  Future<void> fetchReferralStatus() async {
    isFetching.value = true;

    try {
      final result = await _apiService.getReferralStatus();

      if (result['success'] == true) {
        referralStatus.value = ReferralStatusModel.fromJson(result);

        claimedMilestones
          ..clear()
          ..addAll(tiers.where((t) => t.isClaimed).map((t) => t.tier));
      }
    } catch (e) {
      print('fetchReferralStatus error: $e');
    } finally {
      isFetching.value = false;
    }
  }

  // ────────────────────────────────────────────
  // GET /myreferrals
  // ────────────────────────────────────────────
  Future<void> fetchMyReferrals() async {
    try {
      final result = await _apiService.getMyReferrals();

      if (result['success'] == true) {
        final data = result['data'];

        // ✅ API returns array under "total_referrals" key
        final List rawList = data['total_referrals'] ?? [];

        referralUsers.value = rawList
            .map(
              (item) =>
                  ReferralUserModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      }
    } catch (e) {
      print('fetchMyReferrals error: $e');
    }
  }

  // ────────────────────────────────────────────
  // POST /claimreferral
  // ────────────────────────────────────────────
  Future<void> claimMilestoneReward({
    required int milestone,
    required int coins,
  }) async {
    if (claimingMilestones[milestone] == true) return;
    claimingMilestones[milestone] = true;

    try {
      final result = await _apiService.claimReferralReward(
        milestone: milestone,
      );

      final response = ClaimReferralResponseModel.fromJson(result);

      if (response.success) {
        // ✅ Use parsed balance from model
        _home.setWalletBalance(response.balance);

        claimedMilestones.add(milestone);

        showFeedbackStyleSnackbar(
          message: response.message.isNotEmpty
              ? response.message
              : '$coins ZIC added to your wallet',
          success: true,
          position: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );

        // Refresh to sync latest state from server
        await fetchReferralStatus();
      } else {
        showFeedbackStyleSnackbar(
          message: response.message.isNotEmpty
              ? response.message
              : 'Unable to claim reward',
          success: false,
          position: SnackPosition.TOP,
        );
      }
    } catch (e) {
      showFeedbackStyleSnackbar(
        message: 'An error occurred: $e',
        success: false,
      );
    } finally {
      claimingMilestones[milestone] = false;
    }
  }

  // ────────────────────────────────────────────
  // Invite / share
  // ────────────────────────────────────────────
  String _referralLink(String code) => 'https://zicapp.com/register?ref=$code';

  void invite(String code) {
    if (code.isEmpty) {
      showFeedbackStyleSnackbar(
        message: 'Referral code not available',
        success: false,
      );
      return;
    }
    Share.share(
      'Join ZicApp and earn rewards!\n\n${_referralLink(code)}',
      subject: 'ZicApp Invitation',
    );
  }

  Future<void> copyCode() async {
    final code = myReferralCode.value.trim();
    if (code.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: _referralLink(code)));
    showFeedbackStyleSnackbar(
      message: 'Referral link copied to clipboard',
      success: true,
    );
  }

  // ────────────────────────────────────────────
  // Pull-to-refresh
  // ────────────────────────────────────────────
  @override
  Future<void> refresh() async {
    await Future.wait([fetchReferralStatus(), fetchMyReferrals()]);
  }

  // ────────────────────────────────────────────
  // State helpers
  // ────────────────────────────────────────────
  bool isClaimed(int milestone) => claimedMilestones.contains(milestone);
  bool isClaiming(int milestone) => claimingMilestones[milestone] == true;

  void _loadCodeFromStoredUser() {
    final user = _apiService.user.value;
    final code =
        (user['referral_no'] ??
                user['referral_code'] ??
                user['referralCode'] ??
                user['code'])
            ?.toString()
            .trim() ??
        '';
    myReferralCode.value = code;
  }
}
