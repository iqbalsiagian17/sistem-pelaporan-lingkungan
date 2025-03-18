class ApiConstants {
   static const String baseUrl = "http://192.168.227.108:3000";
 
/*     static const String baseUrl = "http://10.0.2.2:3000"; 
 */
  
  // Endpoint Autentikasi
  static const String authBaseUrl = "$baseUrl/api/auth";
  
  // Endpoint User Profile
  static const String userProfileBaseUrl = "$baseUrl/api/user/profile";
  
  static const String userReportUrl = "$baseUrl/api/user/reports";

  static const String userReportSave = "$baseUrl/api/user/saved-reports";

  static const String userReportLike = "$baseUrl/api/user/reports";

  static const String publicCarousel = "$baseUrl/api/carousels";  

  // ✅ Endpoint Forum
  static const String forumUrl = "$baseUrl/api/forum";  

}
