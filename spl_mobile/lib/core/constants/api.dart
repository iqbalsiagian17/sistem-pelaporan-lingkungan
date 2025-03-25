class ApiConstants {
/*     static const String baseUrl = "http://192.168.227.108:3000";
 */
      static const String baseUrl = "http://172.25.42.159:3000"; 
 
  
  // Endpoint Autentikasi
  static const String authBaseUrl = "$baseUrl/api/auth";
  
  // Endpoint User Profile
  static const String userProfileBaseUrl = "$baseUrl/api/user/profile";
  
  static const String userReportUrl = "$baseUrl/api/user/reports";

  static const String userReportSave = "$baseUrl/api/user/saved-reports";

  static const String userReportLike = "$baseUrl/api/user/reports";

  static const String publicCarousel = "$baseUrl/api/carousels";  

  static const String publicAnnouncement = "$baseUrl/api/announcements";

  static const String publicParameter = "$baseUrl/api/parameters";

  // ✅ Endpoint Forum
  static const String forumUrl = "$baseUrl/api/forum";  

  static const String userPostLike = "$baseUrl/api/user/post";


}
