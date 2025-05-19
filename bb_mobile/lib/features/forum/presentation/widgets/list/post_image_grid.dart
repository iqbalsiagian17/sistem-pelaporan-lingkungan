import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PostImageGrid extends StatelessWidget {
  final List<String> images;

  const PostImageGrid({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox(); // Jika tidak ada gambar, return kosong

    if (images.length == 1) {
      return _buildSingleImage(images[0]);
    } else if (images.length == 2) {
      return _buildTwoImages(images);
    } else {
      return _buildGridImages(images);
    }
  }

  Widget _buildSingleImage(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) => buildImageSkeleton(),
        errorWidget: (context, url, error) {
          debugPrint("❌ Gagal memuat gambar (single): $url");
          debugPrint("🪵 Detail error: $error");
          return const Icon(Icons.error, color: Colors.red);
        },
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }

  Widget _buildTwoImages(List<String> images) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: images.map((imageUrl) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (context, url) => buildImageSkeleton(),
                errorWidget: (context, url, error) {
                  debugPrint("❌ Gagal memuat gambar (two): $url");
                  debugPrint("🪵 Detail error: $error");
                  return const Icon(Icons.error, color: Colors.red);
                },
                fit: BoxFit.cover,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGridImages(List<String> images) {
    int maxVisibleImages = 4;
    bool showMoreOverlay = images.length > maxVisibleImages;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: showMoreOverlay ? maxVisibleImages : images.length,
      itemBuilder: (context, index) {
        if (showMoreOverlay && index == maxVisibleImages - 1) {
          return _buildMoreImagesOverlay(images[index], images.length - maxVisibleImages);
        }
        return CachedNetworkImage(
          imageUrl: images[index],
          placeholder: (context, url) => buildImageSkeleton(),
          errorWidget: (context, url, error) {
            debugPrint("❌ Gagal memuat gambar (grid): $url");
            debugPrint("🪵 Detail error: $error");
            return const Icon(Icons.error, color: Colors.red);
          },
          fit: BoxFit.cover,
        );
      },
    );
  }

  Widget _buildMoreImagesOverlay(String imageUrl, int remainingCount) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) => buildImageSkeleton(),
          errorWidget: (context, url, error) {
            debugPrint("❌ Gagal memuat gambar (overlay): $url");
            debugPrint("🪵 Detail error: $error");
            return const Icon(Icons.error, color: Colors.red);
          },
          fit: BoxFit.cover,
        ),
        Container(
          color: Colors.black.withOpacity(0.6),
          child: Center(
            child: Text(
              "+$remainingCount",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildImageSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        color: Colors.white,
      ),
    );
  }
}
