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
          gradient: LinearGradient(
            colors: [
              Color(0xFF4CAF50), // 💚 Hijau terang
              Color(0xFF81C784), // 💚 Hijau muda
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
