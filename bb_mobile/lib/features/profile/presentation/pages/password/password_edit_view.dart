import 'package:bb_mobile/features/profile/presentation/widgets/password/password_edit_form.dart';
import 'package:bb_mobile/features/profile/presentation/widgets/password/password_edit_top_bar.dart';
import 'package:flutter/material.dart';

class PasswordEditView extends StatelessWidget {
  const PasswordEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PasswordEditTopBar(title: "Ubah Password"),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: PasswordEditForm(),
      ),
    );
  }
}
