import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'widgets/blur_wrapper.dart';

void main() {
  runApp(const BaligePeduliApp());
}

class BaligePeduliApp extends StatelessWidget {
  const BaligePeduliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Balige Peduli',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: AppRoutes.router,
      builder: (context, child) => BlurWrapper(child: child!), // Gunakan BlurWrapper di sini
    );
  }
}
