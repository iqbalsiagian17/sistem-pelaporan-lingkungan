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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: const Color(0xFF1976D2), size: 26),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                translatedMessage,
                style: const TextStyle(fontSize: 13.5, color: Colors.black87),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                formattedTime,
                style: const TextStyle(fontSize: 11.5, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
