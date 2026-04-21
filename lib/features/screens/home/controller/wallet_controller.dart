import 'package:get/get.dart';
import 'package:zic/customization/widgets/feedback_style_snackbar.dart';
import 'package:zic/utils/models/wallet.dart';
import 'package:zic/utils/services/api_services.dart';

class WalletController extends GetxController {
  final ApiService _api = Get.find<ApiService>();

  // Loading states
  final isLoading = false.obs;
  final isTransferring = false.obs;
  final isLoadingHistory = false.obs;

  // Data
  final walletData = Rxn<WalletData>();
  final zicPoolData = Rxn<ZicPoolData>();
  final transferHistory = <TransferHistoryItem>[].obs;

  // Computed values
  String get formattedBalance {
    final balance = walletData.value?.totalBalance ?? 0.0;
    return '${balance.toStringAsFixed(2)} Z';
  }

  String get todayEarnings {
    final today = walletData.value?.todayZic ?? 0.0;
    return '${today.toStringAsFixed(2)} Z';
  }

  String get weeklyEarnings {
    final weekly = walletData.value?.weeklyZic ?? 0.0;
    return '${weekly.toStringAsFixed(2)} Z';
  }

  String get walletAddress {
    return zicPoolData.value?.walletAddress ?? '';
  }

  String get lioBalance {
    return zicPoolData.value?.formattedLio ?? '0.00 LIO';
  }

  // Combined transactions for UI
  List<UnifiedTransaction> get allTransactions {
    final List<UnifiedTransaction> transactions = [];

    // Add mining rewards
    if (walletData.value != null) {
      transactions.addAll(
        walletData.value!.dailyMiningReward.map((r) => MiningTransaction(r)),
      );
    }

    // Add transfer history
    transactions.addAll(transferHistory.map((t) => TransferTransaction(t)));

    // Sort by date (newest first)
    transactions.sort((a, b) => b.subtitle.compareTo(a.subtitle));

    return transactions;
  }

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
  }

  // ─────────────────────────────────────────────────────────────
  // FETCH ALL DATA
  // ─────────────────────────────────────────────────────────────

  Future<void> fetchAllData() async {
    isLoading.value = true;

    try {
      // Fetch all three endpoints in parallel
      final results = await Future.wait([
        _api.getWalletData(),
        _api.getZicPoolData(),
        _api.getTransferHistory(),
      ]);

      walletData.value = results[0] as WalletData?;
      zicPoolData.value = results[1] as ZicPoolData?;
      transferHistory.value = results[2] as List<TransferHistoryItem>;

      if (walletData.value == null) {
        showFeedbackStyleSnackbar(
          message: 'Failed to load wallet data',
          success: false,
        );
      }
    } catch (e) {
      print('❌ Error fetching wallet data: $e');
      showFeedbackStyleSnackbar(
        message: 'Network error occurred',
        success: false,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // TRANSFER COINS
  // ─────────────────────────────────────────────────────────────

  Future<bool> transferCoins(String amount, String address) async {
    // Validation
    if (amount.isEmpty) {
      _showError('Please enter an amount');
      return false;
    }

    final amountValue = double.tryParse(amount);
    if (amountValue == null || amountValue <= 0) {
      _showError('Please enter a valid amount');
      return false;
    }

    // Check LIO balance (not ZIC balance)
    if (zicPoolData.value != null && amountValue > zicPoolData.value!.lio) {
      _showError('Insufficient LIO balance');
      return false;
    }

    if (address.isEmpty) {
      _showError('Please enter a wallet address or username');
      return false;
    }

    isTransferring.value = true;

    try {
      final result = await _api.transferCoins(amount: amount, address: address);

      if (result != null && result.success) {
        showFeedbackStyleSnackbar(
          message: result.message,
          success: true,
          duration: const Duration(seconds: 3),
        );

        // Refresh all data
        await fetchAllData();
        return true;
      } else {
        _showError('Transfer failed. Please try again.');
        return false;
      }
    } catch (e) {
      print('❌ Transfer error: $e');
      _showError('Network error during transfer');
      return false;
    } finally {
      isTransferring.value = false;
    }
  }

  void _showError(String message) {
    showFeedbackStyleSnackbar(message: message, success: false);
  }

  // ─────────────────────────────────────────────────────────────
  // REFRESH
  // ─────────────────────────────────────────────────────────────

  Future<void> onRefresh() async {
    await fetchAllData();
  }

  // ─────────────────────────────────────────────────────────────
  // COPY ADDRESS
  // ─────────────────────────────────────────────────────────────

  void copyWalletAddress() {
    if (walletAddress.isNotEmpty) {
      showFeedbackStyleSnackbar(
        message: 'Wallet address copied to clipboard',
        success: true,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // ─────────────────────────────────────────────────────────────
  // CLEAR ON LOGOUT
  // ─────────────────────────────────────────────────────────────

  void clearData() {
    walletData.value = null;
    zicPoolData.value = null;
    transferHistory.clear();
  }
}
