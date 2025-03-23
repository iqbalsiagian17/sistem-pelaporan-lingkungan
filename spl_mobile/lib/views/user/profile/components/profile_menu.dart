import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../routes/app_routes.dart';
import '../../../../providers/user_profile_provider.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;

        print("🔍 Debugging user: $user"); // 🛠 Debug: Pastikan user ter-load

        final isGoogleUser = user?.authProvider == 'google';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Text(
                "Akun",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(137, 0, 0, 0),
                ),
              ),
            ),
            _buildMenuItem(Icons.edit, "Edit Profil", () {
              context.push(AppRoutes.editProfile);
            }),

            // ❌ Sembunyikan jika user login dengan Google
            if (!isGoogleUser)
              _buildMenuItem(Icons.lock, "Ubah Password", () {
                context.go(AppRoutes.editPassword);
              }),

            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Text(
                "Umum",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54),
              ),
            ),
            _buildMenuItem(Icons.book, "Syarat & Ketentuan", () {
              context.go(AppRoutes.terms);
            }),
            _buildMenuItem(Icons.info, "Tentang Aplikasi", () {
              context.go(AppRoutes.about);
            }),
          ],
        );
      },
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
      onTap: onTap,
    );
  }
}
