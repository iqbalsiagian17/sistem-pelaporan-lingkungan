import 'package:flutter/material.dart';
import '../../widgets/bottom_navbar.dart';
import '../../widgets/top_navbar.dart';
import 'components/carousel_banner.dart';
import 'components/quick_access_menu.dart';
import 'components/topic_section.dart';
import 'components/recent_reports_section.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  /// 🌀 Fungsi untuk merefresh data (simulasi dengan delay 1 detik)
  Future<void> _refreshContent() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // TODO: Panggil API atau perbarui data di sini
    });
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // TODO: Navigasi sesuai index
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const TopBar(title: "Balige Bersih"),
      body: RefreshIndicator(
        onRefresh: _refreshContent, 
        color: const Color(0xFF1976D2), 
        backgroundColor: Colors.white, 
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📦 Container: Carousel & Quick Access Menu
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 20),
                    CarouselBanner(),
                    SizedBox(height: 20),
                    QuickAccessMenu(),
                  ],
                ),
              ),

              // 📂 Container: Topik Aduan Populer
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    TopicSection(),
                  ],
                ),
              ),

              // 📝 Container: Laporan Terbaru
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16, bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const RecentReportsSection(),
              ),
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
}
