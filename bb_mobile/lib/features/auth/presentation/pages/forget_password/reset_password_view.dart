import 'package:bb_mobile/features/auth/presentation/providers/auth_provider.dart';
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

  bool _isObscure = true;
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final success = await ref.read(authNotifierProvider.notifier)
        .resetPassword(widget.email, _passwordController.text.trim());

    setState(() => _isLoading = false);

    if (success && context.mounted) {
      SnackbarHelper.showSnackbar(context, "Password berhasil diubah");
        context.push('/login', extra: widget.email);
    } else {
      SnackbarHelper.showSnackbar(context, "Gagal mengubah password", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "Masukkan password baru untuk akun Anda",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  labelText: "Password Baru",
                  suffixIcon: IconButton(
                    icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _isObscure = !_isObscure),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Password wajib diisi";
                  if (value.length < 6) return "Minimal 6 karakter";
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _isObscure,
                decoration: const InputDecoration(labelText: "Konfirmasi Password"),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Konfirmasi wajib diisi";
                  if (value != _passwordController.text) return "Password tidak cocok";
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Simpan Password"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
