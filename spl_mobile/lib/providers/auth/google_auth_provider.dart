import 'package:flutter/material.dart';
import 'package:spl_mobile/core/services/auth/auth_google_service.dart';

class AuthGoogleProvider with ChangeNotifier {
  final AuthGoogleService _googleService = AuthGoogleService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> loginWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _googleService.loginWithGoogle();

    if (result.containsKey("error")) {
      _errorMessage = result["error"];
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> logoutFromGoogle() async {
    _isLoading = true;
    notifyListeners();

    await _googleService.logoutFromGoogle();

    _isLoading = false;
    notifyListeners();
  }
}
