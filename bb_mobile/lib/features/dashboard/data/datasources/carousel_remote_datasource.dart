import 'package:dio/dio.dart';
import 'package:bb_mobile/core/constants/api.dart';
import 'package:bb_mobile/features/dashboard/data/models/carousel_model.dart';

class CarouselRemoteDatasource {
  final Dio dio;

  CarouselRemoteDatasource({required this.dio});

  Future<List<CarouselModel>> fetchCarousel() async {
    try {
      final response = await dio.get(ApiConstants.publicCarousel);

      final data = response.data;

      if (data is Map<String, dynamic> && data['carousels'] is List) {
        final List<dynamic> list = data['carousels'];
        return list.map((e) => CarouselModel.fromJson(e)).toList();
      } else if (data is List) {
        // Jika langsung list
        return data.map((e) => CarouselModel.fromJson(e)).toList();
      } else {
        throw Exception("❌ Format data tidak sesuai");
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      final status = e.response!.statusCode;
      switch (status) {
        case 400:
          return "Permintaan tidak valid.";
        case 401:
          return "Akses tidak sah.";
        case 403:
          return "Tidak diizinkan.";
        case 404:
          return "Data carousel tidak ditemukan.";
        case 500:
          return "Kesalahan server.";
        default:
          return e.response?.data["message"] ?? "Terjadi kesalahan.";
      }
    } else {
      return "Kesalahan jaringan atau sistem.";
    }
  }
}
