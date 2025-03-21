import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart'; // ⬅️ Pakai GoRouter
import 'package:spl_mobile/providers/auth_google_provider.dart';
import 'package:spl_mobile/routes/app_routes.dart';

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

            // Google Sign In Button with Provider
            Consumer<AuthGoogleProvider>(
              builder: (context, googleProvider, _) {
                return SocialButtons(
                  isLoading: googleProvider.isLoading,
                  onGoogleSignIn: () async {
                    bool success = await googleProvider.loginWithGoogle();

                    if (success) {
                      debugPrint("✅ Login Google sukses! Navigasi ke ${AppRoutes.home}");
                      context.go(AppRoutes.home); // ⬅️ GoRouter navigation
                    } else {
                      debugPrint("❌ Login Google gagal: ${googleProvider.errorMessage}");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            googleProvider.errorMessage ?? 'Login gagal',
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
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
