import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../../../core/utils/validators.dart';
import '../../../providers/auth/auth_provider.dart';
import '../../../widgets/snackbar/snackbar_helper.dart';
import '../../../widgets/input/custom_input_field.dart';
import '../../../widgets/buttons/custom_button.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
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

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool success = await authProvider.register(
      _phoneController.text.trim(),
      _usernameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success) {
      _phoneController.clear();
      _usernameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();

      SnackbarHelper.showSnackbar(context, "Registrasi berhasil! Silakan login.", isError: false);

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) context.pushReplacement("/login");
      });
    } else {
      SnackbarHelper.showSnackbar(context, "Registrasi gagal. Coba lagi!", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            onToggleObscure: () => setState(() => _isObscurePassword = !_isObscurePassword),
            validator: Validators.validatePassword,
          ),
          CustomInputField(
            controller: _confirmPasswordController,
            label: 'Konfirmasi Password',
            icon: Icons.lock_outline,
            isObscure: _isObscureConfirmPassword,
            onToggleObscure: () => setState(() => _isObscureConfirmPassword = !_isObscureConfirmPassword),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Konfirmasi password tidak boleh kosong';
              if (value != _passwordController.text) return 'Password tidak cocok';
              return null;
            },
          ),
          const SizedBox(height: 20),
          Consumer<AuthProvider>(
            builder: (context, auth, child) {
              return CustomButton(
                text: "Daftar",
                onPressed: auth.isLoading ? () {} : _register, // ✅ Gunakan fungsi kosong jika loading
                isLoading: auth.isLoading,
                isOutlined: true, // ✅ Gunakan outlined button agar konsisten dengan login
                textColor: const Color(0xFF6c757d),
                borderColor: const Color(0xFF6c757d),
              );
            },
          ),
        ],
      ),
    );
  }
}
