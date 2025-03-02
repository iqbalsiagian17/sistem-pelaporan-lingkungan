import 'package:flutter/material.dart';
import 'components/register_header.dart';
import 'components/register_form.dart';
import 'components/social_register_buttons.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            floating: true,
            snap: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  RegisterHeader(),
                  SizedBox(height: 16),
                  RegisterForm(),
                  SizedBox(height: 16),
                  SocialRegisterButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
