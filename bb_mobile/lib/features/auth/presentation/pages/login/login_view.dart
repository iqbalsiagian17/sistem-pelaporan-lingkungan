import 'package:bb_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bb_mobile/features/auth/presentation/providers/google_auth_provider.dart';
import 'package:bb_mobile/routes/app_routes.dart';
import 'package:bb_mobile/widgets/snackbar/snackbar_helper.dart';

import '../../widgets/login/login_footer.dart';
import '../../widgets/login/login_form.dart';
import '../../widgets/login/login_header.dart';
import '../../widgets/login/social_buttons.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final google = ref.watch(googleAuthProvider);
    final googleNotifier = ref.read(googleAuthProvider.notifier);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LoginHeader(), 
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const LoginForm(),
                  const SizedBox(height: 24),
                  SocialButtons(
                    isLoading: google.isLoading,
                    onGoogleSignIn: () async {
                      final success = await googleNotifier.loginWithGoogle();

                      if (success) {
                        debugPrint("Login Google sukses!");
                        await authNotifier.refreshToken();

                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('isLoggedIn', true);

                        if (context.mounted) {
                          SnackbarHelper.showSnackbar(
                            context,
                            "Login Google berhasil!",
                            isError: false,
                          );
                          context.go(AppRoutes.dashboard);
                        }
                      } else {
                        final errorMessage = google.error?.toString() ?? "Login dibatalkan oleh pengguna.";
                        SnackbarHelper.showSnackbar(
                          context,
                          errorMessage,
                          isError: true,
                        );
                      }
                    },
                  ),
                  const LoginFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
