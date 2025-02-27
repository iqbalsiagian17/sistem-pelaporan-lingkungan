import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/auth/login_view.dart';
import '../views/onboarding/onboarding_view.dart';
import '../views/notification/notification_list.dart';
import '../views/user/report/my_report_views.dart';
import '../views/auth/register_view.dart';
import '../views/home/home_view.dart';
import '../views/user/save/report_save_view.dart';
import '../views/user/profile/profile_view.dart';
import '../views/report/report_create_view.dart';



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


  static final GoRouter router = GoRouter(
    initialLocation: onboarding,
    redirect: (context, state) async {
      final prefs = await SharedPreferences.getInstance();
      final onboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;

      if (!onboardingCompleted && state.uri.toString() != onboarding) {
        return onboarding;
      } else if (onboardingCompleted && state.uri.toString() == onboarding) {
        return login;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterView(),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: notification,
        builder: (context, state) => const NotificationList(),
      ),
      GoRoute(
        path: myReport,
        builder: (context, state) => const MyReportView(),
      ),
      GoRoute(
        path: saveReport,
        builder: (context, state) => const ReportSaveView(),
      ),
      GoRoute(
        path: profile,
        builder: (context, state) => const ProfileView(),
      ),
      GoRoute(
        path: createReport, 
        builder: (context, state) => const ReportCreateView(),  
        )
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(child: Text('Halaman tidak ditemukan')),
    ),
  );
}
