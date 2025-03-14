import 'package:flutter/material.dart';
import '../core/services/public/carousel_service.dart';
import '../models/Carousel.dart';

class CarouselProvider with ChangeNotifier {
  final CarouselService _carouselService = CarouselService();
  List<CarouselItem> _carouselItems = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CarouselItem> get carouselItems => _carouselItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchCarousel() async {
    _isLoading = true;
    notifyListeners();

    try {
      _carouselItems = await _carouselService.fetchCarousel();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
