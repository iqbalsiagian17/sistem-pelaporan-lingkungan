import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/user_profile_provider.dart';

class ProfileHeader extends StatelessWidget {
  ProfileHeader({super.key});

  // ✅ Warna berdasarkan hash dari username (agar tetap sama)
  Color _generateColorFromUsername(String username) {
    int hash = username.hashCode;
    int r = (hash & 0xFF0000) >> 16;
    int g = (hash & 0x00FF00) >> 8;
    int b = (hash & 0x0000FF);
    return Color.fromARGB(255, r, g, b);
  }

  // ✅ Ambil inisial username
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
    return Consumer<UserProfileProvider>(
      builder: (context, profileProvider, child) {
        final user = profileProvider.user;

        if (user == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final String initials = _getInitials(user.username);
        final Color bgColor = _generateColorFromUsername(user.username); // ✅ Warna tetap

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
              user.username,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              user.phoneNumber.isNotEmpty ? user.phoneNumber : "Tidak ada nomor",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 5),
            Text(
              user.email.isNotEmpty ? user.email : "Tidak ada email",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        );
      },
    );
  }
}
