import 'package:flutter/material.dart';
import 'views/auth/login_view.dart'; // Pastikan file login_view.dart ada
import 'views/onboarding/onboarding_view.dart'; // Pastikan file onboarding_view.dart ada
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const BaligePeduliApp());
}

class BaligePeduliApp extends StatelessWidget {
  const BaligePeduliApp({super.key});

  Future<Widget> _determineStartScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final bool onboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;
    return onboardingCompleted ? const LoginView() : const OnboardingView();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Balige Peduli',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder<Widget>(
        future: _determineStartScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Loading sementara
          }
          return snapshot.data ?? const LoginView(); // Navigasi ke halaman yang sesuai
        },
      ),
    );
  }
}
