import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/api.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.authBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  AuthService() {
    _dio.interceptors.clear(); // Pastikan tidak ada interceptor ganda
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString("token");

        if (token != null && token.isNotEmpty) {
          options.headers["Authorization"] = "Bearer $token";
          print("✅ Menambahkan token ke header: $token");
        }
        return handler.next(options);
      },
      onError: (DioError error, handler) async {
        if (error.response?.statusCode == 401) {
          print("⚠️ TOKEN EXPIRED! Mencoba refresh token...");

          bool refreshed = await refreshToken();
          if (refreshed) {
            return handler.resolve(await _retryRequest(error.requestOptions));
          }
        }
        return handler.next(error);
      }
    ));
  }

  void updateAuthorizationHeader(String token) {
  _dio.options.headers["Authorization"] = "Bearer $token";
}


Future<Response> _retryRequest(RequestOptions requestOptions) async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString("token");

    if (accessToken != null) {
      requestOptions.headers["Authorization"] = "Bearer $accessToken";
    }

    try {
      return await _dio.request(
        requestOptions.path,
        options: Options(
          method: requestOptions.method,
          headers: requestOptions.headers,
        ),
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
      );
    } catch (e) {
      print("❌ Gagal mengulang request: $e");
      rethrow;
    }
  }



 Future<bool> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString("refresh_token");

    if (refreshToken == null) {
      print("❌ Tidak ada refresh token, user harus login ulang.");
      await logout();
      return false;
    }

    print("🔄 [AuthService] Mencoba refresh token...");

  try {
    final response = await _dio.post(
      "/refresh-token",
      data: {"refresh_token": refreshToken},  // ✅ Pastikan refresh token dikirim di body request
      options: Options(
        headers: {
          "Content-Type": "application/json",  // ✅ Pastikan backend menerima JSON
        },
      ),
    );

      if (response.statusCode == 200 && response.data["access_token"] != null) {
        String newAccessToken = response.data["access_token"];
        await prefs.setString("token", newAccessToken);

        updateAuthorizationHeader(newAccessToken); // ✅ Update header di Dio
        _dio.options.headers["Authorization"] = "Bearer $newAccessToken";
        print("✅ Token berhasil diperbarui.");
        return true;
      }
    } catch (e) {
      print("❌ Gagal memperbarui token: $e");
    }

    await logout();
    return false;
  }








  // **✅ Login User dengan Identitas (Email/Phone) dan Client Type**
  Future<Map<String, dynamic>> login(String identifier, String password) async {
    try {
      final response = await _dio.post("/login", data: {
        "identifier": identifier,
        "password": password,
        "client": "flutter", // ✅ Kirim client type agar sesuai backend
      });

      final data = response.data;
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setString("token", data["token"]);
      await prefs.setString("refresh_token", data["refresh_token"]); // ✅ Simpan refresh token

      await prefs.setInt("user_id", data["user"]["id"]); // ✅ Simpan user_id
      await prefs.setString("username", data["user"]["username"]);
      await prefs.setString("email", data["user"]["email"]);
      await prefs.setString("phone_number", data["user"]["phone_number"]);
      await prefs.setInt("type", data["user"]["type"]);

      return data;
    } on DioException catch (e) {
      return {"error": _handleDioError(e)};
    }
  }

  // **✅ Register User**
  Future<Map<String, dynamic>> register(
      String phone, String username, String email, String password) async {
    try {
      final response = await _dio.post("/register", data: {
        "phone_number": phone,
        "username": username,
        "email": email,
        "password": password,
      });

      return response.data;
    } on DioException catch (e) {
      return {"error": _handleDioError(e)};
    }
  }

  // **✅ Logout User**
Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  bool onboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;

    await prefs.remove("token");
    await prefs.remove("refresh_token");
    _dio.options.headers.remove("Authorization");

  await prefs.clear();
  await prefs.setBool('onboardingCompleted', onboardingCompleted);

  // ❌ Pastikan Authorization dihapus dari semua request berikutnya
  _dio.options.headers.remove("Authorization");

  print("✅ Logout berhasil, semua data user dihapus.");
}


  // **✅ Check Login Status**
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") != null;
  }

  // **✅ Handle Error dari Dio**
String _handleDioError(DioException e) {
  if (e.response != null) {
    switch (e.response!.statusCode) {
      case 400:
        return "Permintaan tidak valid";
      case 401:
        return "Akses tidak sah, silakan login ulang";
      case 403:
        return "Anda tidak memiliki izin untuk mengakses sumber daya ini";
      case 404:
        return "Sumber daya tidak ditemukan";
      case 500:
        return "Terjadi kesalahan pada server, coba lagi nanti";
      default:
        return e.response!.data["message"] ?? "Terjadi kesalahan";
    }
  } else if (e.type == DioExceptionType.connectionTimeout) {
    return "Koneksi timeout, coba lagi nanti";
  } else if (e.type == DioExceptionType.receiveTimeout) {
    return "Server tidak merespons, coba lagi nanti";
  } else {
    return "Terjadi kesalahan jaringan";
  }
}
}
