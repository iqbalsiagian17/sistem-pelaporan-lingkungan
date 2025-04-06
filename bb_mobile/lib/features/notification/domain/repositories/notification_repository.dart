import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<UserNotificationEntity>> getUserNotifications(String userId);
  Future<void> markNotificationAsRead(int id);
  Future<void> markAllNotificationsAsRead();
}
