import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/core/constants/dio_client.dart';
import 'package:bb_mobile/features/notification/data/datasources/notification_remote_datasource.dart';
import 'package:bb_mobile/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:bb_mobile/features/notification/domain/usecases/get_user_notifications_usecase.dart';
import 'package:bb_mobile/features/notification/domain/usecases/mark_all_notifications_read_usecase.dart';
import 'package:bb_mobile/features/notification/domain/usecases/mark_notification_read_usecase.dart';

// ✅ Provider untuk RemoteDataSource
final notificationRemoteDataSourceProvider = Provider<NotificationRemoteDataSource>((ref) {
  return NotificationRemoteDataSourceImpl(DioClient.instance); // 🟢 Pakai DioClient
});

// ✅ Provider untuk Repository
final notificationRepositoryProvider = Provider<NotificationRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(notificationRemoteDataSourceProvider);
  return NotificationRepositoryImpl(remoteDataSource: remoteDataSource);
});

// ✅ UseCase Provider
final getUserNotificationsUseCaseProvider = Provider<GetUserNotificationsUseCase>((ref) {
  final repo = ref.watch(notificationRepositoryProvider);
  return GetUserNotificationsUseCase(repo);
});

final markNotificationAsReadUseCaseProvider = Provider<MarkNotificationAsReadUseCase>((ref) {
  final repo = ref.watch(notificationRepositoryProvider);
  return MarkNotificationAsReadUseCase(repo);
});

final markAllAsReadUseCaseProvider = Provider<MarkAllNotificationsAsReadUseCase>((ref) {
  final repo = ref.watch(notificationRepositoryProvider);
  return MarkAllNotificationsAsReadUseCase(repo);
});
