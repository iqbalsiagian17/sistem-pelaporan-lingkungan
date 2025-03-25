import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;

  AuthInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token != null) {
      options.headers["Authorization"] = "Bearer $token";
    }

    return handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString("refresh_token");

      if (refreshToken != null) {
        try {
          // Refresh token
          final refreshResponse = await dio.post("/refresh-token", data: {
            "refresh_token": refreshToken,
          });

          final newAccessToken = refreshResponse.data["access_token"];
          final newRefreshToken = refreshResponse.data["refresh_token"];

          // Simpan token baru
          await prefs.setString("token", newAccessToken);
          await prefs.setString("refresh_token", newRefreshToken);

          // Ulangi request asli dengan token baru
          final options = err.requestOptions;
          options.headers["Authorization"] = "Bearer $newAccessToken";

          final clonedResponse = await dio.fetch(options);
          return handler.resolve(clonedResponse);
        } catch (e) {
          return handler.reject(err);
        }
      }
    }

    return handler.next(err);
  }
}
