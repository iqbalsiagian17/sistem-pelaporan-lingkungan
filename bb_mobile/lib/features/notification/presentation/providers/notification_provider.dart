import 'package:bb_mobile/core/services/auth/global_auth_service.dart';
import 'package:bb_mobile/features/notification/domain/entities/notification_entity.dart';
import 'package:bb_mobile/features/notification/domain/usecases/get_user_notifications_usecase.dart';
import 'package:bb_mobile/features/notification/domain/usecases/mark_all_notifications_read_usecase.dart';
import 'package:bb_mobile/features/notification/domain/usecases/mark_notification_read_usecase.dart';
import 'package:bb_mobile/features/notification/presentation/providers/usecase_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationProvider = StateNotifierProvider<NotificationNotifier, NotificationState>(
  (ref) => NotificationNotifier(
    getUserNotificationsUseCase: ref.read(getUserNotificationsUseCaseProvider),
    markAsReadUseCase: ref.read(markNotificationAsReadUseCaseProvider),
    markAllAsReadUseCase: ref.read(markAllAsReadUseCaseProvider),
  ),
);

class NotificationState {
  final List<UserNotificationEntity> notifications;
  final int unreadCount;

  NotificationState({
    required this.notifications,
    required this.unreadCount,
  });

  NotificationState copyWith({
    List<UserNotificationEntity>? notifications,
    int? unreadCount,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  final GetUserNotificationsUseCase getUserNotificationsUseCase;
  final MarkNotificationAsReadUseCase markAsReadUseCase;
  final MarkAllNotificationsAsReadUseCase markAllAsReadUseCase;

  NotificationNotifier({
    required this.getUserNotificationsUseCase,
    required this.markAsReadUseCase,
    required this.markAllAsReadUseCase,
  }) : super(NotificationState(notifications: [], unreadCount: 0));

  Future<void> loadNotifications(String userId) async {
    try {
      final notifications = await getUserNotificationsUseCase(userId);
      final unread = _countUnread(notifications, int.tryParse(userId));
      state = NotificationState(notifications: notifications, unreadCount: unread);
    } catch (_) {}
  }

  Future<void> refresh() async {
    final userId = await globalAuthService.getUserId();
    if (userId != null) {
      await loadNotifications(userId.toString());
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await markAsReadUseCase(id);
      final updated = state.notifications.map((n) {
        return n.id == id ? n.copyWith(isRead: true) : n;
      }).toList();
      final unread = _countUnread(updated, globalAuthService.userId);
      state = state.copyWith(notifications: updated, unreadCount: unread);
    } catch (_) {}
  }

  Future<void> markAllAsRead() async {
    try {
      await markAllAsReadUseCase();
      final updated = state.notifications.map((n) => n.copyWith(isRead: true)).toList();
      state = state.copyWith(notifications: updated, unreadCount: 0);
    } catch (_) {}
  }

  int _countUnread(List<UserNotificationEntity> list, int? userId) {
    return list.where((e) =>
        !e.isRead &&
        (e.userId == userId ||
            (e.userId == null && e.roleTarget == 'user'))).length;
  }
}
