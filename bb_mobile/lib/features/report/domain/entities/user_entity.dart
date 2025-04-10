class UserEntity {
  final int id;
  final String username;
  final String email;
  final String phoneNumber;
  final int type;

  UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.type,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      type: json['type'],
    );
  }
}
