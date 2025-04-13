import 'package:bb_mobile/features/dashboard/presentation/provider/media_carousel_provider.dart';
import 'package:bb_mobile/widgets/skeleton/skeleton_image_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

const String kDefaultImage = "assets/images/slider_1.jpg";

class MediaCarouselBanner extends ConsumerStatefulWidget {
  const MediaCarouselBanner({super.key});

  @override
  ConsumerState<MediaCarouselBanner> createState() => _MediaCarouselBannerState();
}

class _MediaCarouselBannerState extends ConsumerState<MediaCarouselBanner> {
  final PageController _controller = PageController(viewportFraction: 1.0);

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(mediaCarouselProvider.notifier).fetchMediaCarousels());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mediaCarouselProvider);

    if (state.isLoading) return _carouselSkeleton();
    if (state.error != null) {
      return Center(child: Text(" ${state.error}"));
    }

    final items = state.data;

    if (items.isEmpty) {
      return _buildCarousel(items: [
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
      ]);
    }

    return _buildCarousel(
      items: items.map((carousel) {
        return GestureDetector(
          onTap: () {
            _showImageDetail(
              context,
              imageUrl: carousel.imageUrl,
              title: carousel.title,
              description: carousel.description,
            );
          },
          child: _carouselCard(
            image: CachedNetworkImage(
              imageUrl: carousel.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder: (context, url) => _loadingPlaceholder(),
              errorWidget: (context, url, error) =>
                  Image.asset(kDefaultImage, fit: BoxFit.cover),
            ),
            title: carousel.title,
            description: carousel.description,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCarousel({required List<Widget> items}) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView(controller: _controller, children: items),
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
            fit: StackFit.expand,
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

  Widget _carouselSkeleton() {
    return _buildCarousel(
      items: List.generate(2, (_) => const SkeletonImageCard()),
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

  void _showImageDetail(
  BuildContext context, {
  required String imageUrl,
  required String title,
  required String description,
  }) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.5,
                placeholder: (context, url) => _loadingPlaceholder(),
                errorWidget: (context, url, error) =>
                    Image.asset(kDefaultImage, fit: BoxFit.cover),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
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
                    const SizedBox(height: 6),
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
            ),
          ],
        ),
      ),
    );
  }
}
