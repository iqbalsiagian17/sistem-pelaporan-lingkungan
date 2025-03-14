import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../providers/carousel_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CarouselBanner extends StatefulWidget {
  const CarouselBanner({super.key});

  @override
  State<CarouselBanner> createState() => _CarouselBannerState();
}

class _CarouselBannerState extends State<CarouselBanner> {
  final PageController _controller = PageController(viewportFraction: 1.0);

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<CarouselProvider>(context, listen: false).fetchCarousel());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CarouselProvider>(
      builder: (context, carouselProvider, child) {
        if (carouselProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (carouselProvider.errorMessage != null) {
          return Center(child: Text("❌ ${carouselProvider.errorMessage}"));
        }

        final carouselItems = carouselProvider.carouselItems;

        // **Jika data kosong, tampilkan slider default**
        if (carouselItems.isEmpty) {
          return _defaultCarousel();
        }

        return Column(
          children: [
            // 🔄 Carousel
            SizedBox(
              height: 180,
              child: PageView.builder(
                controller: _controller,
                itemCount: carouselItems.length,
                itemBuilder: (context, index) {
                  final carousel = carouselItems[index];

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
                            child: CachedNetworkImage(
                              imageUrl: "http://localhost:3000/${carousel.imageUrl}",
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => _loadingPlaceholder(),
                              errorWidget: (context, url, error) => _defaultImage(),
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
                                  carousel.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  carousel.description,
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
              count: carouselItems.length,
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
      },
    );
  }

  // **🟢 Carousel Default Jika Data Kosong**
  Widget _defaultCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView(
            controller: _controller,
            children: [
              _defaultCarouselItem("Aduan Masyarakat", "Laporkan keluhan Anda dengan mudah."),
              _defaultCarouselItem("Cepat Tanggap", "Petugas siap merespons aduan Anda 24/7."),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SmoothPageIndicator(
          controller: _controller,
          count: 2, // ✅ Sesuaikan dengan jumlah default items
          effect: const ExpandingDotsEffect(
            dotHeight: 10,
            dotWidth: 10,
            spacing: 8,
            radius: 16,
            dotColor: Colors.grey,
            activeDotColor: Color(0xFF1976D2),
            expansionFactor: 4,
          ),
        ),
      ],
    );
  }

  // **🟢 Item Default untuk Carousel**
  Widget _defaultCarouselItem(String title, String description) {
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
                "assets/images/slider_1.jpg",
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
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
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
  }

  Widget _loadingPlaceholder() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 1.5)),
    );
  }

  Widget _defaultImage() {
    return Image.asset(
      "assets/images/slider_1.jpg",
      width: double.infinity,
      height: 180,
      fit: BoxFit.cover,
    );
  }
}
