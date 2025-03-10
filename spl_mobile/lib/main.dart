import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:spl_mobile/routes/app_routes.dart';
import 'package:spl_mobile/providers/auth_provider.dart';
import 'package:spl_mobile/providers/user_profile_provider.dart';
import 'package:spl_mobile/providers/user_report_provider.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();

  await Geolocator.checkPermission();
  await Geolocator.requestPermission();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (context) => ReportProvider()),

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
