import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/constants/api.dart';

class AnnouncementFilePreview extends StatelessWidget {
  final String? filePath;
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

    if (isImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          fileUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return SizedBox(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => Container(
            height: 200,
            color: Colors.grey[300],
            child: const Center(child: Icon(Icons.broken_image, size: 80, color: Colors.grey)),
          ),
        ),
      );
    }

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
              child: Text("File PDF tersedia untuk diunduh", style: TextStyle(fontSize: 14)),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final uri = Uri.parse(fileUrl);
                try {
                  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
                  if (!launched) throw Exception("Gagal membuka PDF");
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(" ${e.toString()}")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              icon: const Icon(Icons.download, color: Colors.white),
              label: const Text("Download", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
