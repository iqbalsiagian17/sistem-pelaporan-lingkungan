import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/app_routes.dart';

class SaveReportTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const SaveReportTopBar({super.key, required this.title}); // ✅ Pastikan title selalu diberikan

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        color: const Color(0xFF4CAF50), // ✅ Mint Green
        child: AppBar(
          backgroundColor: Colors.transparent, // 🪟 Agar gradient terlihat
          elevation: 0,
          title: Text(
            title, // ✅ Gunakan title dari parameter
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
        ),
      ),
    );
  }
}
