import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spl_mobile/core/services/auth/auth_google_service.dart';
import '../../models/User.dart';

class AuthGoogleProvider with ChangeNotifier {
  final AuthGoogleService _googleService = AuthGoogleService();

  bool _isLoading = false;
  String? _errorMessage;
  User? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;
  bool get isLoggedIn => _user != null;

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

  final user = response["user"];
  _user = User.fromJson(user);

  if (_user!.type == 1) {
    _errorMessage = "Admin tidak bisa login lewat aplikasi mobile.";
    _user = null;
    _isLoading = false;
    notifyListeners();
    return false;
  }

  // ✅ Simpan status login ke SharedPreferences agar GoRouter bisa redirect otomatis
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool("isLoggedIn", true);

  _isLoading = false;
  notifyListeners();
  return true;
}


  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _user = null;
    notifyListeners();
  }
}
