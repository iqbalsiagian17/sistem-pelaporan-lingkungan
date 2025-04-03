import 'package:bb_mobile/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

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

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;

    if (onboardingCompleted) {
      if (!mounted) return;
      context.go(AppRoutes.login);
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingCompleted', true);
    if (!mounted) return;
    context.go(AppRoutes.login);
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
    HapticFeedback.mediumImpact();
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
    final theme = Theme.of(context);
    return _isLoading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: onboardingData.length,
                      onPageChanged: (index) => setState(() => _currentIndex = index),
                      itemBuilder: (_, index) {
                        final item = onboardingData[index];
                        return Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  item["image"]!,
                                  height: 240,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 32),
                              Text(
                                item["title"]!,
                                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                item["description"]!,
                                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingData.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == index ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index ? Colors.green[600] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _currentIndex > 0
                            ? TextButton(onPressed: _goToPrevious, child: const Text("Kembali"))
                            : const SizedBox(width: 80),
                        FilledButton(
                          onPressed: _goToNext,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            backgroundColor: Colors.green[600],
                          ),
                          child: Text(
                            _currentIndex == onboardingData.length - 1 ? "Selesai" : "Selanjutnya",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
  }
}
