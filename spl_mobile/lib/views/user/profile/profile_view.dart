import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/auth/auth_provider.dart';
import '../../../providers/user/user_profile_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/navbar/bottom_navbar.dart';

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
  int _selectedIndex = 4;
  bool _isInit = true;

  /// ✅ Logout Handler
  void _handleLogout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();

    if (context.mounted) {
      context.go(AppRoutes.login);
    }
  }

  /// ✅ Ambil user dari backend hanya saat pertama kali
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Future.microtask(() {
        Provider.of<UserProfileProvider>(context, listen: false).refreshUser();
      });
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ProfileTopBar(title: "Profil", onLogout: _handleLogout),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Consumer<UserProfileProvider>(
          builder: (context, profileProvider, _) {
            final user = profileProvider.user;

            if (profileProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (user == null) {
              return const Center(child: Text("Gagal memuat profil pengguna."));
            }

            return Column(
              children: [
                ProfileHeader(),
                const SizedBox(height: 20),
                const ProfileStats(),
                const SizedBox(height: 30),
                const ProfileMenu(),
                const SizedBox(height: 15),
              ],
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
