import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/auth/auth_service.dart';
import '../../../models/User.dart';

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

  Future<int?> get currentUserId async {
    if (_user != null) return _user!.id; // Jika sudah login, langsung return ID user

    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("id"); // Jika user belum login, ambil dari SharedPreferences
  }

  Future<String?> get token async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<void> _loadUserFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("token");

  print("🔍 Token dari SharedPreferences: $token");

  if (token == null) {
    print("❌ Tidak ada token. User dianggap belum login.");
    return;
  }

  _user = User(
    id: prefs.getInt("id") ?? 0,
    username: prefs.getString("username") ?? "",
    email: prefs.getString("email") ?? "",
    phoneNumber: prefs.getString("phone_number") ?? "",
    type: prefs.getInt("type") ?? 0,
  );

  print("✅ User berhasil dimuat dari SharedPreferences: ID=${_user?.id}, Username=${_user?.username}");

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
    if (userData == null) {
      _errorMessage = "Gagal mendapatkan data user.";
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final token = response["token"];
    final refreshToken = response["refresh_token"];

    if (token == null || refreshToken == null) {
      _errorMessage = "Token tidak valid.";
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

    if (_user!.blockedUntil != null) {
      final now = DateTime.now();
      if (_user!.blockedUntil!.isAfter(now)) {
        _errorMessage =
            "Akun Anda diblokir hingga ${_user!.blockedUntil!.toLocal()}. Silakan coba lagi nanti.";
        _user = null;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("id", _user!.id);
    await prefs.setString("username", _user!.username);
    await prefs.setString("email", _user!.email);
    await prefs.setString("phone_number", _user!.phoneNumber);
    await prefs.setInt("type", _user!.type);
    await prefs.setString("token", token);
    await prefs.setString("refresh_token", refreshToken);

    // ✅ Update token ke header service
    _authService.updateAuthorizationHeader(token);

    print("✅ User ID tersimpan: ${prefs.getInt("id")}");
    print("✅ Token tersimpan: ${prefs.getString("token")}");
    print("✅ Refresh Token tersimpan: ${prefs.getString("refresh_token")}");

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
  bool onboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;

  bool success = await prefs.clear();
  if (!success) {
    print("❌ Gagal menghapus data SharedPreferences");
  }

  await prefs.setBool('onboardingCompleted', onboardingCompleted);

  _user = null;
  _errorMessage = null;
  _isLoading = false;
  notifyListeners();
}


Future<bool> refreshUser() async {
  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString("token");
  String? refreshToken = prefs.getString("refresh_token");

  if (token != null && token.isNotEmpty) {
    print("✅ Token masih berlaku, tidak perlu refresh.");
    return true;
  }

  if (refreshToken == null || refreshToken.isEmpty) {
    print("❌ Token dan Refresh Token tidak ditemukan, user harus login ulang.");
    await logout();
    return false;
  }

  print("🔄 Token kosong, mencoba refresh token...");
  bool refreshed = await _authService.refreshToken(); // Pastikan fungsi ini return `bool`
  
  if (!refreshed) {
    print("❌ Refresh Token tidak valid, user harus login ulang.");
    await logout();
    return false;
  }

  token = prefs.getString("token");
  if (token == null || token.isEmpty) {
    print("❌ Gagal memperbarui token, user harus login ulang.");
    await logout();
    return false;
  }

  _authService.updateAuthorizationHeader(token);
  print("✅ Token berhasil diperbarui!");
  return true;
}





Future<void> setUserFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final id = prefs.getInt("id");
  if (id == null) return;

  _user = User(
    id: id,
    username: prefs.getString("username") ?? "",
    email: prefs.getString("email") ?? "",
    phoneNumber: prefs.getString("phone_number") ?? "",
    type: prefs.getInt("type") ?? 0,
  );

  print("🔁 User diset ulang di AuthProvider dari SharedPreferences: ID=${_user!.id}");
  notifyListeners();
}


  
}