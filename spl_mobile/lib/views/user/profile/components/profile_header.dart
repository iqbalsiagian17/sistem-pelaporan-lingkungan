import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ✅ Avatar Profil
        CircleAvatar(
          radius: 40,
          backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
          child: Text(
            "IS", // Inisial Nama
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),

        // ✅ Nama Pengguna
        const Text(
          "Iqbal Siagian",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),

        // ✅ Nomor HP
        const Text(
          "6281240417202",
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 5),

        // ✅ Email
        const Text(
          "iqbalsiagian2018@gmail.com",
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }
}
