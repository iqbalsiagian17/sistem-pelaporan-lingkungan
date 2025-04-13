import 'package:bb_mobile/core/constants/api.dart';
import 'package:bb_mobile/widgets/snackbar/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:bb_mobile/widgets/skeleton/skeleton_header_profile.dart';
import 'package:image_picker/image_picker.dart';

class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({super.key});

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

  Future<void> _pickImage(BuildContext context, WidgetRef ref) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final success = await ref
          .read(userProfileProvider.notifier)
          .changeProfilePicture(image.path);

      if (context.mounted) {
        if (success) {
          SnackbarHelper.showSnackbar(
            context,
            'Foto profil berhasil diperbarui',
            isError: false,
          );
        } else {
          SnackbarHelper.showSnackbar(
            context,
            'Gagal memperbarui foto profil',
            isError: true,
          );
        }
      }
    }
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                ClipOval(
                  child: hasImage
                      ? Image.network(
                          imageUrl!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => CircleAvatar(
                            radius: 40,
                            backgroundColor: bgColor,
                            child: Text(
                              initials,
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
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
                                color: Colors.white),
                          ),
                        ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => _pickImage(context, ref),
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
              user.phoneNumber.isNotEmpty
                  ? user.phoneNumber
                  : "Tidak ada nomor",
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/google.png',
                        width: 16, height: 16),
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
