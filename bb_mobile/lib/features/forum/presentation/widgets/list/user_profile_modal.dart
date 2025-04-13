import 'package:flutter/material.dart';
import 'package:bb_mobile/features/report/domain/entities/user_entity.dart';
import 'package:bb_mobile/core/constants/api.dart';

class UserProfileModal extends StatelessWidget {
  final UserEntity user;

  const UserProfileModal({super.key, required this.user});

  String? get profileImageUrl {
    if (user.profilePicture == null || user.profilePicture!.isEmpty) return null;
    return "${ApiConstants.baseUrl}/${user.profilePicture!.replaceAll(r'\', '/')}";
  }

void _showFullImage(BuildContext context, String imageUrl) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Gambar",
    pageBuilder: (_, __, ___) {
      return Stack(
        children: [
          Container(
            color: Colors.black,
            child: Center(
              child: InteractiveViewer(
                child: Image.network(imageUrl),
              ),
            ),
          ),

          // 🔘 Tombol Exit di pojok kanan atas
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    final hasImage = profileImageUrl != null;

    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      maxChildSize: 0.8,
      minChildSize: 0.3,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                /// ✅ Klik gambar untuk fullscreen
                GestureDetector(
                  onTap: () {
                    if (hasImage) {
                      _showFullImage(context, profileImageUrl!);
                    }
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: hasImage ? NetworkImage(profileImageUrl!) : null,
                    backgroundColor: Colors.green.shade200,
                    child: !hasImage
                        ? Text(
                            user.username.isNotEmpty
                                ? user.username[0].toUpperCase()
                                : "?",
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                ),

                const SizedBox(height: 16),
                Text(
                  user.username,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(user.email, style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 6),
                if (user.phoneNumber.isNotEmpty)
                  Text(user.phoneNumber, style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 20),
                const Divider(thickness: 1),
                const SizedBox(height: 12),
                const Text(
                  "Belum tersedia aksi lainnya untuk user ini.",
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
