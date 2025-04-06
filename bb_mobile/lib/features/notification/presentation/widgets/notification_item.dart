import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bb_mobile/features/notification/domain/entities/notification_entity.dart';
import 'package:bb_mobile/core/utils/status_utils.dart';

class NotificationItem extends StatelessWidget {
  final UserNotificationEntity notif;

  const NotificationItem({super.key, required this.notif});

  @override
  Widget build(BuildContext context) {
    final String translatedMessage = StatusUtils.replaceStatusKeywords(notif.message);
    final String formattedTime =
        DateFormat('HH:mm • dd MMM yyyy', 'id_ID').format(notif.createdAt);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: notif.isRead ? Colors.white : const Color(0xFFF1F8E9),
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
            child: const Icon(Icons.notifications, color: Color(0xFF1976D2), size: 26),
          ),
          title: Text(
            notif.title,
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
