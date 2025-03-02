class ApiConstants {
  static const String baseUrl = "http://192.168.253.108:3000";
  
  // Endpoint Autentikasi
  static const String authBaseUrl = "$baseUrl/api/auth";
  
  // Endpoint User Profile
  static const String userProfileBaseUrl = "$baseUrl/api/user/profile";
  
  // Upload Profile Picture
  static const String uploadProfilePictureUrl = "$userProfileBaseUrl/update-profile-picture";

}
