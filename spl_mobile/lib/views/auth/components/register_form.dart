import 'package:flutter/material.dart';
import '../../../core/utils/validators.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _usernameController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      // ✅ Jika semua input valid, lanjutkan proses registrasi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registrasi berhasil!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, // 🔑 Form Key untuk validasi
      child: Column(
        children: [
          const SizedBox(height: 24),

          // 📱 Nomor Telepon
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.phone_outlined),
              labelText: 'Nomor Telepon',
              border: OutlineInputBorder(),
            ),
            validator: Validators.validatePhone,
          ),
          const SizedBox(height: 16),

          // 👤 Username
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_outline),
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
            validator: (value) => Validators.validateNotEmpty(value, fieldName: 'Username'),
          ),
          const SizedBox(height: 16),

          // 🧑‍💼 Nama Lengkap
          TextFormField(
            controller: _fullNameController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.badge_outlined),
              labelText: 'Nama Lengkap',
              border: OutlineInputBorder(),
            ),
            validator: (value) => Validators.validateNotEmpty(value, fieldName: 'Nama Lengkap'),
          ),
          const SizedBox(height: 16),

          // 🔒 Password
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
          const SizedBox(height: 16),

          // 🔒 Konfirmasi Password
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

          // ✅ Tombol Daftar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Daftar", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
