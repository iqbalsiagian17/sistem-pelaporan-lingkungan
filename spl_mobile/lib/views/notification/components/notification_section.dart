import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/routes/app_routes.dart';
import '../../../../models/Notification.dart';
import '../../../../providers/notification/user_notification_provider.dart';

class NotificationSection extends StatelessWidget {
  final String title;
  final List<UserNotification> items;

  const NotificationSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<UserNotificationProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...items.map(
            (notif) => ListTile(
              onTap: () async {
                print("🔔 Notifikasi diklik - ID: ${notif.id}, Type: ${notif.type}");

                // Tandai sebagai sudah dibaca
                await notificationProvider.markAsRead(notif.id);

                if (notif.type == "verification") {
                  context.go(AppRoutes.myReport);
                }
              },
              leading: const Icon(
                Icons.campaign_rounded,
                color: Colors.green,
              ),
              title: Text(
                notif.title,
                style: TextStyle(
                  fontWeight: notif.isRead ? FontWeight.normal : FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notif.message),
                  Text(
                    DateFormat('HH:mm • dd MMM yyyy').format(notif.createdAt),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              isThreeLine: true,
              tileColor: notif.isRead ? null : Colors.grey.shade100,
            ),
          ),
        ],
      ),
    );
  }
}
