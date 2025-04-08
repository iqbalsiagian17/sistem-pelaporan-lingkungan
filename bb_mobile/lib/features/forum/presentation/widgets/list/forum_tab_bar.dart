import 'package:flutter/material.dart';

class ForumTabBar extends StatelessWidget {
  final TabController tabController;

  const ForumTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, 
      padding: EdgeInsets.zero, 
      child: TabBar(
        controller: tabController,
        labelColor: Color(0xFF66BB6A),
        unselectedLabelColor: Colors.grey,
        indicatorColor: Color(0xFF66BB6A),
        tabs: const [
          Tab(text: "Rekomendasi"),
          Tab(text: "Populer"),
        ],
      ),
    );
  }
}
