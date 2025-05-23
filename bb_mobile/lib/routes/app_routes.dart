import 'package:bb_mobile/features/announcement/domain/entities/announcement_entity.dart';
import 'package:bb_mobile/features/announcement/presentation/pages/detail/announcement_detail_view.dart';
import 'package:bb_mobile/features/announcement/presentation/pages/list/announcement_list_view.dart';
import 'package:bb_mobile/features/auth/presentation/pages/forget_password/forgot_password_view.dart';
import 'package:bb_mobile/features/auth/presentation/pages/forget_password/reset_password_view.dart';
import 'package:bb_mobile/features/auth/presentation/pages/forget_password/verify_forgot_otp_view.dart';
import 'package:bb_mobile/features/auth/presentation/pages/register/verify_otp_view.dart';
import 'package:bb_mobile/features/forum/domain/entities/forum_post_entity.dart';
import 'package:bb_mobile/features/forum/presentation/pages/detail/forum_detail_view.dart';
import 'package:bb_mobile/features/forum/presentation/pages/list/forum_list_view.dart';
import 'package:bb_mobile/features/notification/presentation/pages/notification_list.dart';
import 'package:bb_mobile/features/onboarding/presentation/pages/splash_screen.dart';
import 'package:bb_mobile/features/parameter/presentation/pages/about/about_view.dart';
import 'package:bb_mobile/features/parameter/presentation/pages/emergency/emergency_view.dart';
import 'package:bb_mobile/features/parameter/presentation/pages/reportGuides/report_guides_view.dart';
import 'package:bb_mobile/features/parameter/presentation/pages/terms/terms_view.dart';
import 'package:bb_mobile/features/profile/presentation/pages/detail/profile_view.dart';
import 'package:bb_mobile/features/profile/presentation/pages/edit/profile_edit_view.dart';
import 'package:bb_mobile/features/profile/presentation/pages/password/password_edit_view.dart';
import 'package:bb_mobile/features/report/data/models/report_model.dart';
import 'package:bb_mobile/features/report/domain/entities/report_entity.dart';
import 'package:bb_mobile/features/report/presentation/pages/create/report_create_view.dart';
import 'package:bb_mobile/features/report/presentation/pages/detail/report_detail_view.dart';
import 'package:bb_mobile/features/report/presentation/pages/edit/report_edit_view.dart';
import 'package:bb_mobile/features/report/presentation/pages/list/report_list_all_view.dart';
import 'package:bb_mobile/features/report/presentation/pages/my_report/my_report_view.dart';
import 'package:bb_mobile/features/report_save/presentation/pages/report_save_view.dart';
import 'package:bb_mobile/features/splash/presentation/pages/onboarding_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bb_mobile/features/auth/presentation/pages/login/login_view.dart';
import 'package:bb_mobile/features/auth/presentation/pages/register/register_view.dart';
import 'package:bb_mobile/features/dashboard/presentation/pages/dashboard_view.dart';

class AppRoutes {
  // 👉 Daftar path rute
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String editPassword = '/edit-password';
  static const String createReport = '/create-report';
  static const String editReport = '/edit-report';
  static const String allReport = '/all-report';
  static const String detailReport = '/detail-report';
  static const String myReport = '/my-report';
  static const String saveReport = '/save-report';
  static const String terms = '/terms';
  static const String about = '/about';
  static const String emergency = '/emergency';
  static const String reportGuides = '/guides-report';
  static const String notification = '/notification';
  static const String allAnnouncement = '/all-announcement';
  static const String announcementDetail = '/announcement-detail';
  static const String forum = '/forum';
  static const String detailForum = '/detail-forum';
  static const String verifyOtp = '/verify-otp';
  static const String forgotPassword = '/forgot-password';
  static const String verifyForgotOtp = '/verify-forgot-otp';
  static const String resetPassword = '/reset-password';



