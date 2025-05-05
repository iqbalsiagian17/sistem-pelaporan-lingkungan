import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:bb_mobile/widgets/skeleton/skeleton_image_card.dart'; // Pastikan file ini ada

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
                    onTap: () => _showFullImageDialog(context, imageUrl),
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
                dotColor: Colors.grey,
                activeDotColor: Color(0xFF1976D2),
              ),
            ),
          ), 
      ],
    );
  }

  void _showFullImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            Hero(
              tag: imageUrl,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image(
                  image: CachedNetworkImageProvider(imageUrl),
                  width: double.infinity,
                  height: 400,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.close, color: Colors.white, size: 22),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  Widget _defaultImage() {
    return Image.asset(
      "assets/images/default.jpg",
      width: double.infinity,
      height: 200,
      fit: BoxFit.cover,
    );
  }
}
