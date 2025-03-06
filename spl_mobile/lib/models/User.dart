class User {
  final int id;
  final String username;
  final String email;
  final String phoneNumber;
  final int type;
  final DateTime? blockedUntil;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    this.type = 0,
    this.blockedUntil,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] ?? 0,
      username: json["username"] ?? "Tidak diketahui",
      email: json["email"] ?? "Tidak ada email",
      phoneNumber: json["phone_number"] ?? "Tidak ada nomor",
      type: json["type"] ?? 0,
      blockedUntil: json["blocked_until"] != null
          ? DateTime.tryParse(json["blocked_until"])
          : null,
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
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      type: type ?? this.type,
      blockedUntil: blockedUntil ?? this.blockedUntil,
    );
  }
}
