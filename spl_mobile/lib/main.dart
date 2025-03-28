import 'dart:async'; // ✅ Tambahkan ini
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:spl_mobile/core/services/auth/auth_service.dart';
import 'package:spl_mobile/providers/notification/user_notification_provider.dart';
import 'package:spl_mobile/providers/public/announcement_provider.dart';
import 'package:spl_mobile/providers/auth/google_auth_provider.dart';
import 'package:spl_mobile/providers/public/carousel_provider.dart';
import 'package:spl_mobile/providers/forum/forum_provider.dart';
import 'package:spl_mobile/providers/public/parameter_provider.dart';
import 'package:spl_mobile/providers/report/report_save_provider.dart';
import 'package:spl_mobile/providers/forum/forum_likes_provider.dart';
import 'package:spl_mobile/providers/report/report_likes_provider.dart';
import 'package:spl_mobile/routes/app_routes.dart';
import 'package:spl_mobile/providers/auth/auth_provider.dart';
import 'package:spl_mobile/providers/user/user_profile_provider.dart';
import 'package:spl_mobile/providers/report/report_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await Geolocator.checkPermission();
  await Geolocator.requestPermission();

  /// ✅ Pastikan token terbaru digunakan sebelum menjalankan aplikasi
  AuthService authService = AuthService();
  bool refreshed = await authService.refreshToken();

  if (refreshed) {
    print("✅ Token diperbarui sebelum aplikasi dimulai.");
  } else {
    print("⚠️ Tidak bisa refresh token, user mungkin perlu login ulang.");
  }

  /// ✅ Jalankan auto refresh token setiap 25 menit
  startAutoRefreshToken(authService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => CarouselProvider()),
        ChangeNotifierProvider(create: (_) => ReportSaveProvider()),
        ChangeNotifierProvider(create: (_) => ReportLikeProvider()),
        ChangeNotifierProvider(create: (_) => ForumProvider()), // ✅ Pastikan ini ada
        ChangeNotifierProvider(create: (_) => PostLikeProvider()),
        ChangeNotifierProvider(create: (_) => AuthGoogleProvider()),
        ChangeNotifierProvider(create: (_) => AnnouncementProvider()),
        ChangeNotifierProvider(create: (_) => ParameterProvider()),
        ChangeNotifierProvider(create: (_) => UserNotificationProvider()),
      ],
      child: const BaligePeduliApp(),
    ),
  );
}

/// ✅ Fungsi untuk Auto Refresh Token Setiap 25 Menit
void startAutoRefreshToken(AuthService authService) {
  Timer.periodic(const Duration(minutes: 25), (timer) async {
    bool refreshed = await authService.refreshToken();
    if (!refreshed) {
      print("❌ Token gagal diperbarui, user mungkin harus login ulang.");
    }
  });
}

class BaligePeduliApp extends StatelessWidget {
  const BaligePeduliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Balige Peduli App',
      routerConfig: AppRoutes.router, // ✅ Gunakan router dari AppRoutes langsung
    );
  }
}
