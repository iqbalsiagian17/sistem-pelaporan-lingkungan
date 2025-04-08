import 'package:flutter/material.dart';

class NotificationTopBar extends StatelessWidget implements PreferredSizeWidget {
  const NotificationTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        decoration: const BoxDecoration(
        color: const Color(0xFF66BB6A), 

          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        child: AppBar(
          backgroundColor: Colors.transparent, // 🪟 Agar gradient terlihat
          elevation: 0,
          title: const Text(
            'Kotak Masuk',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
