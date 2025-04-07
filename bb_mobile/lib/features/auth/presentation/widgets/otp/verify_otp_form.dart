import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class VerifyOtpForm extends ConsumerStatefulWidget {
  final String email;
  const VerifyOtpForm({super.key, required this.email});

  @override
  ConsumerState<VerifyOtpForm> createState() => _VerifyOtpFormState();
}

class _VerifyOtpFormState extends ConsumerState<VerifyOtpForm> {
  final _formKey = GlobalKey<FormState>();
  String code = '';
  bool isLoading = false;
  bool isResending = false;

  int _secondsLeft = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    setState(() => _secondsLeft = 60);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

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
        if (context.mounted) context.go('/login');
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

    if (result) {
      _startCountdown(); // ⏱️ Mulai hitung mundur
    }

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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Kode OTP",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock_outline),
            ),
            keyboardType: TextInputType.number,
            maxLength: 6,
            validator: (val) =>
                val == null || val.length != 6 ? "Kode OTP harus 6 digit" : null,
            onChanged: (val) => code = val,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: isLoading ? null : _verifyOtp,
              icon: const Icon(Icons.verified),
              label: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text("Verifikasi"),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: (_secondsLeft > 0 || isResending) ? null : _resendOtp,
              child: isResending
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_secondsLeft > 0
                      ? 'Kirim ulang kode ($_secondsLeft detik)'
                      : 'Kirim ulang kode'),
            ),
          ),
        ],
      ),
    );
  }
}
