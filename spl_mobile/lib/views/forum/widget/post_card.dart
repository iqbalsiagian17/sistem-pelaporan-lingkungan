import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/core/utils/date_utils.dart';
import 'package:spl_mobile/models/Forum.dart';
import 'package:spl_mobile/providers/forum_provider.dart';
import 'package:spl_mobile/views/forum/detail/forum_detail_view.dart';

class PostCard extends StatelessWidget {
  final ForumPost post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForumDetailView(post: post)),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 **Header (Profil & Menu)**
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color.fromARGB(255, 34, 143, 90),
                  child: Text(
                    post.user.username[0].toUpperCase(),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),

                // **Username & Time**
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.user.username,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        "• ${DateUtilsCustom.timeAgo(DateTime.parse(post.createdAt))}", // ✅ Ubah ke DateTime
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ],
                  ),
                ),

                // 🔥 **Tombol Menu Tiga Titik**
                _buildPopupMenu(context),
              ],
            ),

            // 🔹 **Konten Post**
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 6),
              child: Text(
                post.content,
                style: const TextStyle(fontSize: 16),
              ),
            ),

            // 🔹 **Tampilkan Gambar jika Ada**
            if (post.images.isNotEmpty) _buildImageLayout(post.images.map((img) => img.imageUrl).toList()),

            // 🔹 **Aksi (Like, Comment, Share, View)**
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start, // ✅ Rata kiri
                children: [
                  // 🔹 **Komentar**
                  InkWell(
                    onTap: () {
                      // TODO: Tambahkan aksi ketika tombol komentar ditekan
                    },
                    child: _buildIconWithText(Icons.mode_comment_outlined, "${post.comments.length}"),
                  ),
                  const SizedBox(width: 20), // ✅ Jarak antar ikon

                  // 🔹 **Like**
                  InkWell(
                    onTap: () {
                      // TODO: Tambahkan aksi ketika tombol Like ditekan
                    },
                    child: _buildIconWithText(Icons.favorite_border, "0"), // Simulasi jumlah Like
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 **Tampilkan Menu Tiga Titik**
Widget _buildPopupMenu(BuildContext context) {
  return PopupMenuButton<String>(
    onSelected: (value) {
      if (value == 'delete') {
        _showDeleteConfirmationSheet(context);
      }
    },
    icon: const Icon(Icons.more_vert, color: Colors.black), // 🔹 Ikon tiga titik modern
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // 🔹 Lebih smooth
    ),
    color: Colors.white, // 🔹 Background putih
    elevation: 2, // 🔹 Tambahkan sedikit shadow
    itemBuilder: (context) => [
      PopupMenuItem<String>(
        value: 'delete',
        child: Row(
          children: [
            const Icon(Icons.delete_outline, color: Colors.red), // 🔥 Ikon Hapus
            const SizedBox(width: 10),
            const Text("Hapus Postingan"),
          ],
        ),
      ),
    ],
  );
}


  /// ⚠ **Konfirmasi Hapus Postingan**
  void _showDeleteConfirmationSheet(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Konfirmasi Hapus"),
          content: const Text("Apakah Anda yakin ingin menghapus postingan ini?"),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () => Navigator.pop(dialogContext),
            ),
            TextButton(
              child: const Text("Hapus", style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.pop(dialogContext);
                await context.read<ForumProvider>().removePost(post.id);
              },
            ),
          ],
        );
      },
    );
  }

  /// 📌 **Tampilkan Gambar Seperti Twitter/Instagram**
  Widget _buildImageLayout(List<String> images) {
    if (images.length == 1) {
      return _buildSingleImage(images[0]);
    } else if (images.length == 2) {
      return _buildTwoImages(images);
    } else {
      return _buildGridImages(images);
    }
  }

  /// 📌 **1 Gambar (Full Width)**
  Widget _buildSingleImage(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }

  /// 📌 **2 Gambar (Dua Kolom)**
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
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                fit: BoxFit.cover,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 📌 **3+ Gambar (Grid 3x3)**
  Widget _buildGridImages(List<String> images) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Bisa 3 jika lebih banyak gambar
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: images.length > 4 ? 4 : images.length, // Batasi ke 4 gambar
      itemBuilder: (context, index) {
        return CachedNetworkImage(
          imageUrl: images[index],
          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
          fit: BoxFit.cover,
        );
      },
    );
  }

  /// 📌 **Ikon dengan Text (Aksi)**
  Widget _buildIconWithText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade700),
        const SizedBox(width: 5),
        Text(text, style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
      ],
    );
  }
}
