import 'package:geolocator/geolocator.dart';
import 'package:bb_mobile/core/constants/dio_client.dart';
import 'package:bb_mobile/core/services/auth/global_auth_service.dart';
import 'package:bb_mobile/core/services/auth/auth_auto_refresh_service.dart'; // ⬅️ Tambahkan ini
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
  await AuthAutoRefreshService.start();
}
