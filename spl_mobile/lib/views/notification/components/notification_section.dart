import 'package:flutter/material.dart';
import 'notification_item.dart';

class NotificationSection extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;

  const NotificationSection({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return items.isEmpty
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                color: const Color(0xFFF5F5F5),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Column(children: items.map((notif) => NotificationItem(notif: notif)).toList()),
            ],
          );
  }
}
