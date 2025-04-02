import 'package:dio/dio.dart';
import 'package:spl_mobile/core/constants/api.dart';
import 'package:spl_mobile/core/constants/dio_client.dart';
import 'package:spl_mobile/models/Notification.dart';

class UserNotificationService {
  final Dio _dio = DioClient.instance;

  /// ✅ Ambil semua notifikasi berdasarkan userId
  Future<List<UserNotification>> fetchUserNotifications(String userId) async {
    try {
      final response = await _dio.get(
        "${ApiConstants.userNotificationUrl}/$userId",
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

  /// ✅ Tandai notifikasi sebagai dibaca
  Future<void> markNotificationAsRead(int id) async {
    try {
      await _dio.put(
        "${ApiConstants.baseUrl}/api/notifications/read/$id",
      );
    } catch (e) {
      throw Exception("Gagal menandai notifikasi sebagai dibaca");
    }
  }

  
  Future<void> markAllAsRead() async {
       try {
      await _dio.put(
        "${ApiConstants.baseUrl}/api/notifications/read-all",
      );
    } catch (e) {
      rethrow;
    }
  }
}