class ApiConstants {
   static const String baseUrl = "http://192.168.40.108:3000";


/* static const String baseUrl = "http://192.168.1.6:3000";
 */  

  // Auth
  static const String authBaseUrl = "$baseUrl/api/auth";

  // Profile
  static const String userProfileBaseUrl = "$baseUrl/api/user/profile";

  // Laporan
  static const String userReportUrl = "$baseUrl/api/user/reports";
  static const String userReportSave = "$baseUrl/api/user/saved-reports";
  static const String userReportLike = "$baseUrl/api/user/reports";

  // Public
  static const String publicCarousel = "$baseUrl/api/mediacarousels";
  static const String publicAnnouncement = "$baseUrl/api/announcements";
  static const String publicParameter = "$baseUrl/api/parameters";

  // Forum
  static const String forumUrl = "$baseUrl/api/forum";
  static const String userPostLike = "$baseUrl/api/user/post";

  // Notifikasi
  static const String userNotificationUrl = "$baseUrl/api/notifications/user";
}