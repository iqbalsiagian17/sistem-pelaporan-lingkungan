import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  final Map<String, dynamic> notif;

  const NotificationItem({super.key, required this.notif});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE3E9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              notif['icon'],
              color: const Color(0xFF1976D2),
              size: 28,
            ),
          ),
          title: Text(
            notif['title'],
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          trailing: Text(
            notif['time'],
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
        const Divider(height: 1, thickness: 0.5),
      ],
    );
  }
}
