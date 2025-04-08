import 'package:bb_mobile/features/auth/presentation/widgets/login/login_forgot_password_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

import 'package:bb_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:bb_mobile/routes/app_routes.dart';
import 'package:bb_mobile/widgets/snackbar/snackbar_helper.dart';
import 'login_email_field.dart';
import 'login_password_field.dart';
import 'login_submit_button.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final notifier = ref.read(authNotifierProvider.notifier);
    final success = await notifier.login(
      _identifierController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      if (context.mounted) {
        SnackbarHelper.showSnackbar(context, "Login berhasil!", isError: false);
        context.go(AppRoutes.dashboard);
      }
    } else {
      final state = ref.read(authNotifierProvider);
      if (context.mounted) {
        SnackbarHelper.showSnackbar(
          context,
          state.error?.toString() ?? "Login gagal. Periksa kembali.",
          isError: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          LoginEmailField(controller: _identifierController),
          const SizedBox(height: 12),
          LoginPasswordField(
            controller: _passwordController,
            isObscure: _isObscurePassword,
            onToggleObscure: () => setState(() => _isObscurePassword = !_isObscurePassword),
          ),
          const SizedBox(height: 8),
          LoginForgotPasswordButton(),
          const SizedBox(height: 8),
          LoginSubmitButton(
            isLoading: authState.isLoading,
            onPressed: _login,
          ),
        ],
      ),
    );
  }
}
