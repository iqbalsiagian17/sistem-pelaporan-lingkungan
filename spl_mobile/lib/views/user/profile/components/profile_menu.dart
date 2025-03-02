import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/app_routes.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Text(
            "Akun",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(137, 0, 0, 0)),
          ),
        ),
        _buildMenuItem(Icons.edit, "Edit Profil", () {
          context.push(AppRoutes.editProfile); // ✅ Navigasi ke halaman edit profil
        }),
       _buildMenuItem(Icons.lock, "Ubah Password", () {
          context.go(AppRoutes.editPassword);
        }),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Text(
            "Umum",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
        ),
        _buildMenuItem(Icons.book, "Syarat & Ketentuan", () {
          // TODO: Tambahkan navigasi ke halaman syarat & ketentuan
        }),
        _buildMenuItem(Icons.info, "Tentang Aplikasi", () {
          // TODO: Tambahkan navigasi ke halaman tentang aplikasi
        }),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
      onTap: onTap,
    );
  }
}
