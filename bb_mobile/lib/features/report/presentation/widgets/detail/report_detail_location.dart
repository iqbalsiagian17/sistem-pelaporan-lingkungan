import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ReportDetailLocation extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String? village;
  final String? locationDetails;
  final Map<String, dynamic>? boundary; // ← ✅ ditambahkan

  const ReportDetailLocation({
    super.key,
    required this.latitude,
    required this.longitude,
    this.village,
    this.locationDetails,
    this.boundary, // ← ✅ tambahkan
  });

  @override
Widget build(BuildContext context) {
  final bool isAtLocation = latitude != 0.0 && longitude != 0.0;

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.location_on, color: Color(0xFF66BB6A)),
            SizedBox(width: 8),
            Text(
              "Lokasi Kejadian",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        if (isAtLocation) ...[
          _buildMapWithMarker(latitude, longitude),
          if (locationDetails != null && locationDetails!.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text("Detail Lokasi:"),
            Text(locationDetails!, style: const TextStyle(color: Colors.black87)),
          ],
        ] else if (boundary != null && boundary!['coordinates'] != null) ...[
          if (village != null && village!.isNotEmpty) ...[
            const Text("Nama Desa/Kelurahan:", style: TextStyle(fontWeight: FontWeight.w600)),
            Text(village!, style: const TextStyle(color: Colors.black87)),
            const SizedBox(height: 8),
          ],
          if (locationDetails != null && locationDetails!.isNotEmpty) ...[
            const Text("Detail Lokasi:", style: TextStyle(fontWeight: FontWeight.w600)),
            Text(locationDetails!, style: const TextStyle(color: Colors.black87)),
            const SizedBox(height: 8),
          ],
          _buildMapWithBoundary(boundary!),
        ] else ...[
          if (village != null && village!.isNotEmpty) ...[
            const Text("Nama Desa/Kelurahan:", style: TextStyle(fontWeight: FontWeight.w600)),
            Text(village!, style: const TextStyle(color: Colors.black87)),
          ],
          if (locationDetails != null && locationDetails!.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text("Detail Lokasi:", style: TextStyle(fontWeight: FontWeight.w600)),
            Text(locationDetails!, style: const TextStyle(color: Colors.black87)),
          ],
        ],
      ],
    ),
  );
}


  static const List<LatLng> _baligePolygon = [
  LatLng(2.3495373075169397, 99.03711737302717),
  LatLng(2.35060307618825, 99.04073641769787),
  LatLng(2.3456929209123842, 99.0465268891723),
  LatLng(2.3419191022465498, 99.04844797628596),
  LatLng(2.342283604801395, 99.05126126377752),
  LatLng(2.335057280763394, 99.05665949700796),
  LatLng(2.3360995933740583, 99.06128811193781),
  LatLng(2.3453164060374974, 99.06404656390549),
  LatLng(2.3509233170573225, 99.07484762955943),
  LatLng(2.349709450427426, 99.08230169082617),
  LatLng(2.354975828827719, 99.08822610772688),
  LatLng(2.3637756359219253, 99.10392782722607),
  LatLng(2.3643161680033558, 99.10958343265133),
  LatLng(2.28488810016286, 99.13015468370656),
  LatLng(2.256206943195835, 99.03425300438255),
  LatLng(2.3495340286737303, 99.03711661083042),
];

Widget _buildMapWithMarker(double lat, double lng) {
  return SizedBox(
    height: 200,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(lat, lng),
          initialZoom: 16,
          interactionOptions: const InteractionOptions(flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag),
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
          ),

          // 🔶 Tambahkan Polygon Balige
          PolygonLayer(
            polygons: [
              Polygon(
                      points: _baligePolygon,
                      color: Colors.transparent,
                      borderColor: Colors.red.shade600,
                      borderStrokeWidth: 2,
                      isDotted: true, // opsional jika mau beda style
                    ),
            ],
          ),

          // 📍 Marker Lokasi
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(lat, lng),
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}


  Widget _buildMapWithBoundary(Map<String, dynamic> boundary) {
  try {
    final coordsRaw = boundary['coordinates'];
    if (coordsRaw == null || coordsRaw is! List || coordsRaw.isEmpty) {
      return const SizedBox();
    }

    final rawPolygon = List<List<dynamic>>.from(coordsRaw[0]);
    final polygonPoints = rawPolygon.map((point) {
      final lng = (point[0] as num).toDouble();
      final lat = (point[1] as num).toDouble();
      return LatLng(lat, lng);
    }).toList();

    if (polygonPoints.length < 3) return const SizedBox();

    final center = _getPolygonCenter(polygonPoints);
    debugPrint("✔ Center: $center | Points: ${polygonPoints.length}");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: FlutterMap(
              options: MapOptions(
                initialCenter: center,
                initialZoom: 14,
                interactionOptions: const InteractionOptions(flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag),
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
                PolygonLayer(
                  polygons: [
                    // ✅ Polygon desa dari boundary GeoJSON
                    Polygon(
                      points: polygonPoints,
                      color: Colors.lightGreen.withOpacity(0.3),
                      borderColor: Colors.green.shade800,
                      borderStrokeWidth: 2,
                    ),
                    // ✅ Tambahan: Polygon wilayah Balige
                    Polygon(
                      points: _baligePolygon,
                      color: Colors.transparent,
                      borderColor: Colors.red.shade600,
                      borderStrokeWidth: 2,
                      isDotted: true, // opsional jika mau beda style
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "Wilayah pada peta di atas merupakan estimasi berdasarkan batas administratif desa dan belum menunjukkan titik lokasi kejadian secara pasti.",
          style: TextStyle(fontSize: 12, color: Colors.black54),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  } catch (e) {
    debugPrint("❌ Gagal parsing polygon: $e");
    return const SizedBox();
  }
}



List<List<List<double>>>? _parseWKT(String wkt) {
  try {
    final reg = RegExp(r'POLYGON\s*\(\(([^)]+)\)\)');
    final match = reg.firstMatch(wkt);
    if (match == null) return null;

    final pointsStr = match.group(1)!;
    final pointPairs = pointsStr.split(',');

    final coordinates = pointPairs.map((pair) {
      final parts = pair.trim().split(' ');
      final lng = double.parse(parts[0]);
      final lat = double.parse(parts[1]);
      return [lng, lat];
    }).toList();

    return [coordinates]; // GeoJSON needs nested array
  } catch (_) {
    return null;
  }
}


  LatLng _getPolygonCenter(List<LatLng> points) {
    double latSum = 0;
    double lngSum = 0;

    for (var p in points) {
      latSum += p.latitude;
      lngSum += p.longitude;
    }

    return LatLng(latSum / points.length, lngSum / points.length);
  }
}
