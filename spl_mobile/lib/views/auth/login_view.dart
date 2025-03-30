import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spl_mobile/providers/auth/google_auth_provider.dart';
import 'package:spl_mobile/providers/auth/auth_provider.dart';
import 'package:spl_mobile/routes/app_routes.dart';
import 'package:spl_mobile/widgets/snackbar/snackbar_helper.dart';

import 'components/login_header.dart';
import 'components/login_form.dart';
import 'components/social_buttons.dart';
import 'components/login_footer.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LoginHeader(),
            const LoginForm(),
            const SizedBox(height: 16),

            /// 🔐 Tombol Google Sign-In
            Consumer2<AuthGoogleProvider, AuthProvider>(
              builder: (context, googleProvider, authProvider, _) {
                return SocialButtons(
                  isLoading: googleProvider.isLoading,
                  onGoogleSignIn: () async {
                    final googleProvider = Provider.of<AuthGoogleProvider>(context, listen: false);
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);

                    bool success = await googleProvider.loginWithGoogle();

                    if (success) {
                      debugPrint("✅ Login Google sukses! Menyimpan ke AuthProvider...");

                      await authProvider.setUserFromPrefs();

                      if (authProvider.isLoggedIn) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('isLoggedIn', true); // ✅ Diperlukan untuk redirect di AppRoutes

                        if (context.mounted) {
                          SnackbarHelper.showSnackbar(
                            context,
                            "Login Google berhasil!",
                            isError: false,
                          );
                          context.go(AppRoutes.home); // ✅ Pindah ke halaman utama
                        }
                      } else {
                        debugPrint("❌ User belum terdeteksi setelah login Google.");
                      }
                    } else {
                      debugPrint("❌ Login Google gagal: ${googleProvider.errorMessage}");

                      SnackbarHelper.showSnackbar(
                        context,
                        googleProvider.errorMessage ?? "Login gagal",
                        isError: true,
                      );
                    }
                  }
                );
              },
            ),

            const SizedBox(height: 24),
            const LoginFooter(),
          ],
        ),
      ),
    );
  }
}
