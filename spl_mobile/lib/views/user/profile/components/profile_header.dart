import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider.dart'; // ✅ Ambil user dari sini
import '../../../../providers/user_profile_provider.dart'; // ✅ Ambil foto dari sini
import '../../../../core/constants/api.dart'; // ✅ Import base URL

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85, // ✅ Kompres gambar
    );

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      final profileProvider = Provider.of<UserProfileProvider>(context, listen: false);
      
      bool success = await profileProvider.updateProfilePicture(imageFile);
      
      if (success) {
        // ✅ Refresh data setelah berhasil update foto profil
        await profileProvider.loadUserInfo();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Foto profil berhasil diperbarui!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal mengganti foto profil")),
        );
      }
    }
  }

  // ✅ Tampilkan Foto dalam Fullscreen Modal
  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Hero(
            tag: "profilePicture",
            child: InteractiveViewer( // ✅ Bisa di-zoom in & out
              child: Image.network(imageUrl, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, UserProfileProvider>(
      builder: (context, authProvider, profileProvider, child) {
        final user = authProvider.user; // ✅ Ambil User dari AuthProvider
        final userInfo = profileProvider.userInfo; // ✅ Ambil Foto Profil dari UserProfileProvider

        // ✅ Ambil URL gambar dari API Constants
        final String? profilePictureUrl = userInfo?.profilePicture?.isNotEmpty == true
            ? "${ApiConstants.baseUrl}${userInfo!.profilePicture}?timestamp=${DateTime.now().millisecondsSinceEpoch}"
            : null;

        return Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight, // ✅ Posisikan icon di pojok kanan bawah
              children: [
                GestureDetector(
                  onTap: () { // ✅ Ubah dari onLongPress ke onTap
                    if (profilePictureUrl != null) {
                      _showFullImage(context, profilePictureUrl);
                    }
                  },
                  child: Hero(
                    tag: "profilePicture",
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
                      backgroundImage: profilePictureUrl != null
                          ? NetworkImage(profilePictureUrl)
                          : const AssetImage("assets/images/default_avatar.png") as ImageProvider,
                      child: profilePictureUrl == null
                          ? const Icon(Icons.camera_alt, size: 30, color: Colors.white)
                          : null,
                    ),
                  ),
                ),

                // ✅ Tambahkan tombol kamera kecil
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => _pickImage(context), // ✅ Panggil fungsi pilih gambar
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green, // ✅ Warna background tombol
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ✅ Data User dari AuthProvider
            Text(
              user?.username ?? "Pengguna",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              user?.phoneNumber ?? "Tidak ada nomor",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 5),
            Text(
              user?.email ?? "Tidak ada email",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        );
      },
    );
  }
}
