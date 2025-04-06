import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class GetUserNotificationsUseCase {
  final NotificationRepository repository;

  GetUserNotificationsUseCase(this.repository);

  Future<List<UserNotificationEntity>> call(String userId) {
    return repository.getUserNotifications(userId);
  }
}
