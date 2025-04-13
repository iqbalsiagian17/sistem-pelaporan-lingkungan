import 'package:bb_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalAuthService {
  int? _cachedUserId;

  /// Getter yang aman digunakan setelah `init()` dipanggil
  int? get userId => _cachedUserId;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Wajib dipanggil di awal aplikasi, misal di splash/onboarding
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _cachedUserId = prefs.getInt("user_id");
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") != null;
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("refresh_token");
  }

  Future<void> saveToken(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", accessToken);
    await prefs.setString("refresh_token", refreshToken);
  }

  Future<void> saveUserInfo(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    final id = user["id"] ?? 0;

    await prefs.setInt("user_id", id);
    _cachedUserId = id;

    await prefs.setString("username", user["username"] ?? "");
    await prefs.setString("email", user["email"] ?? "");
    await prefs.setString("phone_number", user["phone_number"] ?? "");
    await prefs.setInt("type", user["type"] ?? 0);

    if (user.containsKey("auth_provider")) {
      await prefs.setString("auth_provider", user["auth_provider"]);
    }
  }

  Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingCompleted = prefs.getBool("onboardingCompleted") ?? false;
    await prefs.clear();
    await prefs.setBool("onboardingCompleted", onboardingCompleted);
    _cachedUserId = null;
  }

  Future<int?> getUserId() async {
    if (_cachedUserId != null) return _cachedUserId;
    final prefs = await SharedPreferences.getInstance();
    _cachedUserId = prefs.getInt("user_id");
    return _cachedUserId;
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("username");
  }

  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("email");
  }

  Future<String?> getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("phone_number");
  }

  Future<int?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("type");
  }

  Future<String?> getAuthProvider() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_provider");
  }

  Future<bool> refreshToken() async {
    return await AuthRemoteDataSourceImpl(Dio()).refreshToken();
  }
}

/// Global singleton (kalau tidak pakai Riverpod)
final globalAuthService = GlobalAuthService();
