import 'package:bb_mobile/features/announcement/domain/entities/announcement_entity.dart';
import 'package:bb_mobile/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';

class AnnouncementListDataState extends StatefulWidget {
  final List<AnnouncementEntity> announcements;
  final VoidCallback onRetry;

  const AnnouncementListDataState({
    super.key,
    required this.announcements,
    required this.onRetry,
  });

  @override
  State<AnnouncementListDataState> createState() => _AnnouncementListDataStateState();
}

class _AnnouncementListDataStateState extends State<AnnouncementListDataState> {
  static const int itemsPerPage = 10;
  int currentPage = 1;

  bool isNewAnnouncement(DateTime createdAt) =>
      DateTime.now().difference(createdAt).inHours < 24;

  String truncateDescription(String description, int wordLimit) {
    final words = description.split(' ');
    return words.length > wordLimit ? words.sublist(0, wordLimit).join(' ') + '...' : description;
  }

  @override
  Widget build(BuildContext context) {
    final visibleItems = widget.announcements.take(currentPage * itemsPerPage).toList();
    final hasMore = visibleItems.length < widget.announcements.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          ...visibleItems.map((announcement) {
            final isNew = isNewAnnouncement(announcement.createdAt);
            final truncated = truncateDescription(announcement.description, 10);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: Colors.white,
                elevation: 1,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: () {
                    context.push(AppRoutes.announcementDetail, extra: announcement);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      announcement.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  if (isNew)
                                    Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'Baru',
                                        style: TextStyle(fontSize: 10, color: Colors.white),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Html(
                                data: truncated,
                                style: {
                                  "p": Style(fontSize: FontSize(13), color: Colors.black54),
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          if (hasMore)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton(
                onPressed: () => setState(() => currentPage++),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text("Muat Lebih Banyak"),
              ),
            ),
        ],
      ),
    );
  }
}
