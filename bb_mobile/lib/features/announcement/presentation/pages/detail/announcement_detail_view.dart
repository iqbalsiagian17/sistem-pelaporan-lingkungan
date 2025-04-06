import 'package:bb_mobile/features/announcement/domain/entities/announcement_entity.dart';
import 'package:bb_mobile/features/announcement/presentation/widgets/detail/announcement_detail_description.dart';
import 'package:bb_mobile/features/announcement/presentation/widgets/detail/announcement_detail_file_preview.dart';
import 'package:bb_mobile/features/announcement/presentation/widgets/detail/announcement_detail_title.dart';
import 'package:bb_mobile/features/announcement/presentation/widgets/detail/announcement_detail_topbar.dart';
import 'package:flutter/material.dart';

class AnnouncementDetailView extends StatelessWidget {
  final AnnouncementEntity announcement;

  const AnnouncementDetailView({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    final String? filePath = announcement.file;

    final bool isImage = filePath != null &&
        (filePath.toLowerCase().endsWith('.jpg') ||
         filePath.toLowerCase().endsWith('.jpeg') ||
         filePath.toLowerCase().endsWith('.png'));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AnnouncementDetailTopBar(title: "Detail Pengumuman"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnnouncementTitle(title: announcement.title, createdAt: announcement.createdAt),
            const SizedBox(height: 16),
            AnnouncementFilePreview(filePath: filePath, isImage: isImage),
            const SizedBox(height: 16),
            AnnouncementDescription(description: announcement.description),
          ],
        ),
      ),
    );
  }
}
