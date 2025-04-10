import 'dart:async';
import 'global_auth_service.dart';

class AuthAutoRefreshService {
  static Timer? _timer;

  /// Mulai auto-refresh token setiap 25 menit
  static Future<void> start() async {
    final isLogin = await globalAuthService.isLoggedIn();
    if (!isLogin) {
      print("User belum login, auto-refresh token tidak dijalankan.");
      return;
    }

    if (_timer?.isActive ?? false) {
      print("Auto-refresh token sudah berjalan.");
      return;
    }

    print("▶️ Memulai auto-refresh token setiap 25 menit...");
    _timer = Timer.periodic(const Duration(minutes: 25), (timer) async {
      final refreshed = await globalAuthService.refreshToken();
      if (refreshed) {
        print("Token berhasil diperbarui otomatis.");
      } else {
        print("Token gagal diperbarui otomatis. Mungkin user perlu login ulang.");
      }
    });
  }

  /// Hentikan auto-refresh token
  static void stop() {
    _timer?.cancel();
    _timer = null;
    print("⏹️ Auto-refresh token dihentikan.");
  }

  /// Cek apakah auto-refresh sedang berjalan
  static bool get isRunning => _timer?.isActive ?? false;
}
