import 'package:bb_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:bb_mobile/widgets/snackbar/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class VerifyForgotOtpView extends ConsumerStatefulWidget {
  final String email;
  const VerifyForgotOtpView({super.key, required this.email});

  @override
  ConsumerState<VerifyForgotOtpView> createState() => _VerifyForgotOtpViewState();
}

class _VerifyForgotOtpViewState extends ConsumerState<VerifyForgotOtpView> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final success = await ref.read(authNotifierProvider.notifier)
        .verifyForgotOtp(widget.email, _codeController.text.trim());

    setState(() => _isLoading = false);

    if (success && context.mounted) {   
      context.push('/reset-password', extra: widget.email);
    } else {
      SnackbarHelper.showSnackbar(context, "Kode OTP salah atau kadaluarsa", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verifikasi OTP")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "Masukkan kode OTP yang telah dikirim ke email Anda.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: "Kode OTP"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Kode OTP wajib diisi";
                  if (value.length != 6) return "Kode OTP harus 6 digit";
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
                      : const Text("Verifikasi Kode"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
