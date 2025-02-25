import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/login_view.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Aplikasi Balige Bersih",
      "description": "Laporkan permasalahan sampah di sekitar Balige. Bersama kita wujudkan lingkungan yang bersih, sehat, dan nyaman.",
      "image": "assets/images/onboarding/apk.jpg",
    },
    {
      "title": "Cepat Tanggap",
      "description": "Laporkan tumpukan sampah, tong sampah penuh, atau pembuangan liar. Kami siap menindaklanjuti secara cepat dan tepat.",
      "image": "assets/images/onboarding/cepat.jpg",
    },
    {
      "title": "Aduan Tuntas",
      "description": "Setiap laporan sampah Anda adalah prioritas kami. Pantau prosesnya hingga masalah terselesaikan.",
      "image": "assets/images/onboarding/tuntas.jpg",
    },
    {
      "title": "Panggilan Darurat",
      "description": "Satu Klik untuk mudah dalam atasi keadaan darurat. Dimanapun dan kapanpun.",
      "image": "assets/images/onboarding/darurat.jpg",
    },
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingCompleted', true);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginView()),
    );
  }

  void _goToPrevious() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNext() {
    if (_currentIndex < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: onboardingData.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (_, index) => Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      onboardingData[index]["image"]!,
                      height: 250,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      onboardingData[index]["title"]!,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      onboardingData[index]["description"]!,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              onboardingData.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentIndex == index ? 12 : 8,
                height: _currentIndex == index ? 12 : 8,
                decoration: BoxDecoration(
                  color: _currentIndex == index ? Colors.blue : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 🔙 Tombol "Kembali" (tidak muncul di halaman pertama)
                _currentIndex > 0
                    ? GestureDetector(
                        onTap: _goToPrevious,
                        child: const Text(
                          "Kembali",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      )
                    : const SizedBox(width: 70), // Placeholder agar rata

                // Tombol "Selanjutnya" atau "Selesai"
                GestureDetector(
                  onTap: _goToNext,
                  child: Text(
                    _currentIndex == onboardingData.length - 1
                        ? "Selesai"
                        : "Selanjutnya",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
