import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/widgets/snackbar/snackbar_helper.dart';
import 'package:bb_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordBottomSheet extends ConsumerStatefulWidget {
  const ForgotPasswordBottomSheet({super.key});

  @override
  ConsumerState<ForgotPasswordBottomSheet> createState() =>
      _ForgotPasswordBottomSheetState();
}

class _ForgotPasswordBottomSheetState
    extends ConsumerState<ForgotPasswordBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final success = await ref.read(authNotifierProvider.notifier).forgotPassword(email);

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pop(context); // tutup modal
      context.push('/verify-forgot-otp', extra: email); // navigasi ke otp
    } else {
      SnackbarHelper.showSnackbar(context, "Gagal mengirim OTP. Coba lagi!", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets, // agar tidak ketutup keyboard
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min, // penting agar modal tidak full screen
            children: [
              const Text(
                "Reset Password",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Masukkan email yang terdaftar untuk menerima kode OTP.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Email wajib diisi";
                  if (!value.contains("@")) return "Format email tidak valid";
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
                      : const Text("Kirim OTP"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
