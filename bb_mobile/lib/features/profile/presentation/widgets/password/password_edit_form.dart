import 'package:bb_mobile/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:bb_mobile/routes/app_routes.dart';
import 'package:bb_mobile/widgets/input/custom_input_field.dart';
import 'package:bb_mobile/widgets/snackbar/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PasswordEditForm extends ConsumerStatefulWidget {
  const PasswordEditForm({super.key});

  @override
  ConsumerState<PasswordEditForm> createState() => _PasswordEditFormState();
}

class _PasswordEditFormState extends ConsumerState<PasswordEditForm> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final notifier = ref.read(userProfileProvider.notifier);
    final success = await notifier.changePassword(
      _oldPasswordController.text.trim(),
      _newPasswordController.text.trim(),
    );

    setState(() => _isSubmitting = false);

    if (!mounted) return;

    if (success) {
      SnackbarHelper.showSnackbar(context, "Password berhasil diperbarui!", isError: false, );
      context.go(AppRoutes.profile);
    } else {
      SnackbarHelper.showSnackbar(context, "Gagal memperbarui password", isError: true, );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomInputField(
            controller: _oldPasswordController,
            label: "Password Lama",
            icon: Icons.lock_outline,
            isObscure: _obscureOld,
            onToggleObscure: () => setState(() => _obscureOld = !_obscureOld),
            validator: (value) => value == null || value.isEmpty ? "Password lama wajib diisi" : null,
          ),
          CustomInputField(
            controller: _newPasswordController,
            label: "Password Baru",
            icon: Icons.lock_reset,
            isObscure: _obscureNew,
            onToggleObscure: () => setState(() => _obscureNew = !_obscureNew),
            validator: (value) => value == null || value.length < 6 ? "Minimal 6 karakter" : null,
          ),
          CustomInputField(
            controller: _confirmPasswordController,
            label: "Konfirmasi Password",
            icon: Icons.lock,
            isObscure: _obscureConfirm,
            onToggleObscure: () => setState(() => _obscureConfirm = !_obscureConfirm),
            validator: (value) =>
                value != _newPasswordController.text ? "Konfirmasi tidak cocok" : null,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF66BB6A),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Simpan", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
