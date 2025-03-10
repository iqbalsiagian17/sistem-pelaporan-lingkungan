class ApiConstants {
   static const String baseUrl = "http://192.168.227.108:3000";
 
/*     static const String baseUrl = "http://10.0.2.2:3000"; // ✅ Use this for Android Emulator
 */
  
  // Endpoint Autentikasi
  static const String authBaseUrl = "$baseUrl/api/auth";
  
  // Endpoint User Profile
  static const String userProfileBaseUrl = "$baseUrl/api/user/profile";
  
  // Upload Profile Picture
  static const String uploadProfilePictureUrl = "$userProfileBaseUrl/update-profile-picture";


  static const String userReportUrl = "$baseUrl/api/user/reports";
  

}
