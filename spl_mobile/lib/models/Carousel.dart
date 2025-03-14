class CarouselItem {
  final int id;
  final String title;
  final String description;
  final String imageUrl;

  CarouselItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory CarouselItem.fromJson(Map<String, dynamic> json) {
    return CarouselItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image'], // Sesuaikan dengan field API
    );
  }
}
