import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spl_mobile/core/services/auth/auth_google_service.dart';
import '../../../models/User.dart';

class AuthGoogleProvider with ChangeNotifier {
  final AuthGoogleService _googleService = AuthGoogleService();

  bool _isLoading = false;
  String? _errorMessage;
  User? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;
  bool get isLoggedIn => _user != null;

  /// ✅ Login dengan Google
  Future<bool> loginWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _googleService.loginWithGoogle();

    if (response.containsKey("error")) {
      _errorMessage = response["error"];
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // ✅ Jangan parsing user sebelum yakin datanya valid
    if (!response.containsKey("user") || response["user"] == null) {
    _errorMessage = "Gagal mendapatkan data user.";
    _isLoading = false;
    notifyListeners();
    return false;
    }

    final user = response["user"];
    _user = User.fromJson(user);

    // ✅ Cegah admin login ke aplikasi mobile
    if (_user!.type == 1) {
      _errorMessage = "Admin tidak bisa login lewat aplikasi mobile.";
      _user = null;
      _isLoading = false;
      notifyListeners();
      return false;
    }

if (_user!.blockedUntil != null && _user!.blockedUntil!.isAfter(DateTime.now())) {
  _errorMessage =
      "Akun Anda diblokir hingga ${_user!.blockedUntil!.toLocal()}. Silakan coba lagi nanti.";
  _user = null;
  _isLoading = false;
  notifyListeners();
  return false;
}

    // ✅ Simpan data user ke SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("id", _user!.id); // Untuk AuthProvider
    await prefs.setInt("user_id", _user!.id); // Untuk filter laporan
    await prefs.setString("username", _user!.username);
    await prefs.setString("email", _user!.email);
    await prefs.setString("phone_number", _user!.phoneNumber);
    await prefs.setInt("type", _user!.type);
    await prefs.setBool("isLoggedIn", true);

    _isLoading = false;
    notifyListeners();
    return true;
  }

  /// ✅ Logout Google
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _user = null;
    notifyListeners();
  }
}
