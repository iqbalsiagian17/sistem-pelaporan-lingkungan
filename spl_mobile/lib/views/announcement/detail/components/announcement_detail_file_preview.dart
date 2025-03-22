import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:spl_mobile/core/constants/api.dart';

class AnnouncementFilePreview extends StatelessWidget {
  final String? filePath; // Gunakan filePath
  final bool isImage;

  const AnnouncementFilePreview({
    super.key,
    required this.filePath,
    required this.isImage,
  });

  @override
  Widget build(BuildContext context) {
    if (filePath == null) return const SizedBox.shrink();

    final fileUrl = "${ApiConstants.baseUrl}/$filePath";

    // ✅ Gambar
    if (isImage) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            fileUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return SizedBox(
                height: 200,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => Container(
              height: 200,
              color: Colors.grey[300],
              child: const Center(
                child: Icon(Icons.broken_image, size: 80, color: Colors.grey),
              ),
            ),
          ),
        ),
      );
    }

    // ✅ PDF (Tombol download)
    if (filePath!.toLowerCase().endsWith('.pdf')) {
      return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            const Icon(Icons.picture_as_pdf, color: Colors.red, size: 36),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                "File PDF tersedia untuk diunduh",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              icon: const Icon(Icons.download, color: Colors.white),
              label: const Text("Download", style: TextStyle(color: Colors.white)),
              onPressed: () async {
              final uri = Uri.parse(fileUrl);
              try {
                final launched = await launchUrl(
                  uri,
                  mode: LaunchMode.externalApplication, // arahkan ke browser
                );

                if (!launched) {
                  throw Exception("Gagal membuka PDF");
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("❌ ${e.toString()}")),
                );
              }
            },
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
