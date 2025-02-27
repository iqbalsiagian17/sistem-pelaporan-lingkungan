import 'package:flutter/material.dart';
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
            icon: Icons.report_gmailerrorred_rounded,
            color: Colors.redAccent,
            onTap: () {},
          ),
          MenuItemWidget(
            title: 'Forum',
            icon: Icons.article_outlined,
            color: Colors.blueAccent,
            onTap: () {},
          ),
          MenuItemWidget(
            title: 'Pengumuman',
            icon: Icons.calendar_today,
            color: Colors.teal,
            onTap: () {},
          ),
          MenuItemWidget(
            title: 'Darurat',
            icon: Icons.warning_amber_rounded,
            color: Colors.orangeAccent,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
