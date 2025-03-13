import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spl_mobile/core/services/auth/auth_service.dart';
import 'package:spl_mobile/routes/app_routes.dart';
import 'package:spl_mobile/providers/auth_provider.dart';
import 'package:spl_mobile/providers/user_profile_provider.dart';
import 'package:spl_mobile/providers/user_report_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Geolocator.checkPermission();
  await Geolocator.requestPermission();

  /// ✅ Pastikan token terbaru digunakan sebelum menjalankan aplikasi
  final prefs = await SharedPreferences.getInstance();
  AuthService authService = AuthService();

  bool refreshed = await authService.refreshToken(); // ✅ Refresh token sebelum menjalankan aplikasi

  if (refreshed) {
    print("✅ Token diperbarui sebelum aplikasi dimulai.");
  } else {
    print("⚠️ Tidak bisa refresh token, user mungkin perlu login ulang.");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
      ],
      child: const BaligePeduliApp(),
    ),
  );


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
      ],
      child: const BaligePeduliApp(),
    ),
  );
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
