import 'package:bb_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:bb_mobile/features/auth/presentation/widgets/register/terms_modal_bottomsheet.dart';
import 'package:bb_mobile/features/parameter/domain/entities/parameter_entity.dart';
import 'package:bb_mobile/features/parameter/presentation/providers/parameter_provider.dart';
import 'package:bb_mobile/widgets/snackbar/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'register_phone_field.dart';
import 'register_email_field.dart';
import 'register_username_field.dart';
import 'register_password_fields.dart';
import 'register_confirm_password_field.dart';
import 'register_terms_checkbox.dart';
import 'register_submit_button.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

  bool _isEmailFocused = false;
  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;
  bool _isAgreedToTerms = false;
  bool _showTermsError = false;


  String? _emailError, _usernameError, _phoneError;

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      setState(() => _isEmailFocused = _emailFocusNode.hasFocus);
    });

    Future.microtask(() {
      ref.read(parameterNotifierProvider.notifier).fetchParameter();
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_isAgreedToTerms) {
      setState(() => _showTermsError = true);
      return;
    }


    setState(() {
      _emailError = null;
      _usernameError = null;
      _phoneError = null;
    });

    final email = _emailController.text.trim();
    final success = await ref.read(authNotifierProvider.notifier).register(
          _phoneController.text.trim(),
          _usernameController.text.trim(),
          email,
          _passwordController.text.trim(),
        );

    if (success) {
      _phoneController.clear();
      _usernameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();

      SnackbarHelper.showSnackbar(
        context,
        "Registrasi berhasil! Silakan verifikasi email Anda.",
        isError: false,
      );

      Future.delayed(const Duration(seconds: 1), () {
        if (context.mounted) context.push("/verify-otp", extra: email);
      });
    } else {
      final authState = ref.read(authNotifierProvider);
      final rawError = authState.asError?.error.toString() ?? "";
      final error = rawError.replaceFirst("Exception: ", "");

      setState(() {
        _emailError = error.contains("Email") ? error : null;
        _usernameError = error.contains("Username") ? error : null;
        _phoneError = error.contains("telepon") || error.contains("nomor") ? error : null;
      });

      if (_emailError == null && _usernameError == null && _phoneError == null) {
        SnackbarHelper.showSnackbar(context, "Registrasi gagal. Coba lagi!", isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          RegisterPhoneField(controller: _phoneController, errorText: _phoneError),
          const SizedBox(height: 8),
          RegisterEmailField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            isFocused: _isEmailFocused,
            errorText: _emailError,
          ),
          const SizedBox(height: 8),
          RegisterUsernameField(controller: _usernameController, errorText: _usernameError),
          const SizedBox(height: 8),
          RegisterPasswordFields(
            passwordController: _passwordController,
            isObscure: _isObscurePassword,
            onToggleObscure: () => setState(() => _isObscurePassword = !_isObscurePassword),
          ),
          const SizedBox(height: 8),
          RegisterConfirmPasswordField(
            confirmPasswordController: _confirmPasswordController,
            passwordController: _passwordController,
            isObscure: _isObscureConfirmPassword,
            onToggleObscure: () => setState(() => _isObscureConfirmPassword = !_isObscureConfirmPassword),
          ),
          const SizedBox(height: 8),
          RegisterTermsCheckbox(
            value: _isAgreedToTerms,
            onChanged: (val) {
              setState(() {
                _isAgreedToTerms = val ?? false;
                if (_isAgreedToTerms) {
                  _showTermsError = false;
                }
              });
            },
            onShowTerms: _showTermsModal,
          ),

          if (_showTermsError)
            const Padding(
              padding: EdgeInsets.only(left: 12.0, top: 4.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Anda harus menyetujui syarat & ketentuan.",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            ),
          const SizedBox(height: 8),
            
          RegisterSubmitButton(
            isLoading: authState.isLoading,
            isEnabled: _isAgreedToTerms,
            onPressed: _register,
          ),
        ],
      ),
    );
  }

  Future<void> _showTermsModal() async {
    final asyncValue = ref.read(parameterNotifierProvider);

    if (asyncValue is! AsyncData<ParameterEntity>) {
      SnackbarHelper.showSnackbar(context, "Syarat dan ketentuan belum tersedia.", isError: true);
      await ref.read(parameterNotifierProvider.notifier).fetchParameter();
      return;
    }

    final termsContent = asyncValue.value?.terms ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => TermsModalBottomSheet(content: termsContent),
    );
  }
}
