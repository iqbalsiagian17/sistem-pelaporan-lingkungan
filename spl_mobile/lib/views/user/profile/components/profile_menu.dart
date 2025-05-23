import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/app_routes.dart';
import '../../../../providers/user/user_profile_provider.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, profileProvider, _) {
        final user = profileProvider.user;
        final isGoogleUser = user?.authProvider == 'google';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle("Akun"),
            _buildMenuItem(Icons.edit, "Edit Profil", () {
              context.push(AppRoutes.editProfile);
            }),
            if (!isGoogleUser)
              _buildMenuItem(Icons.lock, "Ubah Password", () {
                context.go(AppRoutes.editPassword);
              }),
            const SizedBox(height: 20),
            const _SectionTitle("Umum"),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(icon, color: Colors.black54),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
      onTap: onTap,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 16, bottom: 4),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54),
      ),
    );
  }
}
