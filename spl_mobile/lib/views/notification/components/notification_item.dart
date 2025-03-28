import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spl_mobile/core/utils/status_utils.dart';

class NotificationItem extends StatelessWidget {
  final Map<String, dynamic> notif;

  const NotificationItem({super.key, required this.notif});

  @override
  Widget build(BuildContext context) {
    final String title = notif['title'] ?? 'Notifikasi';
    final String rawMessage = notif['message'] ?? '';
    final String translatedMessage = StatusUtils.replaceStatusKeywords(rawMessage);

    final DateTime createdAt = notif['createdAt'] != null
        ? DateTime.parse(notif['createdAt']).toLocal()
        : DateTime.now();
    final String formattedTime = DateFormat('HH:mm • dd MMM yyyy', 'id_ID').format(createdAt);

    final IconData icon = notif['icon'] is IconData ? notif['icon'] : Icons.notifications;

    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE3E9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF1976D2),
              size: 26,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              translatedMessage,
              style: const TextStyle(fontSize: 13),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          trailing: Text(
            formattedTime,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        const Divider(height: 1, thickness: 0.4),
      ],
    );
  }
}
