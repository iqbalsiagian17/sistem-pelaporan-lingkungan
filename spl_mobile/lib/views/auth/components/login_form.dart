import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/validators.dart';
import '../../../providers/auth/auth_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/snackbar/snackbar_helper.dart';
import '../../../widgets/input/custom_input_field.dart';
import '../../../widgets/buttons/custom_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
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
    final authProvider = context.read<AuthProvider>();

    try {
      final success = await authProvider.login(
        _identifierController.text.trim(),
        _passwordController.text.trim(),
      );

      if (success) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        if (mounted) {
          SnackbarHelper.showSnackbar(context, "Login berhasil!", isError: false);
          context.go(AppRoutes.home);
        }
      } else {
        if (mounted) {
          SnackbarHelper.showSnackbar(
            context,
            authProvider.errorMessage ??
                "Login gagal. Periksa email/nomor telepon dan password!",
            isError: true,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        SnackbarHelper.showSnackbar(
          context,
          "Terjadi kesalahan saat login. Coba lagi nanti.",
          isError: true,
        );
      }
      debugPrint("❌ Error saat login: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomInputField(
            controller: _identifierController,
            label: 'Email atau Nomor Telepon',
            icon: Icons.person_outline,
            keyboardType: TextInputType.text,
            validator: Validators.validateEmailOrPhone,
          ),
          const SizedBox(height: 10),
          CustomInputField(
            controller: _passwordController,
            label: 'Password',
            icon: Icons.lock_outline,
            isObscure: _isObscurePassword,
            onToggleObscure: () =>
                setState(() => _isObscurePassword = !_isObscurePassword),
            validator: Validators.validatePassword,
          ),
          const SizedBox(height: 10),
          Consumer<AuthProvider>(
            builder: (_, auth, __) => CustomButton(
              text: "Masuk",
              onPressed: auth.isLoading ? null : _login,
              isLoading: auth.isLoading,
              isOutlined: true,
              textColor: const Color(0xFF6c757d),
              borderColor: const Color(0xFF6c757d),
            ),
          ),
        ],
      ),
    );
  }
}
