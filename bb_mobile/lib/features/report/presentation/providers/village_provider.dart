import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'package:bb_mobile/core/constants/api.dart';
import 'package:bb_mobile/features/report/data/datasources/village_remote_datasource.dart';
import 'package:bb_mobile/features/report/data/repositories/village_repository_impl.dart';
import 'package:bb_mobile/features/report/domain/usecases/get_villages_usecase.dart';
import 'package:bb_mobile/features/report/domain/entities/village_entity.dart';
import 'package:bb_mobile/features/report/domain/repositories/village_repository.dart';

// ✅ Dio Provider dengan baseUrl langsung dari ApiConstants
final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl, // Gunakan baseUrl yang sudah didefinisikan
  ));
});

// ✅ Remote Data Source Provider
final villageRemoteDataSourceProvider = Provider<VillageRemoteDataSource>((ref) {
  return VillageRemoteDataSource(ref.read(dioProvider));
});

// ✅ Repository Provider
final villageRepositoryProvider = Provider<VillageRepository>((ref) {
  return VillageRepositoryImpl(ref.read(villageRemoteDataSourceProvider));
});

// ✅ Usecase Provider
final getVillagesUseCaseProvider = Provider<GetVillagesUseCase>((ref) {
  return GetVillagesUseCase(ref.read(villageRepositoryProvider));
});

// ✅ Provider untuk UI (Dropdown, dsb.)
final villageListProvider = FutureProvider<List<VillageEntity>>((ref) {
  return ref.read(getVillagesUseCaseProvider).execute();
});
