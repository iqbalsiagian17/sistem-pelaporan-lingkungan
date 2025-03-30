import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spl_mobile/core/services/auth/auth_service.dart';

class GlobalAuthService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") !=null;
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

  await prefs.setInt("user_id", user["id"] ?? 0);
  await prefs.setString("username", user["username"] ?? "");
  await prefs.setString("email", user["email"] ?? "");
  await prefs.setString("phone_number", user["phone_number"] ?? "");
  await prefs.setInt("type", user["type"] ?? 0);

  // Jika kamu menyimpan provider Google/manual:
  if (user.containsKey("auth_provider")) {
    await prefs.setString("auth_provider", user["auth_provider"]);
  }
}

  Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    bool onboardingCompleted = prefs.getBool("onboardingCompleted") ?? false;
    await prefs.clear();
    await prefs.setBool("onboardingCompleted", onboardingCompleted);
  }

  Future<bool> refreshToken() async {
    return await AuthService().refreshToken();
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("user_id");
}
}

final globalAuthService = GlobalAuthService();
