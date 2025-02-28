import 'package:flutter/material.dart';
import '../../../widgets/bottom_navbar.dart';
import 'components/profile_top_bar.dart';
import 'components/profile_header.dart';
import 'components/profile_stats.dart';
import 'components/profile_menu.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  int _selectedIndex = 4; // ✅ Profile tab active in Bottom Navbar

  void _handleLogout() {
    // TODO: Implement logout logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ Ensure background stays white
      appBar: ProfileTopBar(title: "Profil", onLogout: _handleLogout), // ✅ Pass title argument
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
