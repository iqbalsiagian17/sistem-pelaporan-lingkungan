import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 🖼️ Logo atau gambar di atas
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: mediaQuery.size.height * 0.2,
                ),
              ),
              const SizedBox(height: 30),

              // 📝 Judul halaman
              const Text(
                "Horas !!!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Silakan masuk untuk melanjutkan",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // 📧 Input Email
              const TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 🔒 Input Password
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // 🔑 Tombol Login
              OutlinedButton(
                onPressed: () {
                  // TODO: Tambahkan aksi login
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFF6c757d)), 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  foregroundColor: const Color(0xFF6c757d), 
                  backgroundColor: Colors.transparent, 
                ).copyWith(
                    overlayColor: WidgetStateProperty.resolveWith<Color?>(
                      (states) {
                        if (states.contains(WidgetState.hovered) ||
                            states.contains(WidgetState.pressed)) {
                          return const Color.fromRGBO(227, 233, 250, 1); // ✅ Hover effect
                        }
                        return null;
                      },
                    ),
                  ),
                child: const Text(
                  "Masuk",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),

              // 🧭 Divider dengan tulisan "Atau"
              Row(
                children: [
                  const Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Atau",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 🧑‍💻 Tombol Login dengan Google
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Integrasikan login Google
                },
                icon: Image.asset(
                  'assets/images/google.png',
                  height: 24,
                ),
                label: const Text(
                  "Masuk dengan Google",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6c757d), // ✅ Warna teks #6c757d
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFF6c757d)), // ✅ Border warna #6c757d
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  foregroundColor: const Color(0xFF6c757d), // ✅ Warna teks dan ikon
                  backgroundColor: Colors.transparent, // ✅ Background transparan
                ).copyWith(
                  overlayColor: WidgetStateProperty.resolveWith<Color?>(
                    (states) {
                      if (states.contains(WidgetState.hovered) ||
                          states.contains(WidgetState.pressed)) {
                        return const Color.fromRGBO(227, 233, 250, 1); // ✅ Warna hover
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 🔑 Tombol Login dengan Facebook

              // 🔗 Navigasi ke halaman register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum punya akun?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterView()),
                      );
                    },
                    child: const Text(
                      "Daftar",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('onboardingCompleted');

                      if (!context.mounted) return; // ✅ Cara baru yang direkomendasikan (Flutter 3.7+)

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Onboarding direset. Restart aplikasi!")),
                      );
                    },
                    child: const Text("Reset Onboarding"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
