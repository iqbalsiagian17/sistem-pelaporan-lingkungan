import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spl_mobile/core/constants/api.dart';
import 'package:spl_mobile/widgets/skeleton/skeleton_image_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../providers/public/carousel_provider.dart';

const String kDefaultImage = "assets/images/slider_1.jpg";

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
    final provider = Provider.of<CarouselProvider>(context, listen: false);
    if (provider.carouselItems.isEmpty) {
      Future.microtask(() => provider.fetchCarousel());
    }
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
        if (carouselProvider.isLoading) return _carouselSkeleton();
        if (carouselProvider.errorMessage != null) {
          return Center(child: Text("❌ ${carouselProvider.errorMessage}"));
        }

        final carouselItems = carouselProvider.carouselItems;

        // Jika kosong, tampilkan default
        if (carouselItems.isEmpty) {
          return _buildCarousel(
            items: [
              _carouselCard(
                image: Image.asset(kDefaultImage, fit: BoxFit.cover),
                title: "Aduan Masyarakat",
                description: "Laporkan keluhan Anda dengan mudah.",
              ),
              _carouselCard(
                image: Image.asset(kDefaultImage, fit: BoxFit.cover),
                title: "Cepat Tanggap",
                description: "Petugas siap merespons aduan Anda 24/7.",
              ),
            ],
          );
        }

        // Tampilkan dari API
        return _buildCarousel(
          items: carouselItems.map((carousel) {
            return _carouselCard(
              image: CachedNetworkImage(
                imageUrl: "${ApiConstants.baseUrl}/${carousel.imageUrl}",
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (context, url) => _loadingPlaceholder(),
                errorWidget: (context, url, error) => Image.asset(kDefaultImage, fit: BoxFit.cover),
              ),
              title: carousel.title,
              description: carousel.description,
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildCarousel({required List<Widget> items}) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView(
            controller: _controller,
            children: items,
          ),
        ),
        const SizedBox(height: 12),
        SmoothPageIndicator(
          controller: _controller,
          count: items.length,
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

  Widget _carouselCard({
  required Widget image,
  required String title,
  required String description,
}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SizedBox(
        width: double.infinity,
        height: 180,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand, // ✅ Child expands to fill the available space
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
                child: image,
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
      ),
    );

}

Widget _loadingPlaceholder() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}
  Widget _carouselSkeleton() {
    return _buildCarousel(
      items: List.generate(2, (_) => const SkeletonImageCard()),
    );
  }
}
