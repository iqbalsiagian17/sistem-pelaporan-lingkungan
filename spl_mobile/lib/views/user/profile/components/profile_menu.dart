import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // ✅ Menyesuaikan posisi teks kategori
      children: [
        // ✅ Kategori "Akun"
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Text(
            "Akun",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(137, 0, 0, 0)),
          ),
        ),
        _buildMenuItem(Icons.edit, "Edit Profil", () {
          // TODO: Tambahkan navigasi ke halaman edit profil
        }),
        _buildMenuItem(Icons.lock, "Ubah Password", () {
          // TODO: Tambahkan navigasi ke halaman ubah password
        }),

        const SizedBox(height: 20), // ✅ Jarak antar kategori

        // ✅ Kategori "Umum"
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
