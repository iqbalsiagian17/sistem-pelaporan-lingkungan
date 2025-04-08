import 'package:bb_mobile/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:bb_mobile/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🌐 Format tanggal lokal
  await initializeDateFormatting('id_ID', null);

  // 🚀 Init semua dependency
  await initializeDependencies();

  // 🟢 Jalankan App
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Balige Bersih',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF66BB6A)),
        useMaterial3: true,
      ),
      routerConfig: AppRoutes.router,
    );
  }
}
