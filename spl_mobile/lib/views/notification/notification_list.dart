import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'components/notification_section.dart';
import 'components/notification_topbar.dart';
import '../../providers/notification/user_notification_provider.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<UserNotificationProvider>(context);
    final notifications = notificationProvider.notifications;

    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    // Filter notifikasi Hari Ini
    final todayNotifications = notifications.where((notif) {
      final notifDate = notif.createdAt.toLocal();
      return DateFormat('yyyy-MM-dd').format(notifDate) ==
          DateFormat('yyyy-MM-dd').format(today);
    }).toList();

    // Filter notifikasi Kemarin
    final yesterdayNotifications = notifications.where((notif) {
      final notifDate = notif.createdAt.toLocal();
      return DateFormat('yyyy-MM-dd').format(notifDate) ==
          DateFormat('yyyy-MM-dd').format(yesterday);
    }).toList();

    // Notifikasi lainnya (bukan hari ini atau kemarin)
    final otherNotifications = notifications.where((notif) {
      final notifDate = notif.createdAt.toLocal();
      final notifFormatted = DateFormat('yyyy-MM-dd').format(notifDate);
      return notifFormatted != DateFormat('yyyy-MM-dd').format(today) &&
          notifFormatted != DateFormat('yyyy-MM-dd').format(yesterday);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const NotificationTopBar(),
      body: notificationProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? const Center(child: Text("Tidak ada notifikasi"))
              : ListView(
                  children: [
                    if (todayNotifications.isNotEmpty)
                      NotificationSection(
                        title: 'Hari ini',
                        items: todayNotifications,
                      ),
                    if (yesterdayNotifications.isNotEmpty)
                      NotificationSection(
                        title: DateFormat('dd MMM yyyy').format(yesterday),
                        items: yesterdayNotifications,
                      ),
                    if (otherNotifications.isNotEmpty)
                      NotificationSection(
                        title: 'Sebelumnya',
                        items: otherNotifications,
                      ),
                  ],
                ),
    );
  }
}
