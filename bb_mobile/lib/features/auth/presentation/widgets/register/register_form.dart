import 'package:bb_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bb_mobile/core/utils/validators.dart';
import 'package:bb_mobile/widgets/input/custom_input_field.dart';
import 'package:bb_mobile/widgets/buttons/custom_button.dart';
import 'package:bb_mobile/widgets/snackbar/snackbar_helper.dart';

import 'package:bb_mobile/features/parameter/presentation/providers/parameter_provider.dart';
import 'package:bb_mobile/features/parameter/presentation/pages/terms/components/terms_data_empty_state.dart';
import 'package:bb_mobile/features/parameter/presentation/pages/terms/components/terms_data_state.dart';



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

  String? _emailError;
  String? _usernameError;
  String? _phoneError;

  bool _isAgreedToTerms = false; // Menyimpan status checkbox

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      setState(() {
        _isEmailFocused = _emailFocusNode.hasFocus;
      });
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
      SnackbarHelper.showSnackbar(context, "Anda harus setuju dengan syarat dan ketentuan terlebih dahulu.", isError: true);
      return; // Jangan lanjutkan jika belum setuju dengan syarat dan ketentuan
    }

    setState(() {
      _emailError = null;
      _usernameError = null;
      _phoneError = null;
    });

    final notifier = ref.read(authNotifierProvider.notifier);
    final email = _emailController.text.trim();

    final success = await notifier.register(
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
        SnackbarHelper.showSnackbar(
          context,
          "Registrasi gagal. Coba lagi!",
          isError: true,
        );
      }
    }
  }

  void _showTermsModal() async {
    final parameterAsync = ref.watch(parameterNotifierProvider);

    // Menunggu data parameter untuk ditampilkan dalam modal
    final termsContent = await parameterAsync.when(
      loading: () => null, // Menunggu loading
      error: (err, _) => 'Terjadi kesalahan saat memuat syarat dan ketentuan.', // Menangani error
      data: (parameter) {
        return parameter.terms; // Mengambil data syarat dan ketentuan
      },
    );

    if (termsContent == null || termsContent.isEmpty) {
      // Menampilkan modal jika tidak ada syarat dan ketentuan
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Syarat dan Ketentuan'),
          content: const TermsDataEmptyState(),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup modal
              },
              child: const Text('Tutup'),
            ),
          ],
        ),
      );
    } else {
      // Menampilkan modal dengan syarat dan ketentuan
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Syarat dan Ketentuan'),
          content: TermsDataState(content: termsContent!),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup modal
              },
              child: const Text('Tutup'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomInputField(
            controller: _phoneController,
            label: 'Nomor Telepon',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            validator: Validators.validatePhone,
            errorText: _phoneError,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(15),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomInputField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email,
                focusNode: _emailFocusNode,
                validator: Validators.validateEmail,
                errorText: _emailError,
              ),
              if (_isEmailFocused)
                const Padding(
                  padding: EdgeInsets.only(left: 8, top: 0),
                  child: Text(
                    "Gunakan email aktif karena kode verifikasi akan dikirim ke email tersebut.",
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
          CustomInputField(
            controller: _usernameController,
            label: 'Username',
            icon: Icons.person,
            validator: Validators.validateNotEmpty,
            errorText: _usernameError,
          ),
          CustomInputField(
            controller: _passwordController,
            label: 'Password',
            icon: Icons.lock,
            isObscure: _isObscurePassword,
            onToggleObscure: () => setState(() => _isObscurePassword = !_isObscurePassword),
            validator: Validators.validatePassword,
          ),
          CustomInputField(
            controller: _confirmPasswordController,
            label: 'Konfirmasi Password',
            icon: Icons.lock_outline,
            isObscure: _isObscureConfirmPassword,
            onToggleObscure: () => setState(() => _isObscureConfirmPassword = !_isObscureConfirmPassword),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Konfirmasi password tidak boleh kosong';
              if (value != _passwordController.text) return 'Password tidak cocok';
              return null;
            },
          ),
          // Tambahkan checkbox dan label
          Row(
            children: [
              Checkbox(
                value: _isAgreedToTerms,
                onChanged: (bool? value) {
                  setState(() {
                    _isAgreedToTerms = value ?? false;
                  });
                },
              ),
              const Text(
                'Saya setuju dengan ',
                style: TextStyle(fontSize: 12),
              ),
              // Teks yang bisa di-tap untuk membuka modal syarat dan ketentuan
              GestureDetector(
                onTap: _showTermsModal, // Memunculkan modal syarat dan ketentuan
                child: const Text(
                  'syarat dan ketentuan',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          CustomButton(
            text: "Daftar",
            onPressed: authState.isLoading || !_isAgreedToTerms ? null : _register, // Disable button jika belum setuju
            isLoading: authState.isLoading,
            isOutlined: true,
            textColor: const Color(0xFF6c757d),
            borderColor: const Color(0xFF6c757d),
          ),
        ],
      ),
    );
  }
}