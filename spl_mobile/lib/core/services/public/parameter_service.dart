import 'package:dio/dio.dart';
import 'package:spl_mobile/core/constants/api.dart';
import 'package:spl_mobile/models/Parameter.dart';

class ParameterService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.publicParameter, // <- baseUrl ini sudah langsung ke endpoint
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<ParameterItem> fetchParameter() async {
    try {
      final response = await _dio.get("");

      if (response.statusCode == 200 && response.data['data'] != null) {
        return ParameterItem.fromJson(response.data['data']);
      } else {
        throw Exception("Gagal mengambil data parameter.");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan: $e");
    }
  }
}
