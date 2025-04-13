import 'package:bb_mobile/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:go_router/go_router.dart';

class ProfileMenu extends ConsumerWidget {
  const ProfileMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userProfileProvider);

    return state.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (user) {
        final isGoogleUser = user.authProvider == 'google';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle("Akun"),
            _buildMenuItem(Icons.edit, "Edit Profil", () {
              context.go(AppRoutes.editProfile);
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
            _buildMenuItem(Icons.info_outline, "Tentang Aplikasi", () {
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
