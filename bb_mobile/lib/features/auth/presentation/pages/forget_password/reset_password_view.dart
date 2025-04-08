import 'package:bb_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:bb_mobile/widgets/buttons/custom_button.dart';
import 'package:bb_mobile/widgets/input/custom_input_field.dart';
import 'package:bb_mobile/widgets/snackbar/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordView extends ConsumerStatefulWidget {
  final String email;

  const ResetPasswordView({super.key, required this.email});

  @override
  ConsumerState<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends ConsumerState<ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordObscure = true;
  bool _isConfirmObscure = true;
  bool _isLoading = false;

  void _togglePasswordObscure() {
    setState(() {
      _isPasswordObscure = !_isPasswordObscure;
    });
  }

  void _toggleConfirmObscure() {
    setState(() {
      _isConfirmObscure = !_isConfirmObscure;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final success = await ref
        .read(authNotifierProvider.notifier)
        .resetPassword(widget.email, _passwordController.text.trim());

    setState(() => _isLoading = false);

    if (success && context.mounted) {
      SnackbarHelper.showSnackbar(context, "Password berhasil diubah");
      context.go('/login');
    } else {
      SnackbarHelper.showSnackbar(context, "Gagal mengubah password", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        title: const Text("Reset Password"),
        backgroundColor: Colors.white, 
        foregroundColor: Colors.black, 
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "Masukkan password baru untuk akun Anda.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 24),
              CustomInputField(
                controller: _passwordController,
                label: "Password Baru",
                icon: Icons.lock,
                isObscure: _isPasswordObscure,
                onToggleObscure: _togglePasswordObscure,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Password wajib diisi";
                  if (value.length < 6) return "Minimal 6 karakter";
                  return null;
                },
              ),
              CustomInputField(
                controller: _confirmPasswordController,
                label: "Konfirmasi Password",
                icon: Icons.lock_outline,
                isObscure: _isConfirmObscure,
                onToggleObscure: _toggleConfirmObscure,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Konfirmasi wajib diisi";
                  if (value != _passwordController.text) return "Password tidak cocok";
                  return null;
                },
              ),
              const SizedBox(height: 28),
              CustomButton(
                text: "Simpan Password",
                isLoading: _isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
