import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/services/user/profile/user_profile_service.dart';
import '../../models/UserInfo.dart';

class UserProfileProvider with ChangeNotifier {
  final UserProfileService _userProfileService = UserProfileService();

  bool _isLoading = false;
  String? _errorMessage;
  UserInfo? _userInfo;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserInfo? get userInfo => _userInfo;

  void clearUserData() {
    _userInfo = null;
    _errorMessage = null;
    notifyListeners();
  }

  // ✅ AMBIL USER INFO TANPA `SharedPreferences`
Future<void> loadUserInfo() async {
  try {
    final response = await _userProfileService.getUserProfile();
    debugPrint("📢 API Response: $response"); // ✅ Debug API response

    if (response.containsKey("data")) {
      // ✅ Pastikan `userInfo` bisa `null` tanpa menyebabkan error
      final userInfoData = response["data"]["userInfo"];
      _userInfo = userInfoData != null ? UserInfo.fromJson(userInfoData) : null;
      notifyListeners();
    } else {
      throw Exception("Gagal mengambil data profil.");
    }
  } catch (e) {
    debugPrint("❌ Error saat mengambil user info: $e");
  }
}



  // ✅ SIMPAN / UPDATE USER INFO
  Future<bool> saveUserInfo(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = userInfo == null
          ? await _userProfileService.createUserProfile(data)
          : await _userProfileService.updateUserProfile(data);

      if (response.containsKey("error")) {
        throw Exception(response["error"]);
      }

      await loadUserInfo();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      debugPrint("❌ Error saat menyimpan profil: $_errorMessage");
      return false;
    }
  }

  // ✅ UPDATE FOTO PROFIL TANPA `SharedPreferences`
  Future<bool> updateProfilePicture(File imageFile) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_userInfo == null) throw Exception("User tidak ditemukan");

      debugPrint("📤 Mengunggah foto profil...");

      final response = await _userProfileService.uploadProfilePicture(imageFile);
      debugPrint("✅ Respons API: $response");

      if (response.containsKey("error")) {
        throw Exception(response["error"]);
      }

      final String newProfilePicture = response["profile_picture"] != null
          ? "${response["profile_picture"]}?timestamp=${DateTime.now().millisecondsSinceEpoch}"
          : "";

      _userInfo = _userInfo!.copyWith(profilePicture: newProfilePicture);
      await loadUserInfo(); // ✅ Pastikan UI diperbarui setelah upload foto

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      _errorMessage = error.toString();
      notifyListeners();
      debugPrint("❌ Error saat mengupdate foto profil: $_errorMessage");
      return false;
    }
  }


}
