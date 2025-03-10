import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ReportDetailImage extends StatefulWidget {
  final List<String> imageUrls;

  const ReportDetailImage({super.key, required this.imageUrls});

  @override
  _ReportDetailImageState createState() => _ReportDetailImageState();
}

class _ReportDetailImageState extends State<ReportDetailImage> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔹 Carousel Gambar dengan Caching
        Padding(
          padding: const EdgeInsets.all(5),
          child: SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _controller, // ✅ Gunakan controller agar indikator bisa membaca posisi
              itemCount: widget.imageUrls.isNotEmpty ? widget.imageUrls.length : 1,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                String imageUrl = widget.imageUrls.isNotEmpty
                    ? widget.imageUrls[index]
                    : "assets/images/default.jpg";

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () => _showFullImageDialog(context, imageUrl), // 🔹 Klik untuk melihat gambar full
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Hero(
                        tag: imageUrl, // ✅ Gunakan Hero animation untuk transisi lebih smooth
                        child: imageUrl.startsWith("http")
                            ? CachedNetworkImage(
                                imageUrl: imageUrl,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                                progressIndicatorBuilder: (context, url, progress) {
                                  // ✅ Tampilkan loading HANYA jika gambar belum pernah dimuat
                                  if (progress.progress == null) return Container();
                                  return _loadingPlaceholder();
                                },
                                errorWidget: (context, url, error) => _defaultImage(),
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

        // 🔹 Indikator Posisi Gambar dengan SmoothPageIndicator
        if (widget.imageUrls.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SmoothPageIndicator(
              controller: _controller,
              count: widget.imageUrls.length,
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
          ),
      ],
    );
  }

  // 🔹 Fungsi untuk menampilkan gambar full-screen dengan caching
  void _showFullImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Hero(
          tag: imageUrl,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageUrl.startsWith("http")
                ? Image(
                    image: CachedNetworkImageProvider(imageUrl), // ✅ Caching agar tidak reload lagi
                    width: double.infinity,
                    height: 400,
                    fit: BoxFit.contain,
                  )
                : _defaultImage(),
          ),
        ),
      ),
    );
  }

  // 🔹 Placeholder saat gambar benar-benar masih loading
  Widget _loadingPlaceholder() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 1.5)),
    );
  }

  // 🔹 Gambar default jika tidak tersedia
  Widget _defaultImage() {
    return Image.asset(
      "assets/images/default.jpg",
      width: double.infinity,
      height: 200,
      fit: BoxFit.cover,
    );
  }
}
