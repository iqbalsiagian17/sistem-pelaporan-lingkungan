class ApiConstants {
  static const String baseUrl = "http://172.25.42.159:3000";
  
  // Endpoint Autentikasi
  static const String authBaseUrl = "$baseUrl/api/auth";
  
  // Endpoint User Profile
  static const String userProfileBaseUrl = "$baseUrl/api/user/profile";
  
  // Upload Profile Picture
  static const String uploadProfilePictureUrl = "$userProfileBaseUrl/update-profile-picture";


  static const String userReportUrl = "$baseUrl/api/user/reports";
  

}
