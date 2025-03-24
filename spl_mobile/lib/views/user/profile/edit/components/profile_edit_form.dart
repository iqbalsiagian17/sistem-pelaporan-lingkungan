import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/routes/app_routes.dart';
import '../../../../../providers/auth/auth_provider.dart';
import '../../../../../providers/user/user_profile_provider.dart';
import '../../../../../widgets/snackbar/snackbar_helper.dart';
import '../../../../../widgets/input/custom_input_field.dart'; // ✅ Import Global Input
import '../../../../../core/utils/validators.dart'; 

class ProfileEditForm extends StatefulWidget {
  const ProfileEditForm({super.key});

  @override
  State<ProfileEditForm> createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<ProfileEditForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final authProvider = context.read<AuthProvider>();
      final profileProvider = context.read<UserProfileProvider>();

      await profileProvider.loadUser(); 

      if (!mounted) return;

      final user = authProvider.user;

      if (user != null) {
        _usernameController.text = user.username;
        _emailController.text = user.email;
        _phoneController.text = user.phoneNumber;
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isSaving = true);

  final profileProvider = context.read<UserProfileProvider>();
  final authProvider = context.read<AuthProvider>();

  bool success = await profileProvider.saveUser({
    "username": _usernameController.text.trim(),
    "email": _emailController.text.trim(),
    "phone_number": _phoneController.text.trim(),
  });

  if (!mounted) return;
  setState(() => _isSaving = false);

  if (success) {
    await profileProvider.refreshUser(); // ✅ Pastikan data user diperbarui setelah update
    await authProvider.refreshUser(); // ✅ Pastikan authProvider juga mendapatkan data terbaru

    SnackbarHelper.showSnackbar(context, "Profil berhasil diperbarui!", isError: false);
    Future.microtask(() => context.go(AppRoutes.profile)); // ✅ Kembali ke halaman profil setelah update
  } else {
    SnackbarHelper.showSnackbar(context, "Gagal memperbarui profil", isError: true);
  }
}



  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, UserProfileProvider>(
      builder: (context, authProvider, profileProvider, child) {
final isGoogleUser = profileProvider.user?.authProvider == 'google';

        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Informasi Akun", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                
                CustomInputField(
                  controller: _usernameController,
                  label: "Username",
                  icon: Icons.person,
                  validator: (value) => value!.isEmpty ? "Username tidak boleh kosong" : null,
                ),
if (!isGoogleUser)
                CustomInputField(
                  controller: _emailController,
                  label: "Email",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                ),
                CustomInputField(
                  controller: _phoneController,
                  label: "Nomor Telepon",
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: Validators.validatePhone,
                ),

                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSaving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Simpan", style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
