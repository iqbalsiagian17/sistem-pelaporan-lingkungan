import 'package:flutter/material.dart';
import 'package:spl_mobile/models/Announcement.dart';
import '../../core/services/public/announcement_service.dart';

class AnnouncementProvider with ChangeNotifier {
  final AnnouncementService _announcementService = AnnouncementService();

  List<AnnouncementItem> _announcements = [];
  AnnouncementItem? _selectedAnnouncement;

  bool _isLoading = false;
  String? _errorMessage;

  List<AnnouncementItem> get announcements => _announcements;
  AnnouncementItem? get selectedAnnouncement => _selectedAnnouncement;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 🔹 Ambil semua pengumuman
  Future<void> fetchAnnouncement() async {
    _isLoading = true;
    notifyListeners();

    try {
      _announcements = await _announcementService.fetchAnnouncement();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Gagal memuat pengumuman: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 Ambil detail pengumuman berdasarkan ID
  Future<void> fetchAnnouncementDetail(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      _selectedAnnouncement = await _announcementService.fetchAnnouncementById(id);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Gagal memuat detail pengumuman: $e";
      _selectedAnnouncement = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool hasNewAnnouncement() {
  final now = DateTime.now();
  return _announcements.any((announcement) {
    final createdAt = DateTime.tryParse(announcement.createdAt?.toString() ?? "");
    if (createdAt == null) return false;
    return now.difference(createdAt).inHours < 24;
  });
}

}
