import 'dart:io';
import 'package:bb_mobile/core/utils/validators.dart';
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  static const int _maxImages = 10;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.post.content);
    _selectedImages = [];
    _existingImages = widget.post.images.map((e) => e.imageUrl).toList();
  }

  List<String> _getRelativeImagePaths(List<String> urls) {
    return urls.map((url) {
      final uri = Uri.parse(url);
      return uri.path.startsWith('/uploads/') ? uri.path.substring(1) : uri.path;
    }).toList();
  }

  Future<void> _pickImage() async {
    if (_selectedImages.length + _existingImages.length >= _maxImages) {
      _showMaxImageAlert();
      return;
    }

    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      final remaining = _maxImages - (_selectedImages.length + _existingImages.length);
      final toAdd = pickedFiles.take(remaining);

      setState(() {
        _selectedImages.addAll(toAdd.map((file) => File(file.path)));
      });

      if (pickedFiles.length > remaining) {
        _showPartialImageAlert(remaining);
      }
    }
  }

  void _showMaxImageAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Batas Maksimum Tercapai"),
        content: const Text("Anda hanya dapat mengunggah maksimal 10 gambar."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void _showPartialImageAlert(int addedCount) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded, size: 40, color: Colors.orange),
              const SizedBox(height: 12),
              Text(
                "Maksimal 10 Gambar",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Hanya $addedCount gambar yang ditambahkan karena batas maksimal adalah 10.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF66BB6A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("Mengerti", style: TextStyle(fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final forumNotifier = ref.read(forumProvider.notifier);

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Header
                Row(
                  children: [
                    const Spacer(),
                    const Text("Edit Postingan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                /// Text input
                TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    hintText: "Perbarui konten...",
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  validator: (value) =>
                      Validators.validateNotEmpty(value?.trim(), fieldName: "Konten"),
                ),
                const SizedBox(height: 12),

                /// Preview gambar
                if (_existingImages.isNotEmpty || _selectedImages.isNotEmpty)
                  _buildImagePreview(),

                /// Toolbar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.image_outlined,
                        color: _selectedImages.length + _existingImages.length >= _maxImages
                            ? Colors.grey
                            : const Color(0xFF66BB6A),
                        size: 26,
                      ),
                      onPressed: _selectedImages.length + _existingImages.length >= _maxImages
                          ? null
                          : _pickImage,
                    ),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;

                              setState(() => _isLoading = true);
                              final success = await forumNotifier.updatePost(
                                postId: widget.post.id,
                                content: _contentController.text.trim(),
                                imagePaths: _selectedImages.map((e) => e.path).toList(),
                                keptOldImages: _getRelativeImagePaths(_existingImages),
                              );

                            if (mounted) {
                              setState(() => _isLoading = false);
                              if (success) {
                                Navigator.pop(context, true); // ✅ hanya return true jika berhasil
                              }
                            }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF66BB6A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text("Perbarui"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ..._existingImages.map((url) {
            return Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(url, width: 90, height: 90, fit: BoxFit.cover),
                ),
                GestureDetector(
                  onTap: () => setState(() => _existingImages.remove(url)),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: const Icon(Icons.close, color: Colors.white, size: 18),
                  ),
                ),
              ],
            );
          }),
          ..._selectedImages.map((image) {
            return Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(image, width: 90, height: 90, fit: BoxFit.cover),
                ),
                GestureDetector(
                  onTap: () => setState(() => _selectedImages.remove(image)),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: const Icon(Icons.close, color: Colors.white, size: 18),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
