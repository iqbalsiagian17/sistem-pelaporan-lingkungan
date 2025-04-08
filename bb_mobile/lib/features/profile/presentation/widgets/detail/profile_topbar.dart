import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bb_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:bb_mobile/features/auth/presentation/providers/google_auth_provider.dart';
import 'package:bb_mobile/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:bb_mobile/routes/app_routes.dart';

class ProfileTopBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onLogout; // Add the onLogout parameter

  const ProfileTopBar({super.key, required this.title, required this.onLogout});

  @override
  Size get preferredSize => const Size.fromHeight(50);

  void _showLogoutConfirmation(BuildContext context, WidgetRef ref) {
    HapticFeedback.mediumImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.exit_to_app_rounded, size: 50, color: Colors.red),
              const SizedBox(height: 12),
              const Text(
                "Keluar dari Akun?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Anda yakin ingin logout? Semua sesi akan diakhiri.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: Color(0xFF66BB6A)),
                      ),
                      child: const Text("Batal", style: TextStyle(color: Color(0xFF66BB6A), fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        HapticFeedback.heavyImpact();
                        Navigator.pop(context);
                        onLogout();  // Call the passed callback for logout

                        if (context.mounted) {
                          context.go(AppRoutes.login);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Keluar", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        color: const Color(0xFF66BB6A), 
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          centerTitle: true,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                context.go(AppRoutes.dashboard);
              }
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _showLogoutConfirmation(context, ref), // Use _showLogoutConfirmation
            ),
          ],
        ),
      ),
    );
  }
}
