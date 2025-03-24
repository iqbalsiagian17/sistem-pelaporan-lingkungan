import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../../providers/user/user_profile_provider.dart'; // ✅ Gunakan UserProfileProvider
import '../../../../../routes/app_routes.dart';
import '../../../../../widgets/snackbar/snackbar_helper.dart';
import '../../../../../widgets/input/custom_input_field.dart'; // ✅ Import CustomInputField

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
    if (!_formKey.currentState!.validate()) return;

    final profileProvider = Provider.of<UserProfileProvider>(context, listen: false);

    bool success = await profileProvider.changePassword(
      _oldPasswordController.text.trim(),
      _newPasswordController.text.trim(),
    );

    if (success) {
      if (mounted) {
        SnackbarHelper.showSnackbar(context, "Password berhasil diperbarui!", isError: false);
      }

      // ✅ Pastikan data user diperbarui setelah ubah password
      await profileProvider.refreshUser();

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

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, profileProvider, child) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomInputField(
                controller: _oldPasswordController,
                label: "Password Lama",
                icon: Icons.lock_outline,
                isObscure: _isObscureOld,
                onToggleObscure: () => setState(() => _isObscureOld = !_isObscureOld),
                validator: (value) => value!.isEmpty ? "Password lama tidak boleh kosong" : null,
              ),
              CustomInputField(
                controller: _newPasswordController,
                label: "Password Baru",
                icon: Icons.lock_reset,
                isObscure: _isObscureNew,
                onToggleObscure: () => setState(() => _isObscureNew = !_isObscureNew),
                validator: (value) => value!.length < 6 ? "Password minimal 6 karakter" : null,
              ),
              CustomInputField(
                controller: _confirmPasswordController,
                label: "Konfirmasi Password",
                icon: Icons.lock,
                isObscure: _isObscureConfirm,
                onToggleObscure: () => setState(() => _isObscureConfirm = !_isObscureConfirm),
                validator: (value) => value != _newPasswordController.text ? "Password tidak cocok" : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: profileProvider.isLoading ? null : _changePassword, // ✅ Nonaktifkan tombol jika loading
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // ✅ Warna tombol hijau
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: profileProvider.isLoading
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
}
