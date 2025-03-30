import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spl_mobile/core/services/auth/global_auth_service.dart';

class GlobalLogoutHelper {
  static void forceLogoutAndShowModal(BuildContext context) async {
    await globalAuthService.clearAuthData(); // 🔐 Bersihkan token dan user info

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            const Text(
              "Sesi Anda telah berakhir",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Silakan login kembali untuk melanjutkan.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go("/login"); // Pastikan route ini ada di AppRoutes
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Login Ulang", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
