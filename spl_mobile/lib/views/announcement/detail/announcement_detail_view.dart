import 'package:flutter/material.dart';
import 'package:spl_mobile/models/Announcement.dart';
import 'package:spl_mobile/views/announcement/detail/components/announcement_detail_description.dart';
import 'package:spl_mobile/views/announcement/detail/components/announcement_detail_file_preview.dart';
import 'package:spl_mobile/views/announcement/detail/components/announcement_detail_title.dart';
import 'package:spl_mobile/views/announcement/detail/components/announcement_detail_topbar.dart';

class AnnouncementDetailView extends StatelessWidget {
  final AnnouncementItem announcement;

  const AnnouncementDetailView({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    final String? filePath = announcement.file; // ✅ Sesuaikan nama param

    final bool isImage = filePath != null &&
        (filePath.toLowerCase().endsWith('.jpg') ||
         filePath.toLowerCase().endsWith('.jpeg') ||
         filePath.toLowerCase().endsWith('.png'));

    return Scaffold(
      appBar: AnnouncementDetailTopBar(
        title: "Detail Pengumuman",
        onSearch: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("🔍 Fitur pencarian belum tersedia")),
          );
        },
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnnouncementTitle(
              title: announcement.title,
              createdAt: announcement.createdAt,
            ),
            const SizedBox(height: 16),
            AnnouncementFilePreview(
              filePath: filePath, // ✅ Ini sekarang cocok
              isImage: isImage,
            ),
            const SizedBox(height: 16),
            AnnouncementDescription(
              description: announcement.description,
            ),
          ],
        ),
      ),
    );
  }
}
