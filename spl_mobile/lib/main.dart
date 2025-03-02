import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/routes/app_routes.dart';
import 'package:spl_mobile/providers/auth_provider.dart';
import 'package:spl_mobile/providers/user_password_provider.dart';
import 'package:spl_mobile/providers/user_profile_provider.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => UserPasswordProvider()),
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
