import 'package:bb_mobile/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:bb_mobile/widgets/navbar/menu_item.dart';
import 'package:go_router/go_router.dart';

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
              color: const Color(0xFF4CAF50), // ini jadi background hijau

            onTap: () {
                context.go(AppRoutes.allReport);
            },
          ),
          MenuItemWidget(
            title: 'Forum',
            icon: Icons.forum_rounded,
              color: const Color(0xFF4CAF50), // ini jadi background hijau

            onTap: () {
              context.go(AppRoutes.forum);
            },
          ),
          MenuItemWidget(
            title: 'Pengumuman',
            icon: Icons.campaign_rounded,
              color: const Color(0xFF4CAF50), // ini jadi background hijau

            onTap: () {
              context.go(AppRoutes.allAnnouncement);
            },  
          ),
          MenuItemWidget(
            title: 'Darurat',
            icon: Icons.warning_amber_rounded,
              color: const Color(0xFF4CAF50), // ini jadi background hijau

            onTap: () {
              context.go(AppRoutes.emergency);
            },
          ),
        ],
      ),
    );
  }
}
