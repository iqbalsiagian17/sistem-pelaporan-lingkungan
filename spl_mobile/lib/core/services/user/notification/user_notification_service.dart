import 'package:dio/dio.dart';
import 'package:spl_mobile/core/constants/api.dart';
import 'package:spl_mobile/models/Notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserNotificationService {
  final Dio _dio = Dio();

  // Ambil token dari SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("accessToken");
  }

  // Ambil semua notifikasi untuk user
  Future<List<UserNotification>> fetchUserNotifications(String userId) async {
    final token = await _getToken();
    try {
      final response = await _dio.get(
        "${ApiConstants.userNotificationUrl}/$userId",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data["notifications"] as List;
        return data.map((e) => UserNotification.fromJson(e)).toList();
      } else {
        throw Exception("Gagal memuat notifikasi");
      }
    } catch (e) {
      throw Exception("Error: ${e.toString()}");
    }
  }

  // Tandai sebagai sudah dibaca
  Future<void> markNotificationAsRead(int id) async {
    final token = await _getToken();
    try {
      await _dio.put(
        "${ApiConstants.baseUrl}/api/notifications/read/$id",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
    } catch (e) {
      throw Exception("Gagal menandai sebagai dibaca");
    }
  }
}
