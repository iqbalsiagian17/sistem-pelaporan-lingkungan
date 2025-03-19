import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spl_mobile/models/ForumImage.dart';

class ForumImageGrid extends StatefulWidget {
  final List<ForumImage> images;

  const ForumImageGrid({super.key, required this.images});

  @override
  _ForumImageGridState createState() => _ForumImageGridState();
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
      onTap: () => _openImageViewer(context, _currentIndex), // ✅ Buka slide dari indeks saat ini
      child: Stack(
        children: [
          SizedBox(
            height: 300, // 🔹 Ukuran tetap seperti Instagram
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index); // ✅ Indikator diperbarui saat slide berubah
              },
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: widget.images[index].imageUrl,
                    placeholder: (context, url) => Container(
                      color: Colors.grey.shade300,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),

          // 🔹 **Indikator Titik-Titik (Jika Gambar Lebih Dari 1)**
          if (widget.images.length > 1)
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    widget.images.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200), // 🔹 Efek transisi halus
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: _currentIndex == index ? 8 : 6,
                      height: _currentIndex == index ? 8 : 6,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(_currentIndex == index ? 1.0 : 0.5),
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

  /// ✅ **Fungsi untuk membuka gambar dalam fullscreen mode seperti Instagram**
  void _openImageViewer(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageSlider(images: widget.images, initialIndex: initialIndex),
      ),
    );
  }
}

/// ✅ **Widget untuk Slide Gambar seperti Instagram**
class FullScreenImageSlider extends StatefulWidget {
  final List<ForumImage> images;
  final int initialIndex;

  const FullScreenImageSlider({super.key, required this.images, required this.initialIndex});

  @override
  _FullScreenImageSliderState createState() => _FullScreenImageSliderState();
}

class _FullScreenImageSliderState extends State<FullScreenImageSlider> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ✅ **Slide antar gambar**
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index; // ✅ Indikator berpindah saat slide diubah
              });
            },
            itemBuilder: (context, index) {
              return InteractiveViewer(
                minScale: 1.0,
                maxScale: 3.0, // 🔹 Bisa zoom hingga 3x
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: widget.images[index].imageUrl,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),

          // 🔙 **Tombol Kembali**
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // 🔹 **Indikator Posisi Slide (Seperti Instagram)**
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200), // 🔹 Efek transisi halus
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == index ? 10 : 6,
                  height: _currentIndex == index ? 10 : 6,
                  decoration: BoxDecoration(
                    color: _currentIndex == index ? Colors.white : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
