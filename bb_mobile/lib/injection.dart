import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:bb_mobile/core/constants/dio_client.dart';
import 'package:bb_mobile/core/services/auth/global_auth_service.dart';
import 'package:bb_mobile/core/services/firebase/firebase_messaging_helper.dart';

/// Inisialisasi semua dependency sebelum runApp
Future<void> initializeDependencies() async {
  // 🔐 Izin lokasi (wajib sebelum app jalan)
  await Geolocator.checkPermission();
  await Geolocator.requestPermission();

  // 🔧 Inisialisasi Dio
  await DioClient.initialize();

  // 🔔 Setup Firebase Messaging (Notifikasi)
  await setupFirebaseMessaging();

  // 🔄 Refresh token di awal (untuk auto login)
  final refreshed = await globalAuthService.refreshToken();
  if (refreshed) {
    print("✅ Token berhasil diperbarui sebelum app dijalankan.");
  } else {
    print("⚠️ Token tidak bisa diperbarui, user mungkin harus login ulang.");
  }

  // 🔁 Setup auto-refresh token setiap 25 menit
  _startAutoRefreshToken();
}

/// Fungsi auto-refresh token (setiap 25 menit)
void _startAutoRefreshToken() {
  Timer.periodic(const Duration(minutes: 25), (timer) async {
    final refreshed = await globalAuthService.refreshToken();
    if (!refreshed) {
      print("❌ Token gagal diperbarui. User mungkin perlu login ulang.");
    }
  });
}

void startAutoRefreshToken() {
  Timer.periodic(const Duration(minutes: 25), (timer) async {
    final refreshed = await globalAuthService.refreshToken();
    if (!refreshed) {
      print(" Token gagal diperbarui. User mungkin perlu login ulang.");
    }
  });
}
