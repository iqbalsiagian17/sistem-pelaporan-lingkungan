import 'package:flutter/material.dart';
import '../core/services/public/parameter_service.dart';
import '../models/Parameter.dart';

class ParameterProvider with ChangeNotifier {
  final ParameterService _parameterService = ParameterService();
  ParameterItem? _parameter;
  bool _isLoading = false;
  String? _errorMessage;

  ParameterItem? get parameter => _parameter;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchParameter() async {
    _isLoading = true;
    notifyListeners();

    try {
      _parameter = await _parameterService.fetchParameter();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
