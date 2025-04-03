import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/core/constants/dio_client.dart';
import 'package:bb_mobile/core/services/auth/global_auth_service.dart';
import 'package:bb_mobile/routes/app_routes.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Geolocator.checkPermission();
  await Geolocator.requestPermission();


  // ✅ Inisialisasi Dio dengan interceptor
  await DioClient.initialize();

  // ✅ Refresh token saat aplikasi pertama kali dijalankan
  final refreshed = await globalAuthService.refreshToken();
  if (refreshed) {
    print("✅ Token berhasil diperbarui sebelum app dijalankan.");
  } else {
    print("⚠️ Token tidak bisa diperbarui, user mungkin harus login ulang.");
  }

  // ✅ Jalankan auto-refresh setiap 25 menit
  startAutoRefreshToken();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

/// ⏱️ Fungsi untuk refresh token berkala
void startAutoRefreshToken() {
  Timer.periodic(const Duration(minutes: 25), (timer) async {
    final refreshed = await globalAuthService.refreshToken();
    if (!refreshed) {
      print("❌ Token gagal diperbarui. User mungkin perlu login ulang.");
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRoutes.router,
      debugShowCheckedModeBanner: false,
      title: 'Balige Bersih',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
    );
  }
}
