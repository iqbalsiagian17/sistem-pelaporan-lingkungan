import 'package:flutter/material.dart';
import '../../core/services/user/password/user_password_service.dart';

class UserPasswordProvider with ChangeNotifier {
  final UserPasswordService _userPasswordService = UserPasswordService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ✅ UPDATE PASSWORD
  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    _isLoading = true;
    notifyListeners();

    final response = await _userPasswordService.changePassword(oldPassword, newPassword);

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
}
