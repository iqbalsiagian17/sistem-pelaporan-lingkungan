import 'package:dio/dio.dart';
import 'package:bb_mobile/core/constants/api.dart';
import 'package:bb_mobile/features/notification/data/models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<UserNotificationModel>> fetchUserNotifications(String userId);
  Future<void> markNotificationAsRead(int id);
  Future<void> markAllAsRead();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {

    final Dio dio;

  NotificationRemoteDataSourceImpl(this.dio); // ✅ Terima Dio dari luar (constructor injection)

  @override
  Future<List<UserNotificationModel>> fetchUserNotifications(String userId) async {
    try {
      final response = await dio.get("${ApiConstants.userNotificationUrl}/$userId");
      final data = response.data["notifications"] as List;
      return data.map((e) => UserNotificationModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception("Gagal memuat notifikasi: $e");
    }
  }

  @override
  Future<void> markNotificationAsRead(int id) async {
    try {
      await dio.put("${ApiConstants.baseUrl}/api/notifications/read/$id");
    } catch (e) {
      throw Exception("Gagal menandai notifikasi sebagai dibaca: $e");
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await dio.put("${ApiConstants.baseUrl}/api/notifications/read-all");
    } catch (e) {
      throw Exception("Gagal menandai semua notifikasi: $e");
    }
  }
}
