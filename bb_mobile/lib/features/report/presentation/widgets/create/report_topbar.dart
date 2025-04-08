import 'package:bb_mobile/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReportTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const ReportTopBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        color: const Color(0xFF66BB6A), 
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                context.go(AppRoutes.dashboard);
              }
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline_rounded),
              tooltip: 'Tata Cara Pelaporan',
              onPressed: () {
                context.go(AppRoutes.reportGuides);
              },
            ),
          ],
        ),
      ),
    );
  }
}
