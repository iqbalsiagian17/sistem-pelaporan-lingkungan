import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:bb_mobile/features/dashboard/data/datasources/carousel_remote_datasource.dart';
import 'package:bb_mobile/features/dashboard/data/models/carousel_model.dart';

class CarouselState {
  final List<CarouselModel> data;
  final bool isLoading;
  final String? error;

  const CarouselState({
    this.data = const [],
    this.isLoading = false,
    this.error,
  });

  CarouselState copyWith({
    List<CarouselModel>? data,
    bool? isLoading,
    String? error,
  }) {
    return CarouselState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class CarouselNotifier extends StateNotifier<CarouselState> {
  final CarouselRemoteDatasource datasource;

  CarouselNotifier(this.datasource) : super(const CarouselState());

  Future<void> fetchCarousel() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final data = await datasource.fetchCarousel();
      state = state.copyWith(data: data, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}

final carouselProvider = StateNotifierProvider<CarouselNotifier, CarouselState>((ref) {
  final dio = Dio(); // atau gunakan DioClient.instance
  final datasource = CarouselRemoteDatasource(dio: dio);
  return CarouselNotifier(datasource);
});
