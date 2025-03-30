import 'package:dio/dio.dart';
import '../constants/api.dart';
import '../services/auth/auth_interceptor.dart';

class DioClient {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  static Dio get instance => _dio;

  static Future<void> initialize() async {
    _dio.interceptors.clear();
    _dio.interceptors.add(AuthInterceptor(_dio));
  }
}
