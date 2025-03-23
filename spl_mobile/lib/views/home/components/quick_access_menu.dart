import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spl_mobile/routes/app_routes.dart';
import '../../../widgets/menu_item.dart';

class QuickAccessMenu extends StatelessWidget {
  const QuickAccessMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30.0), // ✅ Tambahkan margin bawah
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
            color: Colors.green.shade600, // ✅ Warna Hijau Gelap
            onTap: () {
              context.go(AppRoutes.allReport); // ✅ Navigasi ke ReportListAllView
            },
          ),
          MenuItemWidget(
            title: 'Forum',
            icon: Icons.forum_rounded,
            color: Colors.green.shade500, // ✅ Warna Hijau Medium
            onTap: () {
              context.go(AppRoutes.forum); // ✅ Navigasi ke ForumView
            },          
          ),
          MenuItemWidget(
            title: 'Pengumuman',
            icon: Icons.campaign_rounded,
            color: Colors.green.shade400, // ✅ Warna Hijau Muda
            onTap: () {
              context.go(AppRoutes.allAnnouncement);
            },
          ),
          MenuItemWidget(
            title: 'Darurat',
            icon: Icons.warning_amber_rounded,
            color: Colors.green.shade700, // ✅ Warna Hijau Tua
            onTap: () {
              context.go(AppRoutes.emergency);
            },
          ),
        ],
      ),
    );
  }
}
