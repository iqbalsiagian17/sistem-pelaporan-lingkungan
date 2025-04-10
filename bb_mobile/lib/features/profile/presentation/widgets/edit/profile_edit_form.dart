import 'package:bb_mobile/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:bb_mobile/widgets/input/custom_input_field.dart';
import 'package:bb_mobile/widgets/snackbar/snackbar_helper.dart' show SnackbarHelper;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/core/utils/validators.dart';
import 'package:bb_mobile/routes/app_routes.dart';

class ProfileEditForm extends ConsumerStatefulWidget {
  const ProfileEditForm({super.key});

  @override
  ConsumerState<ProfileEditForm> createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends ConsumerState<ProfileEditForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final userState = ref.read(userProfileProvider);
      userState.whenData((user) {
        if (mounted) {
          _usernameController.text = user.username;
          _emailController.text = user.email;
          _phoneController.text = user.phoneNumber;
        }
      });
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final success = await ref.read(userProfileProvider.notifier).updateProfile({
      "username": _usernameController.text.trim(),
      "email": _emailController.text.trim(),
      "phone_number": _phoneController.text.trim(),
    });

    setState(() => _isSaving = false);

    if (!mounted) return;

    if (success) {
      SnackbarHelper.showSnackbar(context, "Profil berhasil diperbarui!", isError: false , );
      context.go(AppRoutes.profile);
    } else {
      SnackbarHelper.showSnackbar(
        context,
        "Gagal memperbarui profil",
        isError: true,
      );
    }
  }

  @override
Widget build(BuildContext context) {
  final userState = ref.watch(userProfileProvider);

  return userState.when(
    data: (user) {
      final isGoogleUser = user.authProvider == 'google';

      return Form(
        key: _formKey,
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
                  backgroundColor: Color(0xFF66BB6A),
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
      );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (err, stack) => Center(child: Text("Gagal memuat data: $err")),
  );
}

}
