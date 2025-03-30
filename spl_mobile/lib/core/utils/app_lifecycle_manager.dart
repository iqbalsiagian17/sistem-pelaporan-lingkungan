import 'package:flutter/material.dart';
import 'package:spl_mobile/core/services/auth/global_auth_service.dart';

class AppLifecycleManager extends StatefulWidget {
  final Widget child;

  const AppLifecycleManager({Key? key, required this.child}) : super(key: key);

  @override
  State<AppLifecycleManager> createState() => _AppLifecycleManagerState();
}

class _AppLifecycleManagerState extends State<AppLifecycleManager> with WidgetsBindingObserver {
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
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      print("🔄 Aplikasi kembali aktif. Cek dan refresh token...");
      final refreshed = await globalAuthService.refreshToken();
      if (!refreshed) {
        print("❌ Token gagal diperbarui. User mungkin perlu login ulang.");
      } else {
        print("✅ Token berhasil diperbarui saat resume.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
