import 'package:flutter/material.dart';
import '../../home/home_view.dart';
import '../../../core/utils/validators.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HomeView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, // 🔑 Form Key untuk validasi
      child: Column(
        children: [
          // 📧 Email Field
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email_outlined),
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            validator: Validators.validateEmail,
          ),
          const SizedBox(height: 16),

          // 🔒 Password Field
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.lock_outline),
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            validator: Validators.validatePassword,
          ),
          const SizedBox(height: 24),

          // 🔑 Tombol "Masuk" dengan validasi
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _login,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Color(0xFF6c757d)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                foregroundColor: const Color(0xFF6c757d),
              ).copyWith(
                overlayColor: WidgetStateProperty.all(const Color.fromRGBO(227, 233, 250, 1)),
              ),
              child: const Text(
                "Masuk",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
