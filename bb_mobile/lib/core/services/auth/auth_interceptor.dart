import 'package:dio/dio.dart';
import 'package:bb_mobile/core/services/auth/global_auth_service.dart';
import 'package:bb_mobile/core/utils/logout_helper.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;

  AuthInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await globalAuthService.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }
    return handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await globalAuthService.getRefreshToken();
      if (refreshToken == null) {
        _handleLogout();
        return handler.next(err);
      }

      try {
        final refreshResponse = await dio.post(
          "/api/auth/refresh-token",
          data: {"refresh_token": refreshToken},
        );

        final newAccessToken = refreshResponse.data["access_token"];
        final newRefreshToken = refreshResponse.data["refresh_token"] ?? refreshToken;

        await globalAuthService.saveToken(newAccessToken, newRefreshToken);

        // Clone original request
        final cloneReq = err.requestOptions;
        cloneReq.headers["Authorization"] = "Bearer $newAccessToken";

        final retryResponse = await dio.fetch(cloneReq);
        return handler.resolve(retryResponse);
      } catch (e) {
        await globalAuthService.clearAuthData();
        _handleLogout();
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  void _handleLogout() {
    final context = globalAuthService.navigatorKey.currentContext;
    if (context != null) {
      GlobalLogoutHelper.forceLogoutAndShowModal(context);
    } else {
      print("⚠️ Logout modal gagal ditampilkan karena context null");
      // Tambahkan tindakan lain jika perlu (misalnya log ke analytics)
    }
  }
}
