import 'dart:io';
import 'package:bb_mobile/features/forum/presentation/providers/forum_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostModal extends ConsumerStatefulWidget {
  const CreatePostModal({super.key});

  @override
  ConsumerState<CreatePostModal> createState() => _CreatePostModalState();
}

class _CreatePostModalState extends ConsumerState<CreatePostModal> {
  final TextEditingController _contentController = TextEditingController();
  final List<File> _selectedImages = [];
  bool _isLoading = false;
  static const int _maxImages = 5;

  Future<void> _pickImage() async {
    if (_selectedImages.length >= _maxImages) {
      _showMaxImageAlert();
      return;
    }

    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      if (_selectedImages.length + pickedFiles.length > _maxImages) {
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
              const Text(
                "Buat Postingan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
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
              hintText: "Apa yang sedang terjadi?",
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
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(height: 10),

          /// Preview gambar
          if (_selectedImages.isNotEmpty) _buildImagePreview(),

          /// Tombol aksi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.image,
                  color: _selectedImages.length >= _maxImages ? Colors.grey : Color(0xFF66BB6A),
                  size: 28,
                ),
                onPressed: _selectedImages.length >= _maxImages ? null : _pickImage,
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

                        final success = await forumNotifier.createPost(
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
                    : const Text("Posting"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Widget preview gambar
  Widget _buildImagePreview() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _selectedImages.map((image) {
          return Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(image, width: 80, height: 80, fit: BoxFit.cover),
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
        }).toList(),
      ),
    );
  }
}
