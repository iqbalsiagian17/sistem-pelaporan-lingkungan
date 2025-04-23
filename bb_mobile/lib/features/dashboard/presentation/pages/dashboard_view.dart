import 'package:bb_mobile/features/dashboard/presentation/widgets/media_carousel_banner.dart';
import 'package:bb_mobile/features/report/presentation/providers/report_provider.dart'
    show reportProvider;
import 'package:bb_mobile/widgets/snackbar/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/services.dart';

import 'package:bb_mobile/widgets/navbar/top_navbar.dart';
import 'package:bb_mobile/widgets/navbar/bottom_navbar.dart';
import '../widgets/quick_access_menu.dart';
import '../widgets/topic_section.dart';
import '../widgets/recent_reports_section.dart';

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  int _selectedIndex = 0;
  DateTime? _lastBackPressed;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(reportProvider.notifier).fetchReports());
    BackButtonInterceptor.add(_onBackPressed);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(_onBackPressed);
    super.dispose();
  }

  bool _onBackPressed(bool stopDefaultButtonEvent, RouteInfo info) {
    // Jika bisa pop → berarti halaman ini bukan root, jangan intercept
    if (Navigator.of(context).canPop()) return false;

    // Jika tidak bisa pop, aktifkan fitur "tekan dua kali untuk keluar"
    final now = DateTime.now();
    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
      _lastBackPressed = now;

      // Gunakan SnackbarHelper milikmu
      SnackbarHelper.showSnackbar(context, "Ketuk lagi untuk keluar dari Balige Bersih");

      return true;
    }

    SystemNavigator.pop(); // keluar aplikasi
    return true;
  }

  Future<void> _refreshContent() async {
    await ref.read(reportProvider.notifier).fetchReports();
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const TopBar(),
      body: RefreshIndicator(
        onRefresh: _refreshContent,
        color: const Color(0xFF1976D2),
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: _boxDecoration(),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    MediaCarouselBanner(),
                    SizedBox(height: 20),
                    QuickAccessMenu(),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16),
                decoration: _boxDecoration(),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    TopicSection(),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16, bottom: 16),
                decoration: _boxDecoration(),
                child: const RecentReportsSection(),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
