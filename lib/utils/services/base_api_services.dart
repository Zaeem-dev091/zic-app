import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zic/utils/app_constants/app_constants.dart';

class BaseApiService extends GetxService {
  final token = ''.obs;
  final user = Rx<Map<String, dynamic>>({});

  Map<String, String> get authHeaders => {
    'Accept': 'application/json',
    if (token.value.isNotEmpty) 'Authorization': 'Bearer ${token.value}',
  };

  Map<String, String> get jsonHeaders => {
    ...authHeaders,
    'Content-Type': 'application/json',
  };

  Map<String, String> get formHeaders => {
    ...authHeaders,
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  // ── Local Storage ──

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    token.value = prefs.getString(AppConstants.tokenKey) ?? '';

    final raw = prefs.getString(AppConstants.userKey);
    if (raw != null) {
      user.value = json.decode(raw);
    }
  }

  Future<void> saveUserData(
    String newToken,
    Map<String, dynamic> userData,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(AppConstants.tokenKey, newToken);
    token.value = newToken;

    await persistUser(userData);
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.userKey);

    token.value = '';
    user.value = {};
  }

  Future<void> persistUser(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userKey, json.encode(userData));

    user.value = Map<String, dynamic>.from(userData);
  }

  Map<String, dynamic> decode(String body) {
    if (body.isEmpty) return {};
    try {
      return json.decode(body);
    } catch (_) {
      return {};
    }
  }
}
