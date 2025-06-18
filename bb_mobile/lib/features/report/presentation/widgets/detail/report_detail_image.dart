import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:bb_mobile/widgets/skeleton/skeleton_image_card.dart'; // pastikan ini ada

class ReportDetailImage extends StatefulWidget {
  final List<String> imageUrls;
  final int reportId;

  const ReportDetailImage({
    super.key,
    required this.imageUrls,
    required this.reportId,
  });

  @override
  State<ReportDetailImage> createState() => _ReportDetailImageState();
}

class _ReportDetailImageState extends State<ReportDetailImage> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.imageUrls.isNotEmpty ? widget.imageUrls.length : 1,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final imageUrl = widget.imageUrls.isNotEmpty
                    ? widget.imageUrls[index]
                    : "assets/images/default.jpg";

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () {
                      if (widget.imageUrls.length > 1) {
                        _showFullImageDialog(context, widget.imageUrls, index);
                      } else {
                        _showFullscreenZoomableImage(context, imageUrl);
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Hero(
                        tag: imageUrl,
                        child: imageUrl.startsWith("http")
                            ? CachedNetworkImage(
                                imageUrl: imageUrl,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => const SkeletonImageCard(
                                  height: 200,
                                  borderRadius: 12,
                                  margin: EdgeInsets.zero,
                                ),
                                errorWidget: (_, __, ___) => _defaultImage(),
                              )
                            : _defaultImage(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (widget.imageUrls.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SmoothPageIndicator(
              controller: _controller,
              count: widget.imageUrls.length,
              effect: const SwapEffect(
                dotHeight: 10,
                dotWidth: 10,
                spacing: 8,
                radius: 16,
                dotColor: Color(0xFFBDBDBD),
                activeDotColor: Color(0xFF66BB6A),
              ),
            ),
          ),
      ],
    );
  }

  void _showFullscreenZoomableImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.95),
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              Positioned.fill(
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 1,
                  maxScale: 5,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => _defaultImage(),
                  ),
                ),
              ),
              Positioned(
                top: 30,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.close, color: Colors.white, size: 24),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFullImageDialog(BuildContext context, List<String> imageUrls, int initialIndex) {
    final pageController = PageController(initialPage: initialIndex);
    int currentIndex = initialIndex;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.95),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.zero,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: pageController,
                    itemCount: imageUrls.length,
                    onPageChanged: (index) => setState(() => currentIndex = index),
                    itemBuilder: (context, index) {
                      final imageUrl = imageUrls[index];
                      return Center(
                        child: Hero(
                          tag: imageUrl,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 800, // 🔧 Batasi tinggi maksimum gambar
                            ),
                            child: InteractiveViewer(
                              panEnabled: true,
                              minScale: 1,
                              maxScale: 5,
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.contain,
                                placeholder: (context, url) =>
                                    const Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => _defaultImage(),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // Tombol close
                  Positioned(
                    top: 30,
                    right: 20,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.close, color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                  // Indikator halaman
                  if (imageUrls.length > 1)
                    Positioned(
                      bottom: 24,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${currentIndex + 1} / ${imageUrls.length}",
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  Widget _defaultImage() {
    return Image.asset(
      "assets/images/error-image.png",
      width: double.infinity,
      height: 200,
      fit: BoxFit.cover,
    );
  }
}
