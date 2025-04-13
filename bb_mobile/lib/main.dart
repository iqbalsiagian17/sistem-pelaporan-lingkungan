import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:bb_mobile/injection.dart';
import 'package:bb_mobile/routes/app_routes.dart';
import 'package:bb_mobile/core/services/auth/auth_auto_refresh_service.dart'; // ⬅️ Tambahkan
import 'package:bb_mobile/core/services/auth/global_auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await globalAuthService.init(); // <-- wajib agar userId tersedia


  // 🌐 Format tanggal lokal
  await initializeDateFormatting('id_ID', null);

  // 🚀 Init semua dependency
  await initializeDependencies();

  // 🟢 Jalankan App
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("🔄 App resumed, cek token & auto refresh");
      globalAuthService.refreshToken();
      AuthAutoRefreshService.start();
    }
  }

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
