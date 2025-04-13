import 'package:bb_mobile/features/report/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
   UserModel({
    required int id,
    required String username,
    required String email,
    required String phoneNumber,
    required int type,
    required String? profilePicture,
  }) : super(
          id: id,
          username: username,
          email: email,
          phoneNumber: phoneNumber,
          type: type,
          profilePicture: profilePicture,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      type: json['type'] ?? 0,
      profilePicture: json["profile_picture"] ?? "",
    );
  }

    factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      username: entity.username,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      type: entity.type,
      profilePicture: entity.profilePicture,
    );
  }


  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'phone_number': phoneNumber,
        'type': type,
        'profile_picture': profilePicture,
      };

      
}
