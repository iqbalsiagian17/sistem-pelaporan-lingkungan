import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/providers/public/announcement_provider.dart';
import 'package:spl_mobile/widgets/skeleton/skeleton_report_list.dart';
import 'package:spl_mobile/views/announcement/components/announcement_list_data_state.dart';
import 'package:spl_mobile/views/announcement/components/announcement_list_empety.dart';
import 'package:spl_mobile/views/announcement/components/announcement_list_topbar.dart';

class AnnouncementListView extends StatefulWidget {
  const AnnouncementListView({super.key});

  @override
  State<AnnouncementListView> createState() => _AnnouncementListViewState();
}

class _AnnouncementListViewState extends State<AnnouncementListView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AnnouncementProvider>(context, listen: false).fetchAnnouncement();
    });
  }

  Future<void> _refreshData() async {
    await Provider.of<AnnouncementProvider>(context, listen: false).fetchAnnouncement();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AnnouncementListTopBar(
        title: "Daftar Pengumuman",
        onSearch: () {
          debugPrint("🔍 Search belum diimplementasi");
        },
      ),

      body: Consumer<AnnouncementProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return ListView.builder(
              itemCount: 6,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemBuilder: (_, __) => const SkeletonReportList(),
            );
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 40, color: Colors.redAccent),
                  const SizedBox(height: 10),
                  Text(
                    provider.errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshData,
                    child: const Text("Coba Lagi"),
                  ),
                ],
              ),
            );
          }

          if (provider.announcements.isEmpty) {
            return AnnouncementListEmptyState(onRetry: _refreshData);
          }

          return AnnouncementListDataState(
            announcements: provider.announcements,
            onRetry: _refreshData,
          );
        },
      ),
    );
  }
}
