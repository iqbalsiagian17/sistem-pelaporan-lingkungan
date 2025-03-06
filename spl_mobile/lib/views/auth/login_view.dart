import 'package:flutter/material.dart';
import 'components/login_header.dart';
import 'components/login_form.dart';
import 'components/social_buttons.dart';
import 'components/login_footer.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              LoginHeader(),
              LoginForm(),
              SizedBox(height: 16),
              SocialButtons(),
              SizedBox(height: 24),
              LoginFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