  /// 🔁 Logika redirect awal
static Future<String?> _redirectLogic(BuildContext context, GoRouterState state) async {
  final prefs = await SharedPreferences.getInstance();
  final onboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // Jika halaman register diminta, biarkan navigasi ke register
  final allowedWithoutLogin = [
    AppRoutes.register,
    AppRoutes.verifyOtp,
    AppRoutes.forgotPassword,
    AppRoutes.verifyForgotOtp,
    AppRoutes.resetPassword,
  ];

  if (allowedWithoutLogin.contains(state.matchedLocation)) {
    return null;
  }

  // Logika redirect untuk halaman lain
  if (!onboardingCompleted) return AppRoutes.onboarding;
  if (!isLoggedIn) return AppRoutes.login;

  return null; // Biarkan navigasi ke halaman yang diminta jika kondisi terpenuhi
}



  /// 🧭 Router utama aplikasi
  static final GoRouter router = GoRouter(
    initialLocation: splash,
    redirect: (context, state) async {
      final result = await Future.microtask(() => _redirectLogic(context, state));
      return result;
    },
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: onboarding, builder: (context, state) => const OnboardingView()),
      GoRoute(path: login, builder: (context, state) => const LoginView()),
      GoRoute(path: register, builder: (context, state) => const RegisterView()),
      GoRoute(path: dashboard, builder: (context, state) => const DashboardView()),
      GoRoute(path: profile, builder: (context, state) => const ProfileView()),
      GoRoute(path: editProfile, builder: (context, state) => const ProfileEditView()),
      GoRoute(path: editPassword, builder: (context, state) => const PasswordEditView()),
      GoRoute(path: createReport, builder: (context, state) => const ReportCreateView()),
      GoRoute(path: allReport, builder: (context, state) => const ReportListAllView()),
      GoRoute(path: myReport, builder: (context, state) => const MyReportView()),
      GoRoute(
        path: editReport,
        builder: (context, state) {
          final report = state.extra as ReportEntity;
          return ReportEditView(report: report);
        },
      ),
      GoRoute(
        path: detailReport,
        builder: (context, state) {
          final report = state.extra as ReportModel;
          return ReportDetailView(report: report);
        },
      ),

      GoRoute(path: saveReport, builder: (context, state) => const ReportSaveView()),
      GoRoute(path: terms, builder: (context, state) => const TermsView()),
      GoRoute(path: about, builder: (context, state) => const AboutView()),
      GoRoute(path: emergency, builder: (context, state) => const EmergencyView()),
      GoRoute(path: reportGuides, builder: (context, state) => const ReportGuidesView()),
      GoRoute(path: notification, builder: (context, state) => const NotificationListView()),
      GoRoute(path: allAnnouncement, builder: (context, state) => const AnnouncementListView()),
      GoRoute(
        path: announcementDetail,
        builder: (context, state) {
          final announcement = state.extra as AnnouncementEntity;
          return AnnouncementDetailView(announcement: announcement);
        },
      ),
      GoRoute(path: forum, builder: (context, state) => const ForumListView()),
      GoRoute(
          path: detailForum,
          builder: (context, state) {
            final post = state.extra as ForumPostEntity; // Get the ForumPostEntity from state.extra
            return ForumDetailView(post: post); // Pass the post to the ForumDetailView
          },
        ),
      GoRoute(path: forgotPassword, builder: (context, state) => const ForgotPasswordView()),
      GoRoute(path: verifyOtp, builder: (context, state){
          final email = state.extra as String;
          return VerifyOtpView(email: email);
          },
        ),
      GoRoute(path: verifyForgotOtp, builder: (context, state){
          final email = state.extra as String;
          return VerifyForgotOtpView(email: email);
          },
        ),
      GoRoute(path: resetPassword, builder: (context, state){
          final email = state.extra as String;
          return ResetPasswordView(email: email);
          },
        ),
      GoRoute(
          path: '/dummy',
          builder: (context, state) => const Scaffold(body: SizedBox.shrink()),
        ),

      ],
      errorBuilder: (context, state) => const Scaffold(
        body: Center(child: Text('Halaman tidak ditemukan')),
      ),
    );
}
