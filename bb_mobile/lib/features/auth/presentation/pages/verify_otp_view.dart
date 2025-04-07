import 'package:bb_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerifyOtpView extends ConsumerStatefulWidget {
  final String email;
  const VerifyOtpView({super.key, required this.email});

  @override
  ConsumerState<VerifyOtpView> createState() => _VerifyOtpViewState();
}

class _VerifyOtpViewState extends ConsumerState<VerifyOtpView> {
  final _formKey = GlobalKey<FormState>();
  String code = '';
  bool isLoading = false;
  bool isResending = false;

  Future<void> _verifyOtp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      final result = await ref
          .read(authNotifierProvider.notifier)
          .verifyOtp(widget.email, code);
      setState(() => isLoading = false);

      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ OTP berhasil diverifikasi!')),
        );
        if (context.mounted) Navigator.of(context).pop(); // Atau redirect ke login
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ OTP tidak valid atau gagal')),
        );
      }
    }
  }

  Future<void> _resendOtp() async {
    setState(() => isResending = true);
    final result = await ref
        .read(authNotifierProvider.notifier)
        .resendOtp(widget.email);
    setState(() => isResending = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result
            ? '✅ OTP baru telah dikirim ke email.'
            : '❌ Gagal mengirim ulang OTP.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verifikasi Email")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Masukkan kode OTP yang telah kami kirimkan ke:",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                widget.email,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Kode OTP",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                keyboardType: TextInputType.number,
                maxLength: 6,
                validator: (val) => val == null || val.length != 6
                    ? "Kode OTP harus 6 digit"
                    : null,
                onChanged: (val) => code = val,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: isLoading ? null : _verifyOtp,
                icon: const Icon(Icons.verified),
                label: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Verifikasi"),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: isResending ? null : _resendOtp,
                  child: isResending
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Kirim ulang kode"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
