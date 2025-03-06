import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spl_mobile/models/Report.dart';

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
  static const String splash = '/splash';


  static Future<String?> _redirectLogic(BuildContext context, GoRouterState state) async {
  final prefs = await SharedPreferences.getInstance();
  bool onboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  if (!onboardingCompleted) return AppRoutes.onboarding;
  if (!isLoggedIn) return AppRoutes.login;

  return null; // Jangan return home langsung agar SplashScreen bisa tampil dulu
}


  static final GoRouter router = GoRouter(
  initialLocation: AppRoutes.splash, // ✅ Ubah dari `home` ke `splash`
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
        path: '/report-detail',
        name: AppRoutes.reportDetail,
        builder: (context, state) {
          final report = state.extra as Report; // ✅ Ambil `extra` sebagai Report
          return ReportDetailView(report: report);
        },
      ),

    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(child: Text('Halaman tidak ditemukan')),
    ),
  );
}
