import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spl_mobile/providers/auth/google_auth_provider.dart';
import 'package:spl_mobile/providers/auth/auth_provider.dart';
import 'package:spl_mobile/routes/app_routes.dart';
import 'package:spl_mobile/widgets/snackbar/snackbar_helper.dart';

import 'components/register_header.dart';
import 'components/register_form.dart';
import 'components/social_buttons.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            floating: true,
            snap: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const RegisterHeader(),
                  const SizedBox(height: 16),
                  const RegisterForm(),
                  const SizedBox(height: 16),

                  /// ✅ Tombol Google Sign-Up disamakan dengan login
                  Consumer2<AuthGoogleProvider, AuthProvider>(
                    builder: (context, googleProvider, authProvider, _) {
                      return SocialButtons(
                        isLoading: googleProvider.isLoading,
                        onGoogleSignIn: () async {
                          final googleProvider = Provider.of<AuthGoogleProvider>(context, listen: false);
                          final authProvider = Provider.of<AuthProvider>(context, listen: false);

                          bool success = await googleProvider.loginWithGoogle(); // tetap pakai loginWithGoogle

                          if (success) {
                            debugPrint("✅ Register Google sukses! Menyimpan ke AuthProvider...");
                            await authProvider.setUserFromPrefs();

                            if (authProvider.isLoggedIn) {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setBool('isLoggedIn', true);

                              if (context.mounted) {
                                SnackbarHelper.showSnackbar(
                                  context,
                                  "Pendaftaran Google berhasil!",
                                  isError: false,
                                );
                                context.go(AppRoutes.home);
                              }
                            } else {
                              debugPrint("❌ User belum terdeteksi setelah daftar Google.");
                            }
                          } else {
                            debugPrint("❌ Pendaftaran Google gagal: ${googleProvider.errorMessage}");

                            SnackbarHelper.showSnackbar(
                              context,
                              googleProvider.errorMessage ?? "Pendaftaran gagal",
                              isError: true,
                            );
                          }
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
