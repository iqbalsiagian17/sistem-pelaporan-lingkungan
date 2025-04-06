import 'package:bb_mobile/features/forum/presentation/widgets/detail/full_screen_image_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:bb_mobile/features/forum/domain/entities/forum_image_entity.dart';

class ForumImageGrid extends StatefulWidget {
  final List<ForumImageEntity> images;

  const ForumImageGrid({super.key, required this.images});

  @override
  State<ForumImageGrid> createState() => _ForumImageGridState();
}

class _ForumImageGridState extends State<ForumImageGrid> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => _openImageViewer(context, _currentIndex),
      child: Stack(
        children: [
          SizedBox(
            height: 300,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: widget.images[index].imageUrl,
                    placeholder: (context, url) => _buildImageSkeleton(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, color: Colors.red),
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          if (widget.images.length > 1)
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    widget.images.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: _currentIndex == index ? 8 : 6,
                      height: _currentIndex == index ? 8 : 6,
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(_currentIndex == index ? 1.0 : 0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageSkeleton({double? borderRadius}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius != null
              ? BorderRadius.circular(borderRadius)
              : BorderRadius.zero,
        ),
      ),
    );
  }

  void _openImageViewer(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenImageSlider(
          images: widget.images,
          initialIndex: initialIndex,
        ),
      ),
    );
  }
}
