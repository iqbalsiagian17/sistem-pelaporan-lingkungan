import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bb_mobile/routes/app_routes.dart';

class PasswordEditTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const PasswordEditTopBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF66BB6A),
      elevation: 0,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.go(AppRoutes.profile),
      ),
      foregroundColor: Colors.white,
    );
  }
}
