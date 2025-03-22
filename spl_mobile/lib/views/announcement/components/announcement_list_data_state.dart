import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:spl_mobile/models/Announcement.dart';
import 'package:spl_mobile/routes/app_routes.dart';
import './announcement_list_empety.dart';

class AnnouncementListDataState extends StatefulWidget {
  final List<AnnouncementItem> announcements;
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

  bool isNewAnnouncement(DateTime createdAt) {
    final now = DateTime.now();
    return now.difference(createdAt).inHours < 24;
  }

  @override
  Widget build(BuildContext context) {
    final totalItems = widget.announcements.length;
    final visibleItems = widget.announcements.take(currentPage * itemsPerPage).toList();
    final hasMore = visibleItems.length < totalItems;

    return Container(
      color: Colors.white,
      child: widget.announcements.isEmpty
          ? AnnouncementListEmptyState(onRetry: widget.onRetry)
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  ...List.generate(visibleItems.length, (index) {
                    final announcement = visibleItems[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        elevation: 1,
                        child: InkWell(
                          onTap: () {
                            context.push(AppRoutes.announcementDetail, extra: announcement);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          if (isNewAnnouncement(announcement.createdAt))
                                            Container(
                                              margin: const EdgeInsets.only(left: 8),
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.redAccent,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: const Text(
                                                "Baru",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        announcement.description,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black54,
                                        ),
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
                        onPressed: () {
                          setState(() {
                            currentPage++;
                          });
                        },
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
            ),
    );
  }
}
