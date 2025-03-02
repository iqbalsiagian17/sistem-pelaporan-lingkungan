import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../../providers/user_password_provider.dart'; // ✅ Gunakan UserPasswordProvider
import '../../../../../routes/app_routes.dart';
import '../../../../../widgets/show_snackbar.dart';

class PasswordEditForm extends StatefulWidget {
  const PasswordEditForm({super.key});

  @override
  State<PasswordEditForm> createState() => _PasswordEditFormState();
}

class _PasswordEditFormState extends State<PasswordEditForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isObscureOld = true;
  bool _isObscureNew = true;
  bool _isObscureConfirm = true;

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      final passwordProvider = Provider.of<UserPasswordProvider>(context, listen: false);
      
      bool success = await passwordProvider.updatePassword(
        _oldPasswordController.text.trim(),
        _newPasswordController.text.trim(),
      );

      if (success) {
        if (mounted) {
          SnackbarHelper.showSnackbar(context, "Password berhasil diperbarui!", isError: false);
        }

        // ✅ Redirect ke halaman profil setelah sukses
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            context.go(AppRoutes.profile);
          }
        });
      } else {
        if (mounted) {
          SnackbarHelper.showSnackbar(context, "Gagal mengubah password", isError: true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserPasswordProvider>(
      builder: (context, passwordProvider, child) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPasswordField(_oldPasswordController, "Password Lama", _isObscureOld, () {
                setState(() {
                  _isObscureOld = !_isObscureOld;
                });
              }),
              _buildPasswordField(_newPasswordController, "Password Baru", _isObscureNew, () {
                setState(() {
                  _isObscureNew = !_isObscureNew;
                });
              }),
              _buildPasswordField(_confirmPasswordController, "Konfirmasi Password", _isObscureConfirm, () {
                setState(() {
                  _isObscureConfirm = !_isObscureConfirm;
                });
              }),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: passwordProvider.isLoading ? null : _changePassword, // ✅ Nonaktifkan tombol jika loading
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // ✅ Warna tombol hijau
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: passwordProvider.isLoading
                      ? const CircularProgressIndicator(color: Colors.white) // ✅ Loading indicator
                      : const Text("Simpan", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label, bool isObscure, VoidCallback toggleObscure) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
            onPressed: toggleObscure,
          ),
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white, // ✅ Background putih
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$label tidak boleh kosong";
          }
          if (label == "Password Baru" && value.length < 6) {
            return "Password minimal 6 karakter";
          }
          if (label == "Konfirmasi Password" && value != _newPasswordController.text) {
            return "Password tidak cocok";
          }
          return null;
        },
      ),
    );
  }
}
