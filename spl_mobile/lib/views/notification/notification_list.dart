import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'components/notification_section.dart';
import 'components/notification_topbar.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'Laporan sampahmu telah dikonfirmasi ✅',
        'time': '13:00',
        'date': DateTime.now(),
        'icon': Icons.campaign_rounded,
      },
      {
        'title': 'Laporan sampah sedang ditangani 🚛',
        'time': '09:00',
        'date': DateTime.now(),
        'icon': Icons.campaign_rounded,
      },
      {
        'title': 'Laporan sampahmu ditolak ❌. Periksa kembali detail laporan.',
        'time': '06:23',
        'date': DateTime.now(),
        'icon': Icons.campaign_rounded,
      },
      {
        'title': 'Laporan sampah berhasil diselesaikan 🗑️ Terima kasih atas partisipasimu!',
        'time': '14:46',
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'icon': Icons.campaign_rounded,
      },
      {
        'title': 'Laporan sampah telah dikonfirmasi dan dalam proses penanganan 🕒',
        'time': '13:32',
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'icon': Icons.campaign_rounded,
      },
      {
        'title': 'Laporan sampah telah selesai. Terima kasih telah peduli lingkungan 🌱',
        'time': '10:10',
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'icon': Icons.campaign_rounded,
      },

    ];

    final today = DateTime.now();
    final todayNotifications = notifications
        .where((notif) =>
            DateFormat('yyyy-MM-dd').format(notif['date'] as DateTime) ==
            DateFormat('yyyy-MM-dd').format(today))
        .toList();

    final yesterday = today.subtract(const Duration(days: 1));
    final yesterdayNotifications = notifications
        .where((notif) =>
            DateFormat('yyyy-MM-dd').format(notif['date'] as DateTime) ==
            DateFormat('yyyy-MM-dd').format(yesterday))
        .toList();

    return Scaffold(
      appBar: const NotificationTopBar(), // ✅ Menggunakan TopBar khusus
      body: ListView(
        children: [
          NotificationSection(title: 'Hari ini', items: todayNotifications),
          NotificationSection(title: DateFormat('dd MMM yyyy').format(yesterday), items: yesterdayNotifications),
        ],
      ),
    );
  }
}
