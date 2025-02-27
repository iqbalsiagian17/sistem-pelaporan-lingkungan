import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarouselBanner extends StatefulWidget {
  const CarouselBanner({super.key});

  @override
  State<CarouselBanner> createState() => _CarouselBannerState();
}

class _CarouselBannerState extends State<CarouselBanner> {
  final PageController _controller = PageController(viewportFraction: 1.0);

  @override
  void dispose() {
    _controller.dispose(); // ✅ Hindari memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔄 Carousel
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _controller,
            itemCount: 2,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      ShaderMask(
                        shaderCallback: (rect) => LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.7),
                          ],
                        ).createShader(rect),
                        blendMode: BlendMode.darken,
                        child: Image.asset(
                          'assets/images/slider_1.jpg',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              index == 0 ? 'Kanal Aduan Masyarakat' : 'Cepat Tanggap',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              index == 0
                                  ? 'Laporkan keluhan Anda dengan mudah dan cepat.'
                                  : 'Petugas siap merespons aduan Anda 24/7.',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        // 🔘 Indikator titik-titik di bawah carousel
        SmoothPageIndicator(
          controller: _controller,
          count: 2,
          effect: const ExpandingDotsEffect(
            dotHeight: 10,
            dotWidth: 10,
            spacing: 8,
            radius: 16,
            dotColor: Colors.grey,
            activeDotColor: Color(0xFF1976D2), // ✅ Warna aktif sesuai tema
            expansionFactor: 4,
          ),
        ),
      ],
    );
  }
}
