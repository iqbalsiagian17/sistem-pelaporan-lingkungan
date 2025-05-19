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
    _pageController = PageController(); // Full width, no padding
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        GestureDetector(
          onTap: () => _openImageViewer(context, _currentIndex),
          child: SizedBox(
            height: 300,
            width: double.infinity,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(0), // or keep 14 if needed
                  child: CachedNetworkImage(
                    imageUrl: widget.images[index].imageUrl,
                    placeholder: (context, url) => _buildImageSkeleton(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, color: Colors.red),
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  ),
                );
              },
            ),
          ),
        ),
        if (widget.images.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == index ? 10 : 8,
                  height: _currentIndex == index ? 10 : 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? Colors.green
                        : Colors.grey.shade400,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImageSkeleton({double? borderRadius}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius ?? 0),
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
