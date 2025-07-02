class VillageEntity {
  final int id;
  final String name;
  final Map<String, dynamic>? boundary; // Optional: GeoJSON polygon for village boundaries


  VillageEntity({required this.id, required this.name, this.boundary});
}
