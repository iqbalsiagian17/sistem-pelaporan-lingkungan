import 'package:bb_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bb_mobile/core/utils/validators.dart';
import 'package:bb_mobile/widgets/input/custom_input_field.dart';
import 'package:bb_mobile/widgets/buttons/custom_button.dart';
import 'package:bb_mobile/widgets/snackbar/snackbar_helper.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(authNotifierProvider.notifier);
    final email = _emailController.text.trim(); // ✅ simpan dulu sebelum clear


    final success = await notifier.register(
      _phoneController.text.trim(),
      _usernameController.text.trim(),
      email,
      _passwordController.text.trim(),
    );

    if (success) {
      _phoneController.clear();
      _usernameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();

      SnackbarHelper.showSnackbar(context, "Registrasi berhasil! Silakan verifikasi email Anda.", isError: false);

      Future.delayed(const Duration(seconds: 1), () {
        if (context.mounted) 
      if (context.mounted) context.push("/verify-otp", extra: email); // ✅ pakai email yg disimpan
      });
    } else {
      SnackbarHelper.showSnackbar(context, "Registrasi gagal. Coba lagi!", isError: true);
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
            controller: _phoneController,
            label: 'Nomor Telepon',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            validator: Validators.validatePhone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(15),
            ],
          ),
          CustomInputField(
            controller: _usernameController,
            label: 'Username',
            icon: Icons.person,
            validator: Validators.validateNotEmpty,
          ),
          CustomInputField(
            controller: _emailController,
            label: 'Email',
            icon: Icons.email,
            validator: Validators.validateEmail,
          ),
          CustomInputField(
            controller: _passwordController,
            label: 'Password',
            icon: Icons.lock,
            isObscure: _isObscurePassword,
            onToggleObscure: () =>
                setState(() => _isObscurePassword = !_isObscurePassword),
            validator: Validators.validatePassword,
          ),
          CustomInputField(
            controller: _confirmPasswordController,
            label: 'Konfirmasi Password',
            icon: Icons.lock_outline,
            isObscure: _isObscureConfirmPassword,
            onToggleObscure: () =>
                setState(() => _isObscureConfirmPassword = !_isObscureConfirmPassword),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Konfirmasi password tidak boleh kosong';
              if (value != _passwordController.text) return 'Password tidak cocok';
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: "Daftar",
            onPressed: authState.isLoading ? null : _register,
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
