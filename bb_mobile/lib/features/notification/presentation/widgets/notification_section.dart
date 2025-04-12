import 'package:bb_mobile/features/notification/domain/entities/notification_entity.dart';
import 'package:bb_mobile/features/notification/presentation/providers/notification_provider.dart';
import 'package:bb_mobile/features/report/presentation/providers/report_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:bb_mobile/routes/app_routes.dart';

class NotificationSection extends ConsumerWidget {
  final String title;
  final List<UserNotificationEntity> items;

  const NotificationSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedItems = _groupByDate(items);
    final hasUnread = items.any((notif) => !notif.isRead);

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
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (hasUnread)
                TextButton.icon(
                  onPressed: () async {
                    await ref.read(notificationProvider.notifier).markAllAsRead();
                  },
                  icon: const Icon(Icons.done_all, size: 18),
                  label: const Text("Tandai semua dibaca", style: TextStyle(fontSize: 13)),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    foregroundColor: Color(0xFF66BB6A),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          /// 🔁 List Notifikasi
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
                ...entry.value.map((notif) => _buildNotifCard(context, ref, notif))
              ]),
        ],
      ),
    );
  }

  Map<String, List<UserNotificationEntity>> _groupByDate(List<UserNotificationEntity> notifs) {
    Map<String, List<UserNotificationEntity>> grouped = {};

    for (var notif in notifs) {
      String dateKey = DateFormat('dd MMMM yyyy', 'id_ID').format(notif.createdAt);
      grouped.putIfAbsent(dateKey, () => []).add(notif);
    }

    return grouped;
  }

  Widget _buildNotifCard(BuildContext context, WidgetRef ref, UserNotificationEntity notif) {
    final dateFormatted = DateFormat('HH:mm', 'id_ID').format(notif.createdAt);

return GestureDetector(
    onTap: () async {
      await ref.read(notificationProvider.notifier).markAsRead(notif.id);

      switch (notif.type) {
        case "report":
          if (notif.reportId != null) {
            final notifier = ref.read(reportProvider.notifier);
            final report = await notifier.fetchReportById(notif.reportId!);

            if (report != null) {
              context.go(AppRoutes.detailReport, extra: report);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Gagal memuat detail laporan")),
              );
            }
          }
          break;

        case "general":
          // Misal arahkan ke halaman list announcement (bisa ke detail kalau sudah ada id-nya)
          context.go(AppRoutes.allAnnouncement);
          break;

        default:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Tipe notifikasi tidak dikenali")),
          );
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
