import 'dart:async';
import 'package:bb_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:bb_mobile/widgets/buttons/custom_button.dart';
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
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());

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
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
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
    final result =
        await ref.read(authNotifierProvider.notifier).verifyForgotOtp(widget.email, code);
    setState(() => isLoading = false);

    if (result && context.mounted) {
      SnackbarHelper.showSnackbar(context, 'OTP valid. Silakan atur ulang password Anda.');
      Future.delayed(const Duration(milliseconds: 500), () {
        context.push('/reset-password', extra: widget.email);
      });
    } else {
      SnackbarHelper.showSnackbar(context, 'OTP tidak valid atau sudah kedaluwarsa.', isError: true);
    }
  }

  Future<void> _resendOtp() async {
    setState(() => isResending = true);
    final result = await ref.read(authNotifierProvider.notifier).resendForgotOtp(widget.email);
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
        child: Column(
          children: [
            const Text(
              "Masukkan kode OTP yang dikirim ke email Anda untuk reset password.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),

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
            CustomButton(
              text: "Verifikasi",
              isLoading: isLoading,
              onPressed: _verifyOtp,
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
                          ? 'Kirim ulang OTP ($_secondsLeft detik)'
                          : 'Kirim ulang OTP',
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
