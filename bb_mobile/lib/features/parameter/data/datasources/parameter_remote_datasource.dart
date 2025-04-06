import 'package:dio/dio.dart';
import 'package:bb_mobile/core/constants/api.dart';
import 'package:bb_mobile/features/parameter/data/models/parameter_model.dart';

abstract class ParameterRemoteDataSource {
  Future<ParameterItem> fetchParameter();
}

class ParameterRemoteDataSourceImpl implements ParameterRemoteDataSource {
  final Dio dio;

  ParameterRemoteDataSourceImpl(this.dio);

  @override
  Future<ParameterItem> fetchParameter() async {
    try {
      final response = await dio.get(ApiConstants.publicParameter);

      if (response.statusCode == 200 && response.data['data'] != null) {
        return ParameterItem.fromJson(response.data['data']);
      } else {
        throw Exception("Gagal mengambil data parameter.");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan saat mengambil parameter: $e");
    }
  }
}
