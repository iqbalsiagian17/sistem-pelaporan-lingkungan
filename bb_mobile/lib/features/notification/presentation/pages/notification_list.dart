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
  String _selectedFilter = "all";

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

    final filteredNotifs = _filterByType(state.notifications);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: NotificationTopBar(
        selectedType: _selectedFilter,
        onFilterChanged: (val) {
          setState(() => _selectedFilter = val);
        },
      ),
      body: filteredNotifs.isEmpty
          ? const Center(child: Text("Tidak ada notifikasi"))
          : ListView(
              children: [
                if (_filterByDate(filteredNotifs, today).isNotEmpty)
                  NotificationSection(
                    title: "Hari ini",
                    items: _filterByDate(filteredNotifs, today),
                  ),

                if (_filterByDate(filteredNotifs, yesterday).isNotEmpty)
                  NotificationSection(
                    title: DateFormat('dd MMM yyyy', 'id_ID').format(yesterday),
                    items: _filterByDate(filteredNotifs, yesterday),
                  ),

                if (_filterOthers(filteredNotifs, today, yesterday).isNotEmpty)
                  NotificationSection(
                    title: "Sebelumnya",
                    items: _filterOthers(filteredNotifs, today, yesterday),
                  ),
              ],
            ),
    );
  }

  List<UserNotificationEntity> _filterByType(List<UserNotificationEntity> list) {
    if (_selectedFilter == "all") return list;
    return list.where((n) => n.type == _selectedFilter).toList();
  }

  List<UserNotificationEntity> _filterByDate(List<UserNotificationEntity> list, DateTime date) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return list.where((n) {
      final notifWib = n.createdAt.toLocal();
      return dateFormat.format(notifWib) == dateFormat.format(date);
    }).toList();
  }

  List<UserNotificationEntity> _filterOthers(
    List<UserNotificationEntity> list,
    DateTime today,
    DateTime yesterday,
  ) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return list.where((n) {
      final notifWib = n.createdAt.toLocal();
      final todayStr = dateFormat.format(today);
      final yesterdayStr = dateFormat.format(yesterday);
      final notifStr = dateFormat.format(notifWib);
      return notifStr != todayStr && notifStr != yesterdayStr;
    }).toList();
  }
}
