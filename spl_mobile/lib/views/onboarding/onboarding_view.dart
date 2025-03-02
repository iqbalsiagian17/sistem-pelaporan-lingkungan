import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import '../../routes/app_routes.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _isLoading = true;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Aplikasi Balige Bersih",
      "description": "Laporkan permasalahan sampah di sekitar Balige.",
      "image": "assets/images/onboarding/apk.jpg",
    },
    {
      "title": "Cepat Tanggap",
      "description": "Laporkan tumpukan sampah dan pembuangan liar.",
      "image": "assets/images/onboarding/cepat.jpg",
    },
    {
      "title": "Aduan Tuntas",
      "description": "Pantau laporan sampah Anda hingga tuntas.",
      "image": "assets/images/onboarding/tuntas.jpg",
    },
    {
      "title": "Panggilan Darurat",
      "description": "Atasi keadaan darurat dengan satu klik.",
      "image": "assets/images/onboarding/darurat.jpg",
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  /// **🔹 Cek apakah onboarding sudah selesai sebelumnya**
  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;

    if (onboardingCompleted) {
      if (!mounted) return;
      context.go(AppRoutes.login); // ✅ Langsung ke halaman login jika sudah selesai
    } else {
      setState(() {
        _isLoading = false; // ✅ Tampilkan halaman onboarding jika belum selesai
      });
    }
  }

  /// **🔹 Tandai onboarding selesai dan navigasi ke login**
  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingCompleted', true);

    if (!mounted) return;
    context.go(AppRoutes.login); // ✅ Navigasi ke halaman login setelah selesai
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
    return _isLoading
        ? const Scaffold(
            body: Center(child: CircularProgressIndicator()), // ✅ Tampilkan loading jika masih mengecek status
          )
        : Scaffold(
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
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                      _currentIndex > 0
                          ? TextButton(
                              onPressed: _goToPrevious,
                              child: const Text("Kembali",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
                            )
                          : const SizedBox(width: 70),
                      TextButton(
                        onPressed: _goToNext,
                        child: Text(
                          _currentIndex == onboardingData.length - 1 ? "Selesai" : "Selanjutnya",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
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
