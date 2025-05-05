import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:bb_mobile/features/notification/domain/entities/notification_entity.dart';
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
    Future.microtask(() => ref.read(notificationProvider.notifier).refresh());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationProvider);

    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const NotificationTopBar(),
      body: state.notifications.isEmpty
          ? const Center(child: Text("Tidak ada notifikasi"))
          : ListView(
              children: [
                // Hari ini
                if (_filterByDate(state.notifications, today).isNotEmpty)
                  NotificationSection(
                    title: "Hari ini",
                    items: _filterByDate(state.notifications, today),
                  ),

                // Kemarin
                if (_filterByDate(state.notifications, yesterday).isNotEmpty)
                  NotificationSection(
                    title: DateFormat('dd MMM yyyy', 'id_ID').format(yesterday),
                    items: _filterByDate(state.notifications, yesterday),
                  ),

                // Sebelumnya
                if (_filterOthers(state.notifications, today, yesterday).isNotEmpty)
                  NotificationSection(
                    title: "Sebelumnya",
                    items: _filterOthers(state.notifications, today, yesterday),
                  ),
              ],
            ),
    );
  }

  List<UserNotificationEntity> _filterByDate(
    List<UserNotificationEntity> list,
    DateTime date,
  ) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return list.where((n) => dateFormat.format(n.createdAt) == dateFormat.format(date)).toList();
  }

  List<UserNotificationEntity> _filterOthers(
    List<UserNotificationEntity> list,
    DateTime today,
    DateTime yesterday,
  ) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return list.where((n) {
      final notifDate = dateFormat.format(n.createdAt);
      return notifDate != dateFormat.format(today) && notifDate != dateFormat.format(yesterday);
    }).toList();
  }
}
