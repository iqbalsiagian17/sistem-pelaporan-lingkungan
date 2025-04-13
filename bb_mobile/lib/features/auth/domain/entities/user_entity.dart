class UserEntity {
  final int id;
  final String username;
  final String email;
  final String phoneNumber;
  final int type;
  final DateTime? blockedUntil;
  final String authProvider; 
  final String? profilePicture;


  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.type,
    this.blockedUntil,
    required this.authProvider, 
    this.profilePicture,
  });
}
