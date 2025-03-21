class User {
  final int id;
  final String username;
  final String email;
  final String phoneNumber;
  final String? password;
  final int type;
  final DateTime? blockedUntil;
  final String authProvider; // 🔥 Pastikan ini tidak nullable

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    this.type = 0,
    this.blockedUntil,
    this.authProvider = 'manual', // 🔥 Default jadi 'manual'
    this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // ✅ Debug jika gagal parsing tanggal
    DateTime? parsedBlockedUntil;
    if (json["blocked_until"] != null) {
      parsedBlockedUntil = DateTime.tryParse(json["blocked_until"]);
      if (parsedBlockedUntil == null) {
        print("⚠️ Gagal parsing blocked_until: ${json["blocked_until"]}");
      }
    }

    return User(
      id: json["id"] ?? 0,
      username: json["username"] ?? "Tidak diketahui",
      email: json["email"] ?? "Tidak ada email",
      phoneNumber: json["phone_number"] ?? "Tidak ada nomor",
      type: json["type"] ?? 0,
      blockedUntil: parsedBlockedUntil,
      authProvider: json["auth_provider"] ?? 'manual', // 🔥 Pastikan selalu ada nilai
      password: json["password"] ?? "", // 🔥 Hindari `null` pada password
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "phone_number": phoneNumber,
      "type": type,
      "blocked_until": blockedUntil?.toIso8601String(),
      "auth_provider": authProvider,
    };
  }

  // ✅ Tambahkan `copyWith` untuk update data tanpa membuat ulang instance
  User copyWith({
    int? id,
    String? username,
    String? email,
    String? phoneNumber,
    int? type,
    DateTime? blockedUntil,
    String? authProvider, // 🔥 Tambahkan authProvider
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      type: type ?? this.type,
      blockedUntil: blockedUntil ?? this.blockedUntil,
      authProvider: authProvider ?? this.authProvider, // ✅ Pastikan bisa diupdate
    );
  }

  @override
  String toString() {
    return "User(id: $id, username: $username, email: $email, phoneNumber: $phoneNumber, type: $type, blockedUntil: $blockedUntil, authProvider: $authProvider)";
  }

  factory User.empty() {
    return User(id: 0, username: 'Anonymous', email: '', phoneNumber: '', type: 0, authProvider: 'manual');
  }

  static User defaultUser() {
    return User(id: 0, username: "Unknown", email: "", phoneNumber: "", type: 0, authProvider: 'manual');
  }
}
