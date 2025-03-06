import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/auth/auth_service.dart';
import '../../models/User.dart';

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
    _loadUserFromPrefs(); // ✅ Load user saat AuthProvider dibuat
  }

  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    
    if (token == null) return; // ✅ Jika token tidak ada, berarti user tidak login

    _user = User(
      id: prefs.getInt("id") ?? 0,
      username: prefs.getString("username") ?? "",
      email: prefs.getString("email") ?? "",
      phoneNumber: prefs.getString("phone_number") ?? "",
      type: prefs.getInt("type") ?? 0,
    );

    notifyListeners(); // ✅ Update UI setelah user dimuat
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

    _user = User.fromJson(response["user"]);
    if (_user!.type == 1) {
      _errorMessage = "Admin tidak dapat login ke aplikasi ini.";
      _user = null;
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", response["token"]);

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> register(String phone, String username, String email, String password) async {
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

    final prefs = await SharedPreferences.getInstance();

    // ✅ Preserve onboarding status while clearing user-related data
    bool onboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;

    await prefs.clear(); // ✅ Clear all user-related data
    await prefs.setBool('onboardingCompleted', onboardingCompleted); // ✅ Keep onboarding flag
    await prefs.setBool('isLoggedIn', false); // ✅ Ensure login status is false

    _user = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshUser() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("token");

  if (token == null) return;

  _user = User(
    id: prefs.getInt("id") ?? 0,
    username: prefs.getString("username") ?? "",
    email: prefs.getString("email") ?? "",
    phoneNumber: prefs.getString("phone_number") ?? "",
    type: prefs.getInt("type") ?? 0,
  );

  notifyListeners(); // ✅ Perbarui UI setelah refresh
}

  
}