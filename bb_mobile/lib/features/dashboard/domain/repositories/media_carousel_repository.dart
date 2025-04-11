import '../entities/media_carousel_entity.dart';

abstract class MediaCarouselRepository {
  Future<List<MediaCarouselEntity>> fetchMediaCarousels();
}
