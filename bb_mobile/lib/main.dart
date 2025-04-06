import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:bb_mobile/core/constants/dio_client.dart';
import 'package:bb_mobile/core/services/auth/global_auth_service.dart';
import 'package:bb_mobile/core/services/firebase/firebase_messaging_helper.dart';
import 'package:bb_mobile/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🗓️ Inisialisasi format tanggal lokal
  await initializeDateFormatting('id_ID', null);

  // 🗺️ Perizinan lokasi
  await Geolocator.checkPermission();
  await Geolocator.requestPermission();

  // ✅ Setup FCM
  await setupFirebaseMessaging();

  // ✅ Init Dio
  await DioClient.initialize();

  // ✅ Refresh token di awal
  final refreshed = await globalAuthService.refreshToken();
  if (refreshed) {
    print("✅ Token berhasil diperbarui sebelum app dijalankan.");
  } else {
    print("⚠️ Token tidak bisa diperbarui, user mungkin harus login ulang.");
  }

  // 🔄 Refresh token berkala
  startAutoRefreshToken();

  // 🚀 Jalankan App
  runApp(const ProviderScope(child: MyApp()));
}

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
      debugShowCheckedModeBanner: false,
      title: 'Balige Bersih',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      routerConfig: AppRoutes.router,
    );
  }
}
