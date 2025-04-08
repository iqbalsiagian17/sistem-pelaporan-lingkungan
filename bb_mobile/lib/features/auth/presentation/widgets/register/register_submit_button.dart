import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bb_mobile/routes/app_routes.dart';
import 'package:bb_mobile/widgets/buttons/custom_button.dart';

class RegisterSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isEnabled;
  final bool isLoading;

  const RegisterSubmitButton({
    super.key,
    required this.onPressed,
    required this.isEnabled,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          text: "Daftar",
          onPressed: isEnabled && !isLoading ? onPressed : null,
          isLoading: isLoading,
          color: const Color(0xFF66BB6A),     
          textColor: Colors.white,            
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Sudah memiliki akun? ",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            TextButton(
              onPressed: () {
                context.go(AppRoutes.login);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                "Masuk",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF66BB6A),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
