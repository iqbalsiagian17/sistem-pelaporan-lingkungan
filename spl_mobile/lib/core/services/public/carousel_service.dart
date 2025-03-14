import 'package:dio/dio.dart';
import 'package:spl_mobile/core/constants/api.dart';
import '../../../models/Carousel.dart';

class CarouselService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.publicCarousel,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<List<CarouselItem>> fetchCarousel() async {
    try {
      final response = await _dio.get("");

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['carousels'];
        return data.map((json) => CarouselItem.fromJson(json)).toList();
      } else {
        throw Exception("Gagal mengambil data carousel.");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan: $e");
    }
  }
}
