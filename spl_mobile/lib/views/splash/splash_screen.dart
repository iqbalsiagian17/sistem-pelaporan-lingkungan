import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // ✅ Animasi Fade-In untuk tampilan lebih modern
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200), // Animasi masuk 1.2 detik
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2)); // ⏳ Tahan splash selama 2 detik

    final prefs = await SharedPreferences.getInstance();
    bool onboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // ✅ Efek Fade-Out sebelum pindah halaman
    if (mounted) {
      await _controller.reverse(); // 🔥 Fade out animasi sebelum pindah
    }

    if (!onboardingCompleted) {
      if (mounted) context.go(AppRoutes.onboarding);
    } else if (!isLoggedIn) {
      if (mounted) context.go(AppRoutes.login);
    } else {
      if (mounted) context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation, // ✅ Efek fade in & fade out
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF81C784)], // ✅ Gradient hijau modern
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // ✅ **Teks #BaligeBersih lebih profesional**
              const Text(
                "#BaligeBersih",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30, // ✅ Ukuran lebih kecil
                  fontWeight: FontWeight.w600, // ✅ Semi-bold agar lebih elegan
                  letterSpacing: 1.2, // ✅ Spasi antar huruf agar lebih profesional
                ),
              ),

              const Spacer(),

              // ✅ **Logo + Tulisan "DINAS LINGKUNGAN HIDUP TOBA" dengan Opacity**
              Opacity(
                opacity: 0.9, // ✅ Sedikit transparan agar lebih soft
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/logo.png", width: 45), // ✅ Logo sedikit lebih kecil
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "DINAS LINGKUNGAN HIDUP",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12, // ✅ Lebih kecil agar tidak mendominasi
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "TOBA",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ✅ **Versi Aplikasi lebih kecil & tidak mengganggu layout**
              const Text(
                "Versi 1.0.0",
                style: TextStyle(
                  color: Colors.white70, // ✅ Warna lebih soft
                  fontSize: 11, // ✅ Lebih kecil agar tidak mengganggu
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
