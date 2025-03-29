// lib/core/utils/dio_client.dart
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth/auth_service.dart';
import '../constants/api.dart';

class DioClient {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  static Dio get instance => _dio;

  static Future<void> initialize() async {
    _dio.interceptors.clear();
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString("token");

        if (token != null && token.isNotEmpty) {
          options.headers["Authorization"] = "Bearer $token";
        }

        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401) {
          print("🔁 Token kadaluarsa, mencoba refresh...");

          final refreshed = await AuthService().refreshToken();
          if (refreshed) {
            final prefs = await SharedPreferences.getInstance();
            final newToken = prefs.getString("token");
            if (newToken != null) {
              error.requestOptions.headers["Authorization"] = "Bearer $newToken";
              final cloneReq = await _dio.fetch(error.requestOptions);
              return handler.resolve(cloneReq);
            }
          }

          print("❌ Gagal refresh token, harus login ulang.");
        }

        return handler.next(error);
      },
    ));
  }
}
