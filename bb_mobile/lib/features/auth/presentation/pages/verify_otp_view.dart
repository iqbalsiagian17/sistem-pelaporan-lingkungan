import 'package:bb_mobile/features/auth/presentation/widgets/otp/verify_otp_form.dart';
import 'package:bb_mobile/features/auth/presentation/widgets/otp/verify_otp_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerifyOtpView extends ConsumerWidget {
  final String email;
  const VerifyOtpView({super.key, required this.email});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Verifikasi Email"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VerifyOtpHeader(email: email),
            const SizedBox(height: 20),
            VerifyOtpForm(email: email),
          ],
        ),
      ),
    );
  }
}
