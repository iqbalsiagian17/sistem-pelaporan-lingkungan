import 'package:dio/dio.dart';
import 'package:bb_mobile/core/constants/api.dart';
import 'package:bb_mobile/features/dashboard/data/models/media_carousel_model.dart';

class MediaCarouselRemoteDatasource {
  final Dio dio;

  MediaCarouselRemoteDatasource({required this.dio});

  Future<List<MediaCarouselModel>> fetchMediaCarousels() async {
    try {
      final response = await dio.get(ApiConstants.publicCarousel);

      final data = response.data;

      if (data is Map<String, dynamic> && data['mediacarousels'] is List) {
        final List<dynamic> list = data['mediacarousels'];
        return list.map((e) => MediaCarouselModel.fromJson(e)).toList();
      } else if (data is List) {
        return data.map((e) => MediaCarouselModel.fromJson(e)).toList();
      } else {
        throw Exception("Format data tidak sesuai.");
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
          return "Data media carousel tidak ditemukan.";
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
