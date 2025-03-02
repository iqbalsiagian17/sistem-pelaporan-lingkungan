import 'package:flutter/material.dart';
import 'components/password_edit_form.dart';
import './components/password_edit_top_bar.dart';

class PasswordEditView extends StatelessWidget {
  const PasswordEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ Background putih
      appBar: const PasswordEditTopBar(title: "Ubah Password"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: const PasswordEditForm(),
      ),
    );
  }
}
