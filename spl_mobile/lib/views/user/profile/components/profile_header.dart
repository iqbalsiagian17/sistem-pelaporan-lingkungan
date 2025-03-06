import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider.dart'; // ✅ Ambil user dari sini

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  // ✅ Fungsi untuk mendapatkan warna random
  Color _getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  // ✅ Fungsi untuk mendapatkan inisial username
  String _getInitials(String? username) {
    if (username == null || username.isEmpty) return "?";
    List<String> names = username.split(" ");
    if (names.length == 1) {
      return names[0][0].toUpperCase();
    } else {
      return "${names[0][0]}${names[1][0]}".toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        final String initials = _getInitials(user?.username);
        final Color bgColor = _getRandomColor();

        return Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: bgColor,
              child: Text(
                initials,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              user?.username ?? "Pengguna",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              user?.phoneNumber ?? "Tidak ada nomor",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 5),
            Text(
              user?.email ?? "Tidak ada email",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        );
      },
    );
  }
}
