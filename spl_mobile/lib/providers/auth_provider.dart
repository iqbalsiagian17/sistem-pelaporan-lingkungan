import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/user_profile_provider.dart'; // Impor UserProfileProvider
import '../../core/services/auth/auth_service.dart';
import '../../models/User.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserProfileProvider _userProfileProvider = UserProfileProvider();

  bool _isLoading = false;
  String? _errorMessage;
  User? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;
  bool get isLoggedIn => _user != null;

  // ✅ LOGIN USER DENGAN HANYA MENYIMPAN TOKEN
  Future<bool> login(String identifier, String password) async {
    _isLoading = true;
    notifyListeners();

    _user = null;
    _errorMessage = null;
    notifyListeners();

    final response = await _authService.login(identifier, password);
    if (response.containsKey("error")) {
      _errorMessage = response["error"];
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _user = User.fromJson(response["user"]);

    if (_user!.type == 1) {
      _errorMessage = "Admin tidak dapat login ke aplikasi ini.";
      _user = null;
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Simpan hanya token ke SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", response["token"]);

    _isLoading = false;
    notifyListeners();
    return true;
  }

  // ✅ REGISTER USER
  Future<bool> register(String phone, String username, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final response = await _authService.register(phone, username, email, password);
    if (response.containsKey("error")) {
      _errorMessage = response["error"];
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
    return true;
  }

  // ✅ LOGOUT DENGAN HANYA MENGHAPUS TOKEN
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    _userProfileProvider.clearUserData(); // ✅ Sekarang digunakan

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token"); // Hapus token agar login ulang
    await prefs.remove("user_data");

    _user = null;
    _errorMessage = null;
    _isLoading = false;

    // ✅ Hapus data user dari `UserProfileProvider`
    final userProfileProvider = UserProfileProvider();
    userProfileProvider.clearUserData();

    notifyListeners();
  }

}
