import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:bb_mobile/features/dashboard/data/datasources/media_carousel_remote_datasource.dart';
import 'package:bb_mobile/features/dashboard/data/models/media_carousel_model.dart';

class MediaCarouselState {
  final List<MediaCarouselModel> data;
  final bool isLoading;
  final String? error;

  const MediaCarouselState({
    this.data = const [],
    this.isLoading = false,
    this.error,
  });

  MediaCarouselState copyWith({
    List<MediaCarouselModel>? data,
    bool? isLoading,
    String? error,
  }) {
    return MediaCarouselState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class MediaCarouselNotifier extends StateNotifier<MediaCarouselState> {
  final MediaCarouselRemoteDatasource datasource;

  MediaCarouselNotifier(this.datasource) : super(const MediaCarouselState());

  Future<void> fetchMediaCarousels() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final data = await datasource.fetchMediaCarousels();
      state = state.copyWith(data: data, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}

final mediaCarouselProvider =
    StateNotifierProvider<MediaCarouselNotifier, MediaCarouselState>((ref) {
  final dio = Dio(); // replace with DioClient.instance if available
  final datasource = MediaCarouselRemoteDatasource(dio: dio);
  return MediaCarouselNotifier(datasource);
});
