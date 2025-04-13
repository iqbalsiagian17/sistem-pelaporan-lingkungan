import 'package:bb_mobile/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  final String? password;

  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.phoneNumber,
    required super.type,
    super.blockedUntil,
    required super.authProvider, 
    this.password,
    super.profilePicture,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedBlockedUntil;
    if (json["blocked_until"] != null) {
      parsedBlockedUntil = DateTime.tryParse(json["blocked_until"]);
    }

    return UserModel(
      id: json["id"] ?? 0,
      username: json["username"] ?? "",
      email: json["email"] ?? "",
      phoneNumber: json["phone_number"] ?? "",
      type: json["type"] ?? 0,
      blockedUntil: parsedBlockedUntil,
      authProvider: json["auth_provider"] ?? "manual",
      password: json["password"],
      profilePicture: json["profile_picture"] ?? "",
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
      "password": password,
      "profile_picture": profilePicture,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      username: username,
      email: email,
      profilePicture: profilePicture,
      phoneNumber: phoneNumber,
      type: type,
      blockedUntil: blockedUntil,
      authProvider: authProvider,
    );
  }
}
