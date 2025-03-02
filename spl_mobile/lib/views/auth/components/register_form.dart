import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/validators.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/show_snackbar.dart'; // ✅ Impor SnackbarHelper
import 'package:flutter/services.dart';


class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

void _register() async {
  if (_formKey.currentState!.validate()) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool success = await authProvider.register(
      _phoneController.text.trim(),
      _usernameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success) {
      // ✅ Hapus data di input field
      _phoneController.clear();
      _usernameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();

      // ✅ Tampilkan notifikasi sukses
      SnackbarHelper.showSnackbar(context, "Registrasi berhasil! Silakan login.", isError: false);

      // 🔥 **Gunakan pushReplacement untuk mengganti halaman**
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          print("✅ Menggunakan pushReplacement ke /login...");
          context.pushReplacement("/login");
        }
      });
    } else {
      // ❌ Tampilkan notifikasi error jika registrasi gagal
      SnackbarHelper.showSnackbar(context, "Registrasi gagal. Coba lagi!", isError: true);
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
            controller: _phoneController,
            keyboardType: TextInputType.phone, // ✅ Keyboard khusus nomor telepon
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, // ✅ Hanya angka
              LengthLimitingTextInputFormatter(15), // ✅ Maksimal 15 digit (sesuai standar internasional)
            ],
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.phone),
              labelText: 'Nomor Telepon',
              border: OutlineInputBorder(),
            ),
            validator: Validators.validatePhone, // ✅ Gunakan validator jika perlu
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person),
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
            validator: Validators.validateNotEmpty,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email),
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            validator: Validators.validateEmail,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.lock),
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            validator: Validators.validatePassword,
          ),
          const SizedBox(height: 16),
          // ✅ Konfirmasi Password
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.lock_outline),
              labelText: 'Konfirmasi Password',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Konfirmasi password tidak boleh kosong';
              }
              if (value != _passwordController.text) {
                return 'Password tidak cocok';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Consumer<AuthProvider>(
            builder: (context, auth, child) {
              return SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: auth.isLoading ? null : _register,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Color(0xFF6c757d)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    foregroundColor: const Color(0xFF6c757d),
                  ).copyWith(
                    overlayColor: WidgetStateProperty.all(
                      const Color.fromRGBO(227, 233, 250, 1),
                    ),
                  ),
                  child: auth.isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          "Daftar",
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
