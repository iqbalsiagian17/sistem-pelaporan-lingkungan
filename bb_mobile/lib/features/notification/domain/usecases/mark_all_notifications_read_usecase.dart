import '../repositories/notification_repository.dart';

class MarkAllNotificationsAsReadUseCase {
  final NotificationRepository repository;

  MarkAllNotificationsAsReadUseCase(this.repository);

  Future<void> call() {
    return repository.markAllNotificationsAsRead();
  }
}
