import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/user/profile/user_profile_service.dart';
import '../../models/User.dart'; // ✅ Gunakan model User

class UserProfileProvider with ChangeNotifier {
  final UserProfileService _userProfileService = UserProfileService();

  bool _isLoading = false;
  String? _errorMessage;
  User? _user; // ✅ Simpan user langsung dari API

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user; // ✅ Ambil user dari backend

  void clearUserData() {
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  // ✅ Ambil User dari Backend
  Future<void> loadUser() async {
    try {
      final response = await _userProfileService.getUserProfile();
      if (response.containsKey("data")) {
        _user = User.fromJson(response["data"]);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("username", _user!.username);
        await prefs.setString("email", _user!.email);
        await prefs.setString("phone_number", _user!.phoneNumber);

        notifyListeners();
      }
    } catch (e) {
      debugPrint("❌ Error loading user: $e");
    }
  }

  // ✅ Paksa refresh user data dan update UI
  Future<void> refreshUser() async {
    await loadUser();
    Future.microtask(() {
      notifyListeners();
    });
  }

  // ✅ Simpan / Update User
  Future<bool> saveUser(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _userProfileService.updateUserProfile(data);

      if (response.containsKey("error")) {
        throw Exception(response["error"]);
      }

      // ✅ Perbarui SharedPreferences agar sinkron dengan server
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("username", data["username"] ?? "");
      await prefs.setString("email", data["email"] ?? "");
      await prefs.setString("phone_number", data["phone_number"] ?? "");

      await refreshUser(); // ✅ Ambil data terbaru setelah update
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = "❌ Error menyimpan data user: $e";
      notifyListeners();
      debugPrint(_errorMessage);
      return false;
    }
  }

  // ✅ Ubah Password
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint("🔄 Mengubah password...");

      final response = await _userProfileService.changePassword(oldPassword, newPassword);
      debugPrint("✅ Respons API: $response");

      if (response.containsKey("error")) {
        throw Exception(response["error"]);
      }

      // 🔥 Pastikan data user diperbarui setelah password berubah
      await refreshUser();
      debugPrint("✅ User data berhasil diperbarui setelah perubahan password");

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = "❌ Error saat mengubah password: $e";
      notifyListeners();
      debugPrint(_errorMessage);
      return false;
    }
  }
}
