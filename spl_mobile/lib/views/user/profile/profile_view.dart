import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart'; // ✅ Ambil autentikasi dari AuthProvider
import '../../../providers/user_profile_provider.dart'; // ✅ Ambil data user dari UserProfileProvider
import '../../../widgets/bottom_navbar.dart';
import 'components/profile_top_bar.dart';
import 'components/profile_header.dart';
import 'components/profile_stats.dart';
import 'components/profile_menu.dart';
import 'package:go_router/go_router.dart';
import '../../../routes/app_routes.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  int _selectedIndex = 4;

  void _handleLogout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false); // ✅ Logout dari AuthProvider
    await authProvider.logout();

    // ✅ Redirect ke halaman login setelah logout
    if (context.mounted) {
      context.go(AppRoutes.login);
    }
  }

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  Future.microtask(() async {
    await Provider.of<UserProfileProvider>(context, listen: false).refreshUser();
  });
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ProfileTopBar(title: "Profil", onLogout: _handleLogout), // ✅ Tambahkan onLogout
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Consumer2<AuthProvider, UserProfileProvider>(
          builder: (context, authProvider, profileProvider, child) {
            return Column(
              children: [
                ProfileHeader(),
                SizedBox(height: 20),
                ProfileStats(),
                SizedBox(height: 30),
                ProfileMenu(),
                SizedBox(height: 15),
              ]
            );
          },
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
