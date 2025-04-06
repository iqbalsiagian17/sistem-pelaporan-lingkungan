import 'package:bb_mobile/features/notification/data/datasources/notification_remote_datasource.dart';
import 'package:bb_mobile/features/notification/domain/entities/notification_entity.dart';
import 'package:bb_mobile/features/notification/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<UserNotificationEntity>> getUserNotifications(String userId) async {
    final result = await remoteDataSource.fetchUserNotifications(userId);
    return result.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> markNotificationAsRead(int id) {
    return remoteDataSource.markNotificationAsRead(id);
  }

  @override
  Future<void> markAllNotificationsAsRead() {
    return remoteDataSource.markAllAsRead();
  }
}
