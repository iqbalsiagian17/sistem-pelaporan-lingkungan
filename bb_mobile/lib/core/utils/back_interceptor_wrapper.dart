import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:go_router/go_router.dart';

class BackInterceptorWrapper extends StatefulWidget {
  final Widget child;

  /// Daftar route path yang akan pakai double-back untuk keluar
  final List<String> doubleBackRoutes;

  const BackInterceptorWrapper({
    super.key,
    required this.child,
    this.doubleBackRoutes = const ['/dashboard'],
  });

  @override
  State<BackInterceptorWrapper> createState() => _BackInterceptorWrapperState();
}

class _BackInterceptorWrapperState extends State<BackInterceptorWrapper> {
  DateTime? _lastBackPressed;

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(_onBackPressed);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(_onBackPressed);
    super.dispose();
  }

  bool _onBackPressed(bool stopDefaultButtonEvent, RouteInfo info) {
    final location = GoRouter.of(context).routeInformationProvider.value.uri.path;

    // ✅ Kalau masih bisa pop (hasil dari push), maka back normal saja
    if (Navigator.of(context).canPop()) return false;

    // ✅ Aktifkan double back hanya untuk halaman tertentu
    final isDoubleBackPage = widget.doubleBackRoutes.contains(location);
    if (!isDoubleBackPage) return false;

    final now = DateTime.now();
    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
      _lastBackPressed = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tekan sekali lagi untuk keluar"),
          duration: Duration(seconds: 2),
        ),
      );
      return true;
    }

    SystemNavigator.pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
