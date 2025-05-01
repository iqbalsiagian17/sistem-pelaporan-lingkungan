import 'package:bb_mobile/features/announcement/presentation/providers/announcement_provider.dart';
import 'package:bb_mobile/features/announcement/presentation/widgets/list/announcement_list_data_state.dart';
import 'package:bb_mobile/features/announcement/presentation/widgets/list/announcement_list_empety.dart';
import 'package:bb_mobile/features/announcement/presentation/widgets/list/announcement_list_topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnnouncementListView extends ConsumerWidget {
  const AnnouncementListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(announcementProvider);
    final notifier = ref.read(announcementProvider.notifier);

    // ✅ Paksa fetch ulang saat masuk halaman
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifier.fetchAnnouncements();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AnnouncementListTopBar(
        title: 'Daftar Pengumuman',
        onSearch: () => debugPrint("🔍 Search belum diimplementasi"),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 40, color: Colors.redAccent),
              const SizedBox(height: 10),
              Text(err.toString(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: notifier.fetchAnnouncements, child: const Text("Coba Lagi")),
            ],
          ),
        ),
        data: (announcements) {
          if (announcements.isEmpty) {
            return AnnouncementListEmptyState(onRetry: notifier.fetchAnnouncements);
          } else {
            return AnnouncementListDataState(
              announcements: announcements,
              onRetry: notifier.fetchAnnouncements,
            );
          }
        },
      ),
    );
  }
}
