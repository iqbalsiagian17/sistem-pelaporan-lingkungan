import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spl_mobile/models/Announcement.dart';
import 'package:spl_mobile/models/Forum.dart';
import 'package:spl_mobile/models/Report.dart';
import 'package:spl_mobile/models/ReportSave.dart';
import 'package:spl_mobile/views/announcement/announcement_list_view.dart';
import 'package:spl_mobile/views/announcement/detail/announcement_detail_view.dart';
import 'package:spl_mobile/views/forum/detail/forum_detail_view.dart';
import 'package:spl_mobile/views/forum/forum_view.dart';
import 'package:spl_mobile/views/parameter/about/about_view.dart';
import 'package:spl_mobile/views/parameter/emergency/emergency_view.dart';
import 'package:spl_mobile/views/parameter/terms/terms_view.dart';
import 'package:spl_mobile/views/report/report_guides_view.dart';
import 'package:spl_mobile/widgets/error/invalid_data_view.dart';
import '../views/auth/login_view.dart';
import '../views/onboarding/onboarding_view.dart';
import '../views/home/home_view.dart';
import '../views/auth/register_view.dart';
import '../views/user/profile/profile_view.dart';
import '../views/user/profile/edit/profile_edit_view.dart';
import '../views/user/password/edit/password_edit_view.dart';
import '../views/user/report/my_report_views.dart';
import '../views/notification/notification_list.dart';
import '../views/user/save/report_save_view.dart';
import '../views/report/report_create_view.dart';
import '../views/report/list/report_list_view.dart';
import '../views/report/detail/report_detail_view.dart';
import '../views/splash/splash_screen.dart';

class AppRoutes {

    static String initialRoute = AppRoutes.splash;

  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String notification = '/notifications';
  static const String createReport = '/create-report';
  static const String myReport = '/my-report';
  static const String saveReport = '/save-report';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String editPassword = '/edit-password';
  static const String allReport = '/all-report';
  static const String reportDetail = '/report-detail';
  static const String forum = '/forum';
  static const String forumDetail = '/forum-detail';
  static const String allAnnouncement =  '/announcement';
  static const String announcementDetail = '/announcement-detail';
  static const String splash = '/splash';
  static const String terms = '/terms';
  static const String about = '/about';
  static const String emergency ='/emergency';
  static const String reportGuide = '/report-guide';

  static Future<String?> _redirectLogic(BuildContext context, GoRouterState state) async {
    final prefs = await SharedPreferences.getInstance();
    bool onboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!onboardingCompleted) return AppRoutes.onboarding;
    if (!isLoggedIn) return AppRoutes.login;

    return null; // Jangan return home langsung agar SplashScreen bisa tampil dulu
  }

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) async {
      final result = await Future.microtask(() => _redirectLogic(context, state));
      return result;
    },
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: onboarding, builder: (context, state) => const OnboardingView()),
      GoRoute(path: login, builder: (context, state) => const LoginView()),
      GoRoute(path: register, builder: (context, state) => const RegisterView()),
      GoRoute(path: home, builder: (context, state) => const HomeView()),
      GoRoute(path: notification, builder: (context, state) => const NotificationList()),
      GoRoute(path: myReport, builder: (context, state) => const MyReportView()),
      GoRoute(path: saveReport, builder: (context, state) => const ReportSaveView()),
      GoRoute(path: profile, builder: (context, state) => const ProfileView()),
      GoRoute(path: editProfile, builder: (context, state) => const ProfileEditView()),
      GoRoute(path: editPassword, builder: (context, state) => const PasswordEditView()),
      GoRoute(path: createReport, builder: (context, state) => const ReportCreateView()),
      GoRoute(path: allReport, builder: (context, state) => const ReportListAllView()),
      GoRoute(
        path: reportDetail,
        name: AppRoutes.reportDetail,
        builder: (context, state) {
          final extra = state.extra;

          // 🔍 Debugging untuk mengetahui bentuk `extra`
          print("🔍 Debugging state.extra: $extra");

          // ✅ Jika `extra` adalah `Report`, langsung kirim ke `ReportDetailView`
          if (extra is Report) {
            return ReportDetailView(report: extra);
          }

          // ✅ Jika `extra` adalah `Map` yang berisi `data`
          if (extra is Map<String, dynamic> && extra.containsKey("data")) {
            final reportData = extra["data"];

            if (reportData is Report) {
              return ReportDetailView(report: reportData);
            } else if (reportData is ReportSave) {
              return ReportDetailView(report: reportData.toReport());
            }
          }

          // 🔥 Jika data tidak valid, tampilkan error
          return InvalidDataView(debug: extra.toString());
        },
      ),
      GoRoute(path: forum, builder: (context, state) => const ForumView()),
      GoRoute(
          path: forumDetail,
          name: AppRoutes.forumDetail,
          builder: (context, state) {
            final extra = state.extra;

            print("🔍 Debugging state.extra: $extra");

            if (extra is ForumPost) {
              return ForumDetailView(post: extra);
            }

            if (extra is Map<String, dynamic> && extra.containsKey("post")) {
              final postData = extra["post"];

              if (postData is ForumPost) {
                return ForumDetailView(post: postData);
              }
            }

          // 🔥 Jika data tidak valid, tampilkan error
          return InvalidDataView(debug: extra.toString());
          },
        ),
      GoRoute(path: allAnnouncement, builder: (context, state) => const AnnouncementListView()),
      GoRoute(
        path: announcementDetail,
        name: AppRoutes.announcementDetail,
        builder: (context, state) {
          final extra = state.extra;

          // Debugging
          print("🔍 Debugging state.extra (announcement): $extra");

          if (extra is AnnouncementItem) {
            return AnnouncementDetailView(announcement: extra);
          }

          // 🔥 Jika data tidak valid, tampilkan error
          return InvalidDataView(debug: extra.toString());
        },
      ),
      GoRoute(path: terms, builder: (context, state) => const TermsView()),
      GoRoute(path: about, builder: (context, state) => const AboutView()),
      GoRoute(path: emergency, builder: (context, state) => const EmergencyView()),
      GoRoute(path: reportGuide, builder: (context, state) => const ReportGuidesView()),
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(child: Text('Halaman tidak ditemukan')),
    ),
  );

  
}
