import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isObscure;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final VoidCallback? onToggleObscure;
  final List<TextInputFormatter>? inputFormatters;

  const CustomInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isObscure = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onToggleObscure,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure,
        keyboardType: keyboardType,
        validator: validator,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.black87),
          suffixIcon: onToggleObscure != null
              ? IconButton(
                  icon: Icon(
                    isObscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black87,
                  ),
                  onPressed: onToggleObscure,
                )
              : null,
          filled: true,
          fillColor: Colors.white, // ✅ **Selalu putih**
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.green, width: 1.8),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.8),
          ),
        ),
      ),
    );
  }
}
