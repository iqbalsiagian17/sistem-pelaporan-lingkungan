import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utils/validators.dart';
import '../../../providers/auth_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/show_snackbar.dart'; // ✅ Impor SnackbarHelper

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      bool success = await authProvider.login(
        _identifierController.text.trim(),
        _passwordController.text.trim(),
      );

      if (success) {
        // ✅ Simpan status login
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        // ✅ Tampilkan notifikasi sukses
        SnackbarHelper.showSnackbar(context, "Login berhasil!", isError: false);

        // ✅ Navigasi harus dijalankan dalam `Future.microtask`
        Future.microtask(() {
          if (mounted) {
            context.go(AppRoutes.home);
          }
        });
      } else {
        // ❌ Tampilkan notifikasi error jika login gagal
        SnackbarHelper.showSnackbar(context, "Login gagal. Periksa email/nomor telepon dan password!", isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _identifierController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_outline),
              labelText: 'Email atau Nomor Telepon',
              border: OutlineInputBorder(),
            ),
            validator: Validators.validateEmailOrPhone,
          ),
          const SizedBox(height: 16),
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
          Consumer<AuthProvider>(
            builder: (context, auth, child) {
              return SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: auth.isLoading ? null : _login,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Color(0xFF6c757d)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    foregroundColor: const Color(0xFF6c757d),
                  ).copyWith(
                    overlayColor: WidgetStateProperty.all(
                        const Color.fromRGBO(227, 233, 250, 1)),
                  ),
                  child: auth.isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          "Masuk",
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
