import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/providers/report/report_provider.dart';
import 'package:spl_mobile/routes/app_routes.dart';
import 'package:spl_mobile/widgets/skeleton/skeleton_notfication_list.dart';
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
    final notificationProvider = context.watch<UserNotificationProvider>();
    final isLoading = notificationProvider.isLoading;

    final groupedItems = _groupByDate(items);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔰 Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (items.any((notif) => !notif.isRead))
                TextButton.icon(
                  onPressed: () async {
                    await notificationProvider.markAllAsRead();
                  },
                  icon: const Icon(Icons.done_all, size: 18),
                  label: const Text("Tandai semua dibaca", style: TextStyle(fontSize: 13)),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    foregroundColor: Colors.green.shade700,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          /// 🔁 Content
          if (isLoading)
            ...List.generate(5, (_) => const SkeletonNotificationItem())
          else
            ...groupedItems.entries.expand((entry) => [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  ...entry.value.map((notif) => _buildNotifCard(context, notif))
                ]),
        ],
      ),
    );
  }

  /// ✅ Grup notifikasi berdasarkan tanggal 'dd MMMM yyyy'
  Map<String, List<UserNotification>> _groupByDate(List<UserNotification> notifs) {
    Map<String, List<UserNotification>> grouped = {};

    for (var notif in notifs) {
      String dateKey = DateFormat('dd MMMM yyyy', 'id_ID').format(notif.createdAt);

      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }

      grouped[dateKey]!.add(notif);
    }

    return grouped;
  }

  /// 🔔 Card Notifikasi
  Widget _buildNotifCard(BuildContext context, UserNotification notif) {
    final dateFormatted = DateFormat('HH:mm', 'id_ID').format(notif.createdAt);

    return GestureDetector(
      onTap: () async {
        final notificationProvider = context.read<UserNotificationProvider>();
        await notificationProvider.markAsRead(notif.id);

        if (notif.type == "verification") {
          final reportProvider = context.read<ReportProvider>();
          await reportProvider.refresh();
          context.go(AppRoutes.myReport);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notif.isRead ? Colors.white : const Color(0xFFF1F8E9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.notifications_active, size: 26, color: Color(0xFF66BB6A)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notif.title,
                    style: TextStyle(
                      fontWeight: notif.isRead ? FontWeight.w500 : FontWeight.bold,
                      fontSize: 14.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notif.message,
                    style: const TextStyle(fontSize: 13.5),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dateFormatted,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
