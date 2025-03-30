import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spl_mobile/core/services/auth/auth_service.dart';
import 'package:spl_mobile/core/services/auth/global_auth_service.dart';
import 'package:spl_mobile/models/User.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  User? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;
  bool get isLoggedIn => _user != null;

  AuthProvider() {
    _loadUserFromPrefs();
  }

  Future<int?> get currentUserId async {
    if (_user != null) return _user!.id;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("user_id");
  }

  Future<String?> get token async {
    return await globalAuthService.getAccessToken();
  }

  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token == null) return;

    _user = User(
      id: prefs.getInt("user_id") ?? 0,
      username: prefs.getString("username") ?? "",
      email: prefs.getString("email") ?? "",
      phoneNumber: prefs.getString("phone_number") ?? "",
      type: prefs.getInt("type") ?? 0,
    );
    notifyListeners();
  }

  Future<bool> checkIsLoggedIn() async {
    await _loadUserFromPrefs();
    return _user != null;
  }

  Future<bool> login(String identifier, String password) async {
    _isLoading = true;
    _errorMessage = null;
    _user = null;
    notifyListeners();

    final response = await _authService.login(identifier, password);

    if (response.containsKey("error")) {
      _errorMessage = response["error"];
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final userData = response["user"];
    final token = response["token"];
    final refreshToken = response["refresh_token"];

    if (userData == null || token == null || refreshToken == null) {
      _errorMessage = "Data login tidak lengkap.";
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _user = User.fromJson(userData);

    if (_user!.type == 1) {
      _errorMessage = "Admin tidak dapat login ke aplikasi ini.";
      _user = null;
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (_user!.blockedUntil != null &&
        _user!.blockedUntil!.isAfter(DateTime.now())) {
      _errorMessage = "Akun diblokir hingga ${_user!.blockedUntil!.toLocal()}";
      _user = null;
      _isLoading = false;
      notifyListeners();
      return false;
    }

    await globalAuthService.saveToken(token, refreshToken);
    await globalAuthService.saveUserInfo(userData);

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> register(
      String phone, String username, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _authService.register(phone, username, email, password);
    if (response.containsKey("error")) {
      _errorMessage = response["error"];
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await globalAuthService.clearAuthData();
    _user = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> refreshUser() async {
    final token = await globalAuthService.getAccessToken();
    final refreshToken = await globalAuthService.getRefreshToken();

    if (token != null && token.isNotEmpty) return true;
    if (refreshToken == null || refreshToken.isEmpty) {
      await logout();
      return false;
    }

    bool refreshed = await _authService.refreshToken();
    if (!refreshed) {
      await logout();
      return false;
    }

    return true;
  }

  Future<void> setUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt("user_id");
    if (id == null) return;

    _user = User(
      id: id,
      username: prefs.getString("username") ?? "",
      email: prefs.getString("email") ?? "",
      phoneNumber: prefs.getString("phone_number") ?? "",
      type: prefs.getInt("type") ?? 0,
    );
    notifyListeners();
  }
}
