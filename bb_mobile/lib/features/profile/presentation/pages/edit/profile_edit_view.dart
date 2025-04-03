import 'package:bb_mobile/features/profile/presentation/widgets/edit/profile_edit_form.dart';
import 'package:bb_mobile/features/profile/presentation/widgets/edit/profile_edit_top_bar.dart';
import 'package:flutter/material.dart';

class ProfileEditView extends StatelessWidget {
  const ProfileEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ProfileEditTopBar(title: "Edit Profil"),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: ProfileEditForm(),
      ),
    );
  }
}
