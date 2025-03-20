import 'package:dio/dio.dart';
import 'package:spl_mobile/core/constants/api.dart';

class PostLikeService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.userPostLike,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  /// 🔹 Mengecek apakah post sudah di-like oleh pengguna
  Future<bool> isLiked(int postId, String token) async {
    try {
      final response = await _dio.get(
        "/$postId/status",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 && response.data.containsKey('isLiked')) {
        return response.data['isLiked'] == true;
      }
      return false;
    } catch (e) {
      print("❌ [isLiked] Error: $e");
      return false;
    }
  }

  /// 🔹 Mengambil jumlah likes dari post
/// 🔹 Mengambil jumlah likes dari post
/// 🔹 Mengambil jumlah likes dari post
Future<int> getLikeCount(int postId, String token) async {
  try {
    final response = await _dio.get(
      "/$postId", // ✅ Panggil endpoint yang benar
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    print("📥 Response API getLikeCount: ${response.data}"); // Debugging

    if (response.statusCode == 200 && response.data.containsKey('likes')) {
      return response.data['likes'] ?? 0; // ✅ Ambil jumlah like
    } else {
      print("❌ [getLikeCount] Struktur response tidak sesuai: ${response.data}");
    }
    return 0;
  } catch (e) {
    print("❌ [getLikeCount] Error: $e");
    return 0;
  }
}



  /// 🔹 Menyukai post
  Future<bool> likePost(int postId, String token) async {
    try {
      final response = await _dio.post(
        "/$postId/like",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      return response.statusCode == 201;
    } catch (e) {
      print("❌ [likePost] Error: $e");
      return false;
    }
  }

  /// 🔹 Menghapus like dari post
  Future<bool> unlikePost(int postId, String token) async {
    try {
      final response = await _dio.delete(
        "/$postId/unlike",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("❌ [unlikePost] Error: $e");
      return false;
    }
  }
}
