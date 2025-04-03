import 'package:bb_mobile/features/report/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
   UserModel({
    required int id,
    required String username,
    required String email,
    required String phoneNumber,
    required int type,
  }) : super(
          id: id,
          username: username,
          email: email,
          phoneNumber: phoneNumber,
          type: type,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      type: json['type'] ?? 0,
    );
  }

    factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      username: entity.username,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      type: entity.type,
    );
  }


  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'phone_number': phoneNumber,
        'type': type,
      };

      
}
