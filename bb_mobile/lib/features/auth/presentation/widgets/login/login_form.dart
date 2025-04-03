import 'package:bb_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bb_mobile/core/utils/validators.dart';
import 'package:bb_mobile/routes/app_routes.dart';
import 'package:bb_mobile/widgets/snackbar/snackbar_helper.dart';
import 'package:bb_mobile/widgets/input/custom_input_field.dart';
import 'package:bb_mobile/widgets/buttons/custom_button.dart';

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
          CustomButton(
            text: "Masuk",
            onPressed: authState.isLoading ? null : _login,
            isLoading: authState.isLoading,
            isOutlined: true,
            textColor: const Color(0xFF6c757d),
            borderColor: const Color(0xFF6c757d),
          ),
        ],
      ),
    );
  }
}
