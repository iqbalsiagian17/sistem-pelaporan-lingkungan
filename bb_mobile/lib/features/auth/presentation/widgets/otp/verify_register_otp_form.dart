import 'dart:async';
import 'package:bb_mobile/widgets/snackbar/snackbar_helper.dart';
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
  final List<FocusNode> _focusNodes =
      List.generate(6, (_) => FocusNode()); // 6 OTP digit
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());

  bool isLoading = false;
  bool isResending = false;
  int _secondsLeft = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
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
    final code = _controllers.map((c) => c.text).join();
    if (code.length != 6 || code.contains(RegExp(r'[^0-9]'))) {
      SnackbarHelper.showSnackbar(context, 'Kode OTP harus 6 digit angka.', isError: true);
      return;
    }

    setState(() => isLoading = true);
    final result = await ref.read(authNotifierProvider.notifier).verifyOtp(widget.email, code);
    setState(() => isLoading = false);

    if (result) {
      SnackbarHelper.showSnackbar(
        context,
        'Verifikasi berhasil! Silakan login.',
        isError: false,
      );
      Future.delayed(const Duration(milliseconds: 600), () {
        if (context.mounted) context.go('/login');
      });
    } else {
      SnackbarHelper.showSnackbar(
        context,
        'OTP tidak valid atau sudah kedaluwarsa.',
        isError: true,
      );
    }
  }

  Future<void> _resendOtp() async {
    setState(() => isResending = true);
    final result = await ref.read(authNotifierProvider.notifier).resendOtp(widget.email);
    setState(() => isResending = false);

    if (result) {
      _startCountdown();
      SnackbarHelper.showSnackbar(context, 'OTP baru telah dikirim ke email.');
    } else {
      SnackbarHelper.showSnackbar(context, 'Gagal mengirim ulang OTP.', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// 🔢 OTP Boxes
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (i) {
            return SizedBox(
              width: 48,
              child: TextField(
                controller: _controllers[i],
                focusNode: _focusNodes[i],
                maxLength: 1,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  counterText: "",
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty && i < 5) {
                    _focusNodes[i + 1].requestFocus();
                  } else if (value.isEmpty && i > 0) {
                    _focusNodes[i - 1].requestFocus();
                  }
                },
              ),
            );
          }),
        ),

        const SizedBox(height: 24),

        /// 🔘 Verifikasi Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF66BB6A),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
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

        /// 🔁 Resend OTP
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
                      ? 'Kirim ulang kode ($_secondsLeft detik)'
                      : 'Kirim ulang kode',
                ),
        ),
      ],
    );
  }
}
