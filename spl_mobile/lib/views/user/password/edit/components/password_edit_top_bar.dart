import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../routes/app_routes.dart';

class PasswordEditTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const PasswordEditTopBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        backgroundColor: const Color(0xFF4CAF50),
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go(AppRoutes.profile);
          },
        ),
      ),
    );
  }
}
