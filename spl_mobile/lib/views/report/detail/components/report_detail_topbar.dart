import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/app_routes.dart';

class ReportDetailTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onSearch; // ✅ Tambahkan callback search (opsional)

  const ReportDetailTopBar({super.key, required this.title, this.onSearch});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4CAF50), // 💚 Light Green
              Color(0xFF81C784), // 💚 Soft Green
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        child: AppBar(
          backgroundColor: Colors.transparent, // ✅ Gradient tetap terlihat
          elevation: 0,
          title: Text(
            title, // ✅ Teks dinamis
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
                context.go(AppRoutes.home);
              }
            },
          ),
          actions: onSearch != null
              ? [
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.white), // 🔍 Search icon
                    onPressed: onSearch, // ✅ Callback pencarian
                  ),
                ]
              : null, // ✅ Jika `onSearch` tidak disediakan, ikon tidak muncul
        ),
      ),
    );
  }
}
