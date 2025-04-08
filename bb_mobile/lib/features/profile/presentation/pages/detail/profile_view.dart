import 'package:bb_mobile/features/auth/presentation/providers/auth_provider.dart' show authNotifierProvider;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bb_mobile/routes/app_routes.dart';
import 'package:bb_mobile/widgets/navbar/bottom_navbar.dart';
import 'package:bb_mobile/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:bb_mobile/features/profile/presentation/widgets/detail/profile_header.dart';
import 'package:bb_mobile/features/profile/presentation/widgets/detail/profile_menu.dart';
import 'package:bb_mobile/features/profile/presentation/widgets/detail/profile_stats.dart';
import 'package:bb_mobile/features/profile/presentation/widgets/detail/profile_topbar.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  int _selectedIndex = 4;

  void _handleLogout() async {
    final authProvider = ref.read(authNotifierProvider.notifier); // Corrected usage
    await authProvider.logout();

    if (context.mounted) {
      context.go(AppRoutes.login);
    }
  }

  @override
  void initState() {
    super.initState();
    // Load user profile when the page is first loaded
    Future.microtask(() {
      ref.read(userProfileProvider.notifier).loadUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProfileState = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ProfileTopBar(title: "Profil", onLogout: _handleLogout), // Pass onLogout
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: userProfileState.when(
          data: (user) {
            return Column(
              children: [
                const ProfileHeader(),
                const SizedBox(height: 20),
                const ProfileStats(),
                const SizedBox(height: 30),
                const ProfileMenu(),
                const SizedBox(height: 15),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text(" Gagal memuat profil: $error")),
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
