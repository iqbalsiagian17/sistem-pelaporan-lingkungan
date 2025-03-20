import 'package:flutter/material.dart';

class ForumTabBar extends StatelessWidget {
  final TabController tabController;

  const ForumTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // ✅ Pastikan warna putih agar tidak menyatu dengan header
      padding: EdgeInsets.zero, // ✅ Hilangkan padding ekstra
      child: TabBar(
        controller: tabController,
        labelColor: Colors.green.shade800,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.green,
        tabs: const [
          Tab(text: "Rekomendasi"),
          Tab(text: "Populer"),
        ],
      ),
    );
  }
}
