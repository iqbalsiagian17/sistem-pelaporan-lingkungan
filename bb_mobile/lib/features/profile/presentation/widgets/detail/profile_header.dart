import 'dart:ui';

import 'package:bb_mobile/core/constants/api.dart';
import 'package:bb_mobile/widgets/snackbar/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:bb_mobile/widgets/skeleton/skeleton_header_profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

class ProfileHeader extends ConsumerStatefulWidget {
  const ProfileHeader({super.key});

  @override
  ConsumerState<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends ConsumerState<ProfileHeader> {
  bool _isPickingImage = false;

  Color _generateColorFromUsername(String username) {
    int hash = username.hashCode;
    int r = (hash & 0xFF0000) >> 16;
    int g = (hash & 0x00FF00) >> 8;
    int b = (hash & 0x0000FF);
    return Color.fromARGB(255, r, g, b);
  }

  String _getInitials(String? username) {
    if (username == null || username.isEmpty) return "?";
    List<String> parts = username.split(" ");
    return parts.length == 1
        ? parts[0][0].toUpperCase()
        : "${parts[0][0]}${parts[1][0]}".toUpperCase();
  }

  String getFullImageUrl(String path) {
    return "${ApiConstants.baseUrl}/${path.replaceAll(r'\', '/')}";
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    if (_isPickingImage) return;
    _isPickingImage = true;

    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: source);

      if (image != null) {
        final success = await ref
            .read(userProfileProvider.notifier)
            .changeProfilePicture(image.path);

        if (context.mounted) {
          SnackbarHelper.showSnackbar(
            context,
            success ? 'Foto profil berhasil diperbarui' : 'Gagal memperbarui foto profil',
            isError: !success,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarHelper.showSnackbar(
          context,
          'Terjadi kesalahan: $e',
          isError: true,
        );
      }
    } finally {
      _isPickingImage = false;
    }
  }


  void _showProfileImagePreview(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.transparent,
    builder: (context) {
      return GestureDetector(
        onTap: () => Navigator.of(context).pop(), // tutup saat tap blur
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () {}, // agar tap gambar tidak close
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundImage: NetworkImage(imageUrl),
                      backgroundColor: Colors.grey[200],
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.of(context).pop(); // tutup blur modal
                          _showImageSourcePicker(context);

                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.camera_alt, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}


void _showImageSourcePicker(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: false,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔘 Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // 🔘 Foto Profil
          const SizedBox(height: 16),

          // 🔘 Pilih dari Galeri
          ListTile(
            leading: const Icon(Icons.photo_outlined),
            title: const Text('Pilih dari galeri'),
            onTap: () async {
              Navigator.pop(context);
              await _pickImage(context, ImageSource.gallery);
            },
          ),

          // 🔘 Ambil dari Kamera
          ListTile(
            leading: const Icon(Icons.camera_alt_outlined),
            title: const Text('Ambil foto'),
            onTap: () async {
              Navigator.pop(context);
              await _pickImage(context, ImageSource.camera);
            },
          ),

          const SizedBox(height: 10),
        ],
      );
    },
  );
}








  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userProfileProvider);

    return state.when(
      loading: () => const ProfileHeaderSkeleton(),
      error: (err, _) => const Text("Gagal memuat profil"),
      data: (user) {
        final initials = _getInitials(user.username);
        final bgColor = _generateColorFromUsername(user.username);
        final isGoogleUser = user.authProvider == 'google';
        final hasImage =
            user.profilePicture != null && user.profilePicture!.isNotEmpty;
        final imageUrl =
            hasImage ? getFullImageUrl(user.profilePicture!) : null;

        return Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                GestureDetector(
                  onTap: () {
                    if (hasImage) {
                      _showProfileImagePreview(context, imageUrl!);
                    }
                  },

                  child: ClipOval(
                    child: hasImage
                        ? Image.network(
                            imageUrl!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (_, __, ___) => CircleAvatar(
                              radius: 40,
                              backgroundColor: bgColor,
                              child: Text(
                                initials,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        : CircleAvatar(
                            radius: 40,
                            backgroundColor: bgColor,
                            child: Text(
                              initials,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),


                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => _showImageSourcePicker(context),

                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.camera_alt, size: 18),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              user.username,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              user.phoneNumber.isNotEmpty ? user.phoneNumber : "Tidak ada nomor",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 5),
            Text(
              user.email.isNotEmpty ? user.email : "Tidak ada email",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            if (isGoogleUser)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/google.png', width: 16, height: 16),
                    const SizedBox(width: 6),
                    const Text(
                      "Terhubung ke Google",
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
