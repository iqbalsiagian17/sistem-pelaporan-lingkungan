import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/api.dart'; // ✅ Gunakan base URL dari constants

class AuthService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.authBaseUrl, // ✅ Gunakan base URL yang sudah dideklarasikan
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ))..interceptors.add(LogInterceptor(responseBody: true, requestBody: true)); // ✅ Debugging

  AuthService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString("token");

        if (token != null) {
          options.headers["Authorization"] = "Bearer $token"; // ✅ Tambahkan token otomatis
        }
        return handler.next(options);
      },
    ));
  }

  // **✅ Login User (Bisa dengan Email atau Nomor Telepon)**
  Future<Map<String, dynamic>> login(String identifier, String password) async {
    try {
      final response = await _dio.post("/login", data: {
        "identifier": identifier,
        "password": password,
      });

      final data = response.data;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", data["token"]);

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
    await prefs.remove("token");
  }

  // **✅ Check Login Status**
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") != null;
  }

  // **✅ Handle Error dari Dio**
  String _handleDioError(DioException e) {
    if (e.response != null) {
      return e.response!.data["message"] ?? "Terjadi kesalahan";
    } else if (e.type == DioExceptionType.connectionTimeout) {
      return "Koneksi timeout, coba lagi nanti";
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return "Server tidak merespons, coba lagi nanti";
    } else {
      return "Terjadi kesalahan jaringan";
    }
  }
}
