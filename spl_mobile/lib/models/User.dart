class User {
  final int id;
  final String username;
  final String email;
  final String phoneNumber;
  final int type; // ✅ Tambahkan type

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    this.type = 0, // ✅ Jika tidak ada, default ke 0 (user biasa)
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      username: json["username"],
      email: json["email"],
      phoneNumber: json["phone_number"],
      type: json["type"] ?? 0, // ✅ Jika tidak ada, default ke 0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "phone_number": phoneNumber,
      "type": type, // ✅ Pastikan disertakan dalam JSON
    };
  }
}
