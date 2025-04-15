import 'dart:io';

import 'package:bb_mobile/features/forum/domain/entities/forum_post_entity.dart';
import 'package:bb_mobile/features/forum/presentation/providers/forum_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class EditPostModal extends ConsumerStatefulWidget {
  final ForumPostEntity post;

  const EditPostModal({super.key, required this.post});

  @override
  ConsumerState<EditPostModal> createState() => _EditPostModalState();
}

class _EditPostModalState extends ConsumerState<EditPostModal> {
  late TextEditingController _contentController;
  late List<File> _selectedImages;
  late List<String> _existingImages;

  bool _isLoading = false;
  static const int _maxImages = 5;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.post.content);
    _selectedImages = [];
    _existingImages = widget.post.images.map((e) => e.imageUrl).toList();
  }

  Future<void> _pickImage() async {
    if (_selectedImages.length + _existingImages.length >= _maxImages) {
      _showMaxImageAlert();
      return;
    }

    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      if (_selectedImages.length + _existingImages.length + pickedFiles.length > _maxImages) {
        _showMaxImageAlert();
      } else {
        setState(() {
          _selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
        });
      }
    }
  }

  void _showMaxImageAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Batas Maksimum Tercapai"),
        content: const Text("Anda hanya dapat mengunggah maksimal 5 gambar."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final forumNotifier = ref.read(forumProvider.notifier);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Edit Postingan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 10),

          /// Input konten
          TextField(
            controller: _contentController,
            decoration: InputDecoration(
              hintText: "Perbarui konten...",
              hintStyle: TextStyle(color: Colors.grey.shade500),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            maxLines: null,
          ),
          const SizedBox(height: 10),

          /// Info gambar lama
          if (_existingImages.isNotEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text(
                "Gambar lama akan diganti jika Anda mengunggah gambar baru.",
                style: TextStyle(color: Colors.orange, fontSize: 12),
              ),
            ),

          /// Preview gambar
          if (_existingImages.isNotEmpty || _selectedImages.isNotEmpty) _buildImagePreview(),

          /// Tombol aksi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.image,
                  color: _selectedImages.length + _existingImages.length >= _maxImages
                      ? Colors.grey
                      : Color(0xFF66BB6A),
                  size: 28,
                ),
                onPressed: _selectedImages.length + _existingImages.length >= _maxImages ? null : _pickImage,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF66BB6A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: _isLoading
                    ? null
                    : () async {
                        if (_contentController.text.trim().isEmpty) return;
                        setState(() => _isLoading = true);
                        final success = await forumNotifier.updatePost(
                          postId: widget.post.id,
                          content: _contentController.text.trim(),
                          imagePaths: _selectedImages.map((e) => e.path).toList(),
                        );
                        if (mounted) {
                          setState(() => _isLoading = false);
                          Navigator.pop(context, success);
                        }
                      },
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text("Perbarui"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft, // ✅ Agar gambar mulai dari kiri
        child: Wrap(
          alignment: WrapAlignment.start,
          spacing: 8,
          runSpacing: 8,
          children: [
            /// 🔹 Gambar lama (dari URL server)
            ..._existingImages.map((url) {
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      url,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _existingImages.remove(url);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              );
            }),

            /// 🔹 Gambar baru (lokal file)
            ..._selectedImages.map((image) {
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      image,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImages.remove(image);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

}
