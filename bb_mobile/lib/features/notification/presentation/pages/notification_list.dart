import 'package:bb_mobile/core/services/auth/global_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:bb_mobile/features/notification/presentation/providers/notification_provider.dart';
import 'package:bb_mobile/features/notification/presentation/widgets/notification_section.dart';
import 'package:bb_mobile/features/notification/presentation/widgets/notification_topbar.dart';

class NotificationListView extends ConsumerStatefulWidget {
  const NotificationListView({super.key});

  @override
  ConsumerState<NotificationListView> createState() => _NotificationListViewState();
}

class _NotificationListViewState extends ConsumerState<NotificationListView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final userId = await globalAuthService.getUserId();
      if (userId != null) {
        ref.read(notificationProvider.notifier).loadNotifications(userId.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationProvider);
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const NotificationTopBar(),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (notifications) {
          final todayNotifs = notifications.where((n) =>
              DateFormat('yyyy-MM-dd').format(n.createdAt) ==
              DateFormat('yyyy-MM-dd').format(today)).toList();

          final yesterdayNotifs = notifications.where((n) =>
              DateFormat('yyyy-MM-dd').format(n.createdAt) ==
              DateFormat('yyyy-MM-dd').format(yesterday)).toList();

          final otherNotifs = notifications.where((n) {
            final formatted = DateFormat('yyyy-MM-dd').format(n.createdAt);
            return formatted != DateFormat('yyyy-MM-dd').format(today) &&
                formatted != DateFormat('yyyy-MM-dd').format(yesterday);
          }).toList();

          return notifications.isEmpty
              ? const Center(child: Text("Tidak ada notifikasi"))
              : ListView(
                  children: [
                    if (todayNotifs.isNotEmpty)
                      NotificationSection(title: "Hari ini", items: todayNotifs),
                    if (yesterdayNotifs.isNotEmpty)
                      NotificationSection(
                          title: DateFormat('dd MMM yyyy', 'id_ID').format(yesterday),
                          items: yesterdayNotifs),
                    if (otherNotifs.isNotEmpty)
                      NotificationSection(title: "Sebelumnya", items: otherNotifs),
                  ],
                );
        },
      ),
    );
  }
}
