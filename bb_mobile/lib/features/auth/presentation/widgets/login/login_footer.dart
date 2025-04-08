import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bb_mobile/routes/app_routes.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 50),
        const Text(
          "Belum punya akun? ",
          style: TextStyle(fontSize: 14),
        ),
        TextButton(
          onPressed: () {
            context.push(AppRoutes.register);
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero, // hilangkan jarak default
            minimumSize: Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            "Daftar dengan email",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF4CAF50),
            ),
          ),
        ),
      ],
    );
  }
}
