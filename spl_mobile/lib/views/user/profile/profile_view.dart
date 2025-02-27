import 'package:flutter/material.dart';
import '../../../widgets/bottom_navbar.dart';
import 'components/profile_header.dart';
import 'components/profile_stats.dart';
import 'components/profile_menu.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  int _selectedIndex = 4; // ✅ Profil aktif di Bottom Navbar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ Background putih untuk seluruh halaman
      appBar: AppBar(
        title: const Text('Profil', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0, // ✅ Menghilangkan shadow agar lebih clean
        backgroundColor: Colors.white, // ✅ AppBar putih
        iconTheme: const IconThemeData(color: Color.fromRGBO(76, 175, 80, 1)), // 🔴 Warna merah logout
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color.fromRGBO(76, 175, 80, 1)), // 🔴 Warna merah logout
            onPressed: () {
              // TODO: Tambahkan logika logout
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: const [
            ProfileHeader(),
            SizedBox(height: 20),
            ProfileStats(),
            SizedBox(height: 30),
            ProfileMenu(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}
