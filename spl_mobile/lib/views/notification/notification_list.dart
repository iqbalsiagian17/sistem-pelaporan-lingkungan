import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/widgets/skeleton/skeleton_notfication_list.dart';
import 'components/notification_section.dart';
import 'components/notification_topbar.dart';
import '../../providers/notification/user_notification_provider.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final notifProvider = Provider.of<UserNotificationProvider>(context, listen: false);
      notifProvider.refresh(); // ⏱️ Ambil ulang data notifikasi saat halaman dibuka
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<UserNotificationProvider>(context);
    final notifications = notificationProvider.notifications;
    
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    final todayNotifications = notifications.where((notif) {
      final notifDate = notif.createdAt.toLocal();
      return DateFormat('yyyy-MM-dd').format(notifDate) == DateFormat('yyyy-MM-dd').format(today);
    }).toList();

    final yesterdayNotifications = notifications.where((notif) {
      final notifDate = notif.createdAt.toLocal();
      return DateFormat('yyyy-MM-dd').format(notifDate) == DateFormat('yyyy-MM-dd').format(yesterday);
    }).toList();

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
        ? ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: 5,
            itemBuilder: (context, index) => const SkeletonNotificationItem(),
          )
          : notifications.isEmpty
              ? const Center(child: Text("Tidak ada notifikasi"))
              : ListView(
                  children: [
                    if (todayNotifications.isNotEmpty)
                      NotificationSection(title: 'Hari ini', items: todayNotifications),
                    if (yesterdayNotifications.isNotEmpty)
                      NotificationSection(
                        title: DateFormat('dd MMM yyyy').format(yesterday),
                        items: yesterdayNotifications,
                      ),
                    if (otherNotifications.isNotEmpty)
                      NotificationSection(title: 'Sebelumnya', items: otherNotifications),
                  ],
                ),
    );
  }
}
