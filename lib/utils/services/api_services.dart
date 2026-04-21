import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zic/utils/app_constants/app_constants.dart';
import 'package:zic/utils/models/mine.dart';
import 'package:zic/utils/models/profile.dart';
import 'package:zic/utils/models/spinwheel.dart';
import 'package:zic/utils/models/wallet.dart';
import 'package:zic/utils/services/base_api_services.dart';

class ApiService extends BaseApiService {
  // ────────────────────────────────────────────
  // AUTH
  // ────────────────────────────────────────────

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? referralCode,
  }) async {
    try {
      final body = {'name': name, 'email': email, 'password': password};

      if (referralCode != null && referralCode.trim().isNotEmpty) {
        body['referral_code'] = referralCode.trim();
      }

      final res = await http.post(
        Uri.parse(AppConstants.signup),
        headers: formHeaders,
        body: body,
      );

      final data = decode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        final newToken = data['token'] ?? data['data']?['token'];

        if (newToken != null) {
          await saveUserData(newToken, data['user'] ?? data['data'] ?? {});
        }

        return {'success': true};
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Registration failed',
      };
    } catch (e) {
      return {'success': false, 'message': 'Network error'};
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse(AppConstants.signin),
        headers: formHeaders,
        body: {'email': email, 'password': password},
      );

      final data = decode(res.body);

      if (res.statusCode == 200) {
        final newToken = data['token'] ?? data['data']?['token'];

        if (newToken != null) {
          await saveUserData(newToken, data['user'] ?? data['data'] ?? {});
        }

        return {'success': true};
      }

      return {'success': false, 'message': data['message'] ?? 'Login failed'};
    } catch (e) {
      return {'success': false, 'message': 'Network error'};
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      if (token.value.isNotEmpty) {
        await http.post(Uri.parse(AppConstants.logout), headers: authHeaders);
      }
    } finally {
      await clearUserData();
    }

    return {'success': true};
  }

  // GET - called on app load
  Future<ProfileModel?> getProfile() async {
    try {
      final res = await http.get(
        Uri.parse(AppConstants.profile),
        headers: authHeaders,
      );

      final data = decode(res.body);

      if (res.statusCode == 200 && data['success'] == true) {
        return ProfileModel.fromJson(data['data']);
      }
      return null;
    } catch (e) {
      print('getProfile error: $e');
      return null;
    }
  }

  // POST - called when user taps start mining button
  Future<MiningModel?> startMining() async {
    try {
      final res = await http.post(
        Uri.parse(AppConstants.mine),
        headers: authHeaders,
      );

      final data = decode(res.body);

      if (res.statusCode == 200 && data['success'] == true) {
        return MiningModel.fromJson(data);
      }
      return null;
    } catch (e) {
      print('startMining error: $e');
      return null;
    }
  }

  // ────────────────────────────────────────────
  // REWARDS
  // ────────────────────────────────────────────

  Future<Map<String, dynamic>> claimDailyReward() async {
    try {
      final res = await http.post(
        Uri.parse(AppConstants.dailyReward),
        headers: authHeaders,
      );

      final data = decode(res.body);

      return {
        'success': res.statusCode == 200 || res.statusCode == 201,
        'data': data,
        'message': data['message'],
      };
    } catch (e) {
      print('claimDailyReward error: $e');
      return {'success': false, 'message': 'Network error'};
    }
  }

  Future<Map<String, dynamic>> getWeekendRewardStatus() async {
    try {
      final res = await http.get(
        Uri.parse(AppConstants.weeklyReward),
        headers: authHeaders,
      );

      return {
        'success': res.statusCode == 200 || res.statusCode == 201,
        'data': decode(res.body),
      };
    } catch (_) {
      return {'success': false};
    }
  }

  Future<Map<String, dynamic>> claimWeekendReward() async {
    try {
      final res = await http.post(
        Uri.parse(AppConstants.weeklyReward),
        headers: jsonHeaders,
      );

      return {
        'success': res.statusCode == 200 || res.statusCode == 201,
        'data': decode(res.body),
      };
    } catch (_) {
      return {'success': false};
    }
  }

  // ────────────────────────────────────────────
  // STREAK
  // ────────────────────────────────────────────

  Future<Map<String, dynamic>> getStreakStatus() async {
    try {
      final res = await http.get(
        Uri.parse(AppConstants.getStreakStatus), // GET /getdays
        headers: authHeaders,
      );

      final data = decode(res.body);
      return {
        'success': res.statusCode == 200 && data['success'] == true,
        ...data,
      };
    } catch (e) {
      print('getStreakStatus error: $e');
      return {'success': false};
    }
  }

  Future<Map<String, dynamic>> claimStreakReward(int days) async {
    try {
      final res = await http.post(
        Uri.parse(AppConstants.streakReward), // POST /claimstreakreward
        headers: formHeaders,
        // ✅ sends days=5 as form-data (matches your Postman)
        body: 'days=$days',
      );

      final data = decode(res.body);
      return {
        'success': res.statusCode == 200 && data['success'] == true,
        ...data,
      };
    } catch (e) {
      print('claimStreakReward error: $e');
      return {'success': false};
    }
  }

  // ────────────────────────────────────────────
  // LEVELS
  // ────────────────────────────────────────────

  Future<Map<String, dynamic>> getUserLevels() async {
    try {
      final res = await http.get(
        Uri.parse(AppConstants.userLevel),
        headers: authHeaders,
      );

      print("Levels API Response Status: ${res.statusCode}");
      print("Levels API Response Body: ${res.body}");

      final data = decode(res.body);

      return {
        'success': res.statusCode == 200 && data['success'] == true,
        ...data,
      };
    } catch (e) {
      print("Error fetching user levels: $e");
      return {'success': false, 'message': 'Failed to fetch levels: $e'};
    }
  }

  // utils/services/api_services.dart

  Future<Map<String, dynamic>> claimLevelReward(int levelNo) async {
    try {
      print("🔵 Claiming reward for level: $levelNo");

      final res = await http.post(
        Uri.parse(AppConstants.levelReward),
        headers: formHeaders,
        body: 'level_no=$levelNo',
      );

      print("📦 Claim Response: ${res.body}");

      final data = decode(res.body);

      return {
        'success': res.statusCode == 200 && data['success'] == true,
        ...data,
      };
    } catch (e) {
      print("Error claiming level reward: $e");
      return {'success': false, 'message': 'Failed to claim reward'};
    }
  }

  // ─────────────────────────────────────────────────────────────
  // WALLET ENDPOINTS
  // ─────────────────────────────────────────────────────────────

  Future<WalletData?> getWalletData() async {
    try {
      final res = await http.get(
        Uri.parse(AppConstants.wallet),
        headers: authHeaders,
      );

      print("📥 Wallet API Response: ${res.body}");

      final data = decode(res.body);

      if (res.statusCode == 200 && data['status'] == true) {
        return WalletData.fromJson(data);
      }
      return null;
    } catch (e) {
      print('❌ getWalletData error: $e');
      return null;
    }
  }

  // GET - Fetch ZicPool data (LIO balance + wallet address)
  Future<ZicPoolData?> getZicPoolData() async {
    try {
      final res = await http.get(
        Uri.parse(AppConstants.zicPool),
        headers: authHeaders,
      );

      print("📥 ZicPool API Response: ${res.body}");

      final data = decode(res.body);

      if (res.statusCode == 200 &&
          data['success'] == true &&
          data['data'] != null) {
        return ZicPoolData.fromJson(data['data']);
      }
      return null;
    } catch (e) {
      print('❌ getZicPoolData error: $e');
      return null;
    }
  }

  // POST - Transfer coins to another user
  Future<TransferResult?> transferCoins({
    required String amount,
    required String address,
  }) async {
    try {
      print("💸 Transfer Request - Amount: $amount, Address: $address");

      final res = await http.post(
        Uri.parse(AppConstants.coinTransfer),
        headers: jsonHeaders,
        body: jsonEncode({'amount': amount, 'receiver_wallet': address}),
      );

      print("📥 Transfer Response: ${res.body}");

      final data = decode(res.body);

      if (res.statusCode == 200 && data['success'] == true) {
        return TransferResult.fromJson(data);
      }
      return null;
    } catch (e) {
      print('❌ transferCoins error: $e');
      return null;
    }
  }

  // GET - Fetch transfer history
  Future<List<TransferHistoryItem>> getTransferHistory() async {
    try {
      // Note: You might need a new constant for this endpoint
      final transferHistoryUrl = '${AppConstants.baseUrl}/transferhistory';

      final res = await http.get(
        Uri.parse(transferHistoryUrl),
        headers: authHeaders,
      );

      print("📥 Transfer History Response: ${res.body}");

      final data = decode(res.body);

      if (res.statusCode == 200 &&
          data['success'] == true &&
          data['data'] != null) {
        final list = data['data'] as List;
        return list.map((item) => TransferHistoryItem.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('❌ getTransferHistory error: $e');
      return [];
    }
  }

  // ────────────────────────────────────────────
  // Get referral status (tiers + total referrals)
  // ────────────────────────────────────────────
  Future<Map<String, dynamic>> getReferralStatus() async {
    try {
      final res = await http.get(
        Uri.parse(AppConstants.getreferrals), // your endpoint
        headers: authHeaders,
      );

      return {'success': res.statusCode == 200, 'data': jsonDecode(res.body)};
    } catch (_) {
      return {'success': false};
    }
  }

  // ────────────────────────────────────────────
  // Claim a referral reward
  // ────────────────────────────────────────────
  Future<Map<String, dynamic>> claimReferralReward({
    required int milestone,
  }) async {
    try {
      final res = await http.post(
        Uri.parse(AppConstants.claimReferralReward),
        headers: authHeaders,
        body: jsonEncode({'tier': milestone}),
      );

      return {
        'success': res.statusCode == 200 || res.statusCode == 201,
        'data': jsonDecode(res.body),
      };
    } catch (_) {
      return {'success': false};
    }
  }

  // ────────────────────────────────────────────
  // Get my referral info (optional if needed)
  // ────────────────────────────────────────────
  Future<Map<String, dynamic>> getMyReferrals() async {
    try {
      final res = await http.get(
        Uri.parse(AppConstants.myReferrals),
        headers: authHeaders,
      );

      return {'success': res.statusCode == 200, 'data': jsonDecode(res.body)};
    } catch (_) {
      return {'success': false};
    }
  }

  // ─────────────────────────────────────────────────────────────
  // SPIN WHEEL ENDPOINTS
  // ─────────────────────────────────────────────────────────────
  Future<SpinRewardsData?> getSpinRewards() async {
    try {
      final res = await http.get(
        Uri.parse(AppConstants.spinwheelReward),
        headers: authHeaders,
      );

      print("📥 Spin Rewards Response: ${res.body}");

      final data = decode(res.body);

      if (res.statusCode == 200 && data['success'] == true) {
        return SpinRewardsData.fromJson(data);
      }
      return null;
    } catch (e) {
      print('❌ getSpinRewards error: $e');
      return null;
    }
  }

  // POST - Claim spin (backend decides reward)
  Future<SpinResult?> claimSpin() async {
    try {
      print("🎡 Claiming spin...");

      final res = await http.post(
        Uri.parse(AppConstants.spinWheel),
        headers: jsonHeaders,
      );

      print("📥 Spin Claim Response: ${res.body}");

      final data = decode(res.body);

      if (res.statusCode == 200 && data['success'] == true) {
        return SpinResult.fromJson(data);
      }
      return null;
    } catch (e) {
      print('❌ claimSpin error: $e');
      return null;
    }
  }

  // ────────────────────────────────────────────
  // FEEDBACK
  // ────────────────────────────────────────────

  Future<Map<String, dynamic>> submitFeedback({
    required String message,
    required int rating,
    required String category,
  }) async {
    try {
      final res = await http.post(
        Uri.parse(AppConstants.feedback),
        headers: jsonHeaders,
        body: jsonEncode({
          'description': message,
          'rating': rating,
          'category': category,
        }),
      );

      final data = decode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        return {'success': true, 'data': data};
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Failed to submit feedback',
      };
    } catch (e) {
      print('submitFeedback error: $e');
      return {'success': false, 'message': 'Network error'};
    }
  }
}
