import 'dart:async';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:spl_mobile/core/constants/dio_client.dart';
import 'package:spl_mobile/core/services/auth/global_auth_service.dart';
import 'package:spl_mobile/core/services/firebase/firebase_messaging_helper.dart';
import 'package:spl_mobile/core/utils/app_lifecycle_manager.dart';
import 'package:spl_mobile/providers/auth/auth_provider.dart';
import 'package:spl_mobile/providers/auth/google_auth_provider.dart';
import 'package:spl_mobile/providers/forum/forum_likes_provider.dart';
import 'package:spl_mobile/providers/forum/forum_provider.dart';
import 'package:spl_mobile/providers/notification/user_notification_provider.dart';
import 'package:spl_mobile/providers/public/announcement_provider.dart';
import 'package:spl_mobile/providers/public/carousel_provider.dart';
import 'package:spl_mobile/providers/public/parameter_provider.dart';
import 'package:spl_mobile/providers/report/report_likes_provider.dart';
import 'package:spl_mobile/providers/report/report_provider.dart';
import 'package:spl_mobile/providers/report/report_save_provider.dart';
import 'package:spl_mobile/providers/user/user_profile_provider.dart';
import 'package:spl_mobile/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioClient.initialize();

  await initializeDateFormatting('id_ID', null);
  await Geolocator.checkPermission();
  await Geolocator.requestPermission();


  // ✅ Setup Firebase Messaging
  await setupFirebaseMessaging();

  // ✅ Coba refresh token sebelum app berjalan
  final refreshed = await globalAuthService.refreshToken();
  if (refreshed) {
    print("✅ Token berhasil diperbarui sebelum app dijalankan.");
  } else {
    print("⚠️ Token tidak bisa diperbarui, user mungkin harus login ulang.");
  }

  // ✅ Jalankan auto-refresh setiap 25 menit
  startAutoRefreshToken();

  runApp(const BaligePeduliApp());
}

void startAutoRefreshToken() {
  Timer.periodic(const Duration(minutes: 25), (timer) async {
    final refreshed = await globalAuthService.refreshToken();
    if (!refreshed) {
      print("❌ Token gagal diperbarui. User mungkin perlu login ulang.");
    }
  });
}

class BaligePeduliApp extends StatelessWidget {
  const BaligePeduliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AuthGoogleProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => CarouselProvider()),
        ChangeNotifierProvider(create: (_) => ReportSaveProvider()),
        ChangeNotifierProvider(create: (_) => ReportLikeProvider()),
        ChangeNotifierProvider(create: (_) => ForumProvider()),
        ChangeNotifierProvider(create: (_) => PostLikeProvider()),
        ChangeNotifierProvider(create: (_) => AnnouncementProvider()),
        ChangeNotifierProvider(create: (_) => ParameterProvider()),
        ChangeNotifierProvider(create: (_) => UserNotificationProvider()),
      ],
      child: AppLifecycleManager( // ✅ Bungkus MaterialApp.router
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Balige Peduli App',
          routerConfig: AppRoutes.router,
        ),
      ),
    );
  }
}
