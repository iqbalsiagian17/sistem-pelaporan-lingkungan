import 'package:flutter/material.dart';
import 'package:spl_mobile/core/services/user/profile/user_profile_service.dart';
import 'package:spl_mobile/models/User.dart';
import 'package:spl_mobile/core/services/auth/global_auth_service.dart';

class UserProfileProvider with ChangeNotifier {
  final UserProfileService _userProfileService = UserProfileService();

  bool _isLoading = false;
  String? _errorMessage;
  User? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;

  /// ✅ Hapus data user lokal
  void clearUserData() {
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// ✅ Ambil user dari backend dan simpan lokal
  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _userProfileService.getUserProfile();
      if (response.containsKey("data")) {
        _user = User.fromJson(response["data"]);

        // Simpan info dasar ke SharedPreferences
        await globalAuthService.saveUserInfo(response["data"]);

        _errorMessage = null;
      } else {
        _errorMessage = response["error"] ?? "Gagal memuat data user.";
      }
    } catch (e) {
      _errorMessage = "Terjadi kesalahan: $e";
    }

    _isLoading = false;
    notifyListeners();
  }

  /// ✅ Paksa refresh user
  Future<void> refreshUser() async {
    await loadUser();
  }

  /// ✅ Simpan perubahan profil
  Future<bool> saveUser(Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _userProfileService.updateUserProfile(data);

      if (response.containsKey("error")) {
        _errorMessage = response["error"];
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Sinkronkan data user di SharedPreferences
      await globalAuthService.saveUserInfo(data);
      await refreshUser();

      _isLoading = false;
      return true;
    } catch (e) {
      _errorMessage = "Gagal menyimpan data: $e";
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// ✅ Ganti password
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _userProfileService.changePassword(oldPassword, newPassword);

      if (response.containsKey("error")) {
        _errorMessage = response["error"];
        _isLoading = false;
        notifyListeners();
        return false;
      }

      await refreshUser();

      _isLoading = false;
      return true;
    } catch (e) {
      _errorMessage = "Gagal mengubah password: $e";
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
