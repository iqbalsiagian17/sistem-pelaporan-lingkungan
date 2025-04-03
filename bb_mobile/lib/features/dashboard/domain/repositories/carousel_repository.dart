import '../entities/carousel_entity.dart';

abstract class CarouselRepository {
  Future<List<CarouselEntity>> fetchCarousel();
}
