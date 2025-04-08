import 'dart:async';

import 'package:bb_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:bb_mobile/widgets/snackbar/snackbar_helper.dart';
import 'package:bb_mobile/widgets/buttons/custom_button.dart';
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
  String code = '';
  bool isLoading = false;
  bool isResending = false;

  int _secondsLeft = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

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
          .verifyForgotOtp(widget.email, code);
      setState(() => isLoading = false);

      if (result && context.mounted) {
        SnackbarHelper.showSnackbar(
          context,
          'OTP valid. Silakan atur ulang password Anda.',
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          context.push('/reset-password', extra: widget.email);
        });
      } else {
        SnackbarHelper.showSnackbar(
          context,
          'OTP tidak valid atau sudah kedaluwarsa.',
          isError: true,
        );
      }
    }
  }

  Future<void> _resendOtp() async {
    setState(() => isResending = true);
    final result = await ref
        .read(authNotifierProvider.notifier)
        .resendForgotOtp(widget.email);
    setState(() => isResending = false);

    if (result) {
      _startCountdown();
      SnackbarHelper.showSnackbar(context, 'OTP baru telah dikirim ke email Anda.');
    } else {
      SnackbarHelper.showSnackbar(context, 'Gagal mengirim ulang OTP.', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        title: const Text("Verifikasi OTP"),
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
                "Masukkan kode OTP yang dikirim ke email Anda untuk reset password.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 24),
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
              const SizedBox(height: 24),
              CustomButton(
                text: "Verifikasi",
                icon: const Icon(Icons.verified),
                isLoading: isLoading,
                onPressed: _verifyOtp,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: (_secondsLeft > 0 || isResending) ? null : _resendOtp,
                child: isResending
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        _secondsLeft > 0
                            ? 'Kirim ulang OTP ($_secondsLeft detik)'
                            : 'Kirim ulang OTP',
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
