import 'package:flutter/material.dart';
import 'components/profile_edit_form.dart';
import 'components/profile_edit_top_bar.dart';

class ProfileEditView extends StatelessWidget {
  const ProfileEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ProfileEditTopBar(title: "Edit Profil"),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: ProfileEditForm(), // ✅ Form edit profil
      ),
    );
  }
}
