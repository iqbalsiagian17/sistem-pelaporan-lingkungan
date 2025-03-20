import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:provider/provider.dart';
import 'package:spl_mobile/models/Forum.dart';
import 'package:spl_mobile/providers/forum_provider.dart';
import 'package:spl_mobile/providers/auth_provider.dart';

class PostPopupMenu extends StatelessWidget {
  final ForumPost post;

  const PostPopupMenu({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
      future: Provider.of<AuthProvider>(context, listen: false).currentUserId,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data != post.user.id) {
          return const SizedBox(); // 🔹 Hanya tampilkan untuk pemilik postingan
        }

        return PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') {
              _showDeleteConfirmationSheet(context);
            }
          },
          icon: const Icon(Icons.more_vert, color: Colors.black),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Colors.white,
          elevation: 2,
          itemBuilder: (context) {
            return [
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: const [
                    Icon(Icons.delete_outline, color: Colors.red),
                    SizedBox(width: 10),
                    Text("Hapus Postingan"),
                  ],
                ),
              ),
            ];
          },
        );
      },
    );
  }

  /// **Konfirmasi Hapus Postingan**
  Future<void> _showDeleteConfirmationSheet(BuildContext context) async {
    HapticFeedback.mediumImpact();
    await showModalBottomSheet(
      context: context,
      isDismissible: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded, size: 50, color: Colors.redAccent),
              const SizedBox(height: 12),
              const Text(
                "Konfirmasi Hapus",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Apakah Anda yakin ingin menghapus postingan ini? Aksi ini tidak dapat dibatalkan.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.redAccent)),
                      child: const Text("Batal", style: TextStyle(color: Colors.redAccent)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                      onPressed: () async {
                        Navigator.pop(context);
                        await context.read<ForumProvider>().removePost(post.id);
                      },
                      child: const Text("Hapus", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
