import 'package:dio/dio.dart';
import '../../domain/entities/village_entity.dart';
import '../models/villages_model.dart';

class VillageRemoteDataSource {
  final Dio dio;

  VillageRemoteDataSource(this.dio);

  Future<List<VillageEntity>> getAllVillages() async {
    try {
      final response = await dio.get('/api/villages'); // ✅ endpoint kamu

      final data = response.data;

      if (data is Map<String, dynamic> && data.containsKey('data')) {
        final villageList = data['data'] as List<dynamic>;

        return villageList.map((e) => VillageModel.fromJson(e).toEntity()).toList();
      } else {
        throw Exception("Format data desa tidak sesuai");
      }
    } catch (e) {
      throw Exception("Gagal mengambil data desa: $e");
    }
  }
}
