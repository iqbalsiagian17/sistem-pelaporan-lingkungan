import 'package:flutter/material.dart';
import 'package:bb_mobile/core/services/auth/global_auth_service.dart';

class GlobalLogoutHelper {
  /// Logout paksa + arahkan ke login + modal notifikasi
  static void forceLogoutAndShowModal(BuildContext context) async {
    await globalAuthService.clearAuthData();

    // Arahkan ke login atau splash
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login', // Ganti sesuai rute login kamu
      (route) => false,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Sesi Berakhir"),
        content: const Text("Silakan login ulang untuk melanjutkan."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
