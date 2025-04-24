import 'package:bb_mobile/widgets/network/connection_listener_wrapper.dart';
import 'package:firebase_core/firebase_core.dart'; // 🔧 WAJIB Tambah
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:bb_mobile/injection.dart';
import 'package:bb_mobile/routes/app_routes.dart';
import 'package:bb_mobile/core/services/auth/auth_auto_refresh_service.dart';
import 'package:bb_mobile/core/services/auth/global_auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Inisialisasi Firebase terlebih dahulu
  await Firebase.initializeApp();

  final GoRouter router = AppRoutes.router;

  await globalAuthService.init(); // Inisialisasi userId
  await initializeDateFormatting('id_ID', null); // Format tanggal lokal

  // ✅ Ambil notifikasi dari terminated state (jika ada)
  final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  final initialRoute = initialMessage?.data['route'];

  await initializeDependencies(router);

  runApp(
    ProviderScope(
      child: ConnectionListenerWrapper(
        child: MyApp(initialRoute: initialRoute),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final String? initialRoute;
  const MyApp({super.key, this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // ✅ Navigasi ke halaman dari payload jika dibuka dari notifikasi
    if (widget.initialRoute != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppRoutes.router.go('/${widget.initialRoute}');
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
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
