import 'package:bb_mobile/core/services/auth/global_auth_service.dart';
import 'package:bb_mobile/features/notification/domain/entities/notification_entity.dart';
import 'package:bb_mobile/features/notification/domain/usecases/get_user_notifications_usecase.dart';
import 'package:bb_mobile/features/notification/domain/usecases/mark_all_notifications_read_usecase.dart';
import 'package:bb_mobile/features/notification/domain/usecases/mark_notification_read_usecase.dart';
import 'package:bb_mobile/features/notification/presentation/providers/usecase_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, AsyncValue<List<UserNotificationEntity>>>(
  (ref) => NotificationNotifier(
    getUserNotificationsUseCase: ref.read(getUserNotificationsUseCaseProvider),
    markAsReadUseCase: ref.read(markNotificationAsReadUseCaseProvider),
    markAllAsReadUseCase: ref.read(markAllAsReadUseCaseProvider),
  ),
);

class NotificationNotifier extends StateNotifier<AsyncValue<List<UserNotificationEntity>>> {
  final GetUserNotificationsUseCase getUserNotificationsUseCase;
  final MarkNotificationAsReadUseCase markAsReadUseCase;
  final MarkAllNotificationsAsReadUseCase markAllAsReadUseCase;

  NotificationNotifier({
    required this.getUserNotificationsUseCase,
    required this.markAsReadUseCase,
    required this.markAllAsReadUseCase,
  }) : super(const AsyncLoading());

  /// 🚀 Ambil notifikasi untuk user tertentu
  Future<void> loadNotifications(String userId) async {
    state = const AsyncLoading();
    try {
      final notifications = await getUserNotificationsUseCase(userId);
      state = AsyncValue.data(notifications);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// ✅ Tandai notifikasi tertentu sebagai dibaca
  Future<void> markAsRead(int id) async {
    try {
      await markAsReadUseCase(id);
      state = state.whenData((notifs) => [
            for (final notif in notifs)
              if (notif.id == id)
                notif.copyWith(isRead: true)
              else
                notif
          ]);
    } catch (_) {}
  }

  /// 🔄 Refresh berdasarkan user saat ini (pakai token)
  Future<void> refresh() async {
    final userId = await globalAuthService.getUserId();
    if (userId != null) {
      await loadNotifications(userId.toString());
    }
  }

  /// ✅ Tandai semua notifikasi sebagai dibaca
  Future<void> markAllAsRead() async {
    try {
      await markAllAsReadUseCase();
      state = state.whenData((notifs) =>
          notifs.map((n) => n.copyWith(isRead: true)).toList());
    } catch (_) {}
  }

  /// 🔔 Hitung notifikasi yang belum dibaca (khusus user saat ini)
  int get unreadCount {
    final userId = globalAuthService.userId;
    return state.when(
      data: (list) => list.where((e) {
        return !e.isRead &&
            (
              e.userId == userId || // untuk user spesifik
              (e.userId == null && e.roleTarget == 'user') // general
            );
      }).length,
      error: (_, __) => 0,
      loading: () => 0,
    );
  }
}
