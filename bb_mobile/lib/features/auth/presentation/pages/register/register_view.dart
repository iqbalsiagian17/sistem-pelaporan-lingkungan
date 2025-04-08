import 'package:bb_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bb_mobile/routes/app_routes.dart';
import 'package:bb_mobile/widgets/snackbar/snackbar_helper.dart';

import 'package:bb_mobile/features/auth/presentation/providers/google_auth_provider.dart';
import '../../widgets/register/register_form.dart';
import '../../widgets/register/register_header.dart';
import '../../widgets/login/social_buttons.dart';

class RegisterView extends ConsumerWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final google = ref.watch(googleAuthProvider);
    final googleNotifier = ref.read(googleAuthProvider.notifier);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
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
                  SocialButtons(
                    isLoading: google.isLoading,
                    onGoogleSignIn: () async {
                      final success = await googleNotifier.loginWithGoogle();

                      if (success) {
                        await authNotifier.refreshToken();
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('isLoggedIn', true);

                        if (context.mounted) {
                          SnackbarHelper.showSnackbar(context, "Pendaftaran Google berhasil!", isError: false);
                          context.go(AppRoutes.dashboard);
                        }
                      } else {
                        if (context.mounted) {
                          SnackbarHelper.showSnackbar(
                            context,
                            (google.error ?? "Pendaftaran gagal").toString(), 
                            isError: true,
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
