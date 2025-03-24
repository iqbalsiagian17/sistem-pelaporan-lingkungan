import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/routes/app_routes.dart';
import '../../../widgets/navbar/menu_item.dart';
import 'package:spl_mobile/providers/public/announcement_provider.dart';

class QuickAccessMenu extends StatelessWidget {
  const QuickAccessMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30.0),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        children: [
          MenuItemWidget(
            title: 'Aduan',
            icon: Icons.report_problem_rounded,
            color: Colors.green.shade600,
            onTap: () {
              context.go(AppRoutes.allReport);
            },
          ),
          MenuItemWidget(
            title: 'Forum',
            icon: Icons.forum_rounded,
            color: Colors.green.shade500,
            onTap: () {
              context.go(AppRoutes.forum);
            },
          ),
          
          // 🔔 Pengumuman dengan label jika ada yang baru
          Consumer<AnnouncementProvider>(
            builder: (context, announcementProvider, _) {
              bool hasNew = announcementProvider.hasNewAnnouncement();

              return Stack(
                children: [
                  MenuItemWidget(
                    title: 'Pengumuman',
                    icon: Icons.campaign_rounded,
                    color: Colors.green.shade400,
                    onTap: () {
                      context.go(AppRoutes.allAnnouncement);
                    },
                  ),
                  if (hasNew)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Baru',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          MenuItemWidget(
            title: 'Darurat',
            icon: Icons.warning_amber_rounded,
            color: Colors.green.shade700,
            onTap: () {
              context.go(AppRoutes.emergency);
            },
          ),
        ],
      ),
    );
  }
}
