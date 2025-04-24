import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:bb_mobile/core/constants/dio_client.dart';
import 'package:bb_mobile/core/services/auth/global_auth_service.dart';
import 'package:bb_mobile/core/services/auth/auth_auto_refresh_service.dart';
import 'package:bb_mobile/core/services/firebase/firebase_messaging_helper.dart';

/// Inisialisasi semua dependency sebelum runApp
Future<void> initializeDependencies(GoRouter router) async {
  // 🔐 Izin lokasi
  await Geolocator.checkPermission();
  await Geolocator.requestPermission();

  // 🔧 Setup Dio
  await DioClient.initialize();

  // 🔔 Setup Firebase Messaging + navigasi berdasarkan notifikasi
  await setupFirebaseMessaging(router);

  // 🔄 Refresh token
  final refreshed = await globalAuthService.refreshToken();
  if (refreshed) {
    print("✅ Token berhasil diperbarui sebelum app dijalankan.");
  } else {
    print("⚠️ Token tidak bisa diperbarui, user mungkin harus login ulang.");
  }

  // 🔁 Setup auto-refresh token
  await AuthAutoRefreshService.start();
}
