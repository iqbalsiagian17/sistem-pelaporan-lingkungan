  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'package:go_router/go_router.dart'; // ⬅️ Pakai GoRouter
  import 'package:spl_mobile/providers/auth_google_provider.dart';
  import 'package:spl_mobile/providers/auth_provider.dart';
  import 'package:spl_mobile/routes/app_routes.dart';
  import 'package:spl_mobile/widgets/show_snackbar.dart';

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
                      final googleProvider = Provider.of<AuthGoogleProvider>(context, listen: false);
                      final authProvider = Provider.of<AuthProvider>(context, listen: false);

                      bool success = await googleProvider.loginWithGoogle();

                      if (success) {
                        debugPrint("✅ Login Google sukses! Menyimpan ke AuthProvider...");

                        // ✅ Sinkronkan user ke AuthProvider dari SharedPreferences
                        await authProvider.setUserFromPrefs();

                        // ✅ Tampilkan notifikasi
                        SnackbarHelper.showSnackbar(
                          context,
                          "Login Google berhasil!",
                          isError: false,
                        );

                        // ✅ Redirect ke home setelah delay
                        Future.delayed(const Duration(seconds: 1), () {
                          if (context.mounted) context.go(AppRoutes.home);
                        });
                      } else {
                        debugPrint("❌ Login Google gagal: ${googleProvider.errorMessage}");

                        SnackbarHelper.showSnackbar(
                          context,
                          googleProvider.errorMessage ?? "Login gagal",
                          isError: true,
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
