import 'package:flutter/material.dart';
import 'package:spl_mobile/models/Notification.dart';
import 'package:spl_mobile/core/services/user/notification/user_notification_service.dart';
import 'package:spl_mobile/core/services/auth/global_auth_service.dart';

class UserNotificationProvider with ChangeNotifier {
  final UserNotificationService _service = UserNotificationService();

  List<UserNotification> _notifications = [];
  bool _isLoading = false;
  String? _error;

  List<UserNotification> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  UserNotificationProvider() {
    _init(); // 🔁 Auto load saat inisialisasi
  }

  Future<void> _init() async {
    final userId = await globalAuthService.getUserId();
    if (userId != null) {
      await loadNotifications(userId);
    } else {
      _error = "User ID tidak ditemukan.";
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    final userId = await globalAuthService.getUserId();
    if (userId != null) {
      await loadNotifications(userId);
    }
  }

  Future<void> loadNotifications(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _service.fetchUserNotifications(userId.toString());
      _notifications = data;
    } catch (e) {
      _error = e.toString();
      _notifications = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await _service.markNotificationAsRead(id);
      final index = _notifications.indexWhere((notif) => notif.id == id);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("❌ Gagal menandai notifikasi sebagai dibaca: $e");
    }
  }

  int get unreadCount =>
      _notifications.where((n) => n.isRead == false).length;
}
