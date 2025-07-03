// core/services/parameter_service.dart
import 'package:dio/dio.dart';
import 'package:bb_mobile/features/parameter/data/models/parameter_model.dart';
import 'package:bb_mobile/core/constants/api.dart';

class ParameterService {
  static ParameterItem? _cached;

  static Future<ParameterItem> getParameter() async {
    if (_cached != null) return _cached!;
    final dio = Dio();
    final response = await dio.get(ApiConstants.publicParameter);
    if (response.statusCode == 200 && response.data['data'] != null) {
      _cached = ParameterItem.fromJson(response.data['data']);
      return _cached!;
    } else {
      throw Exception("Gagal mengambil parameter");
    }
  }
}
