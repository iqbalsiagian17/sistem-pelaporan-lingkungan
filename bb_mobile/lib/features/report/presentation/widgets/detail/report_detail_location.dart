import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ReportDetailLocation extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String? village;
  final String? locationDetails;
  final Map<String, dynamic>? boundary;
  final Map<String, dynamic>? locationValidationArea; // ✅ Tambahkan ini

  const ReportDetailLocation({
    super.key,
    required this.latitude,
    required this.longitude,
    this.village,
    this.locationDetails,
    this.boundary,
    this.locationValidationArea, // ✅ Tambahkan ini
  });

  @override
Widget build(BuildContext context) {
  final bool isAtLocation = latitude != 0.0 && longitude != 0.0;

  debugPrint("📍 locationValidationArea: $locationValidationArea");

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
            Text("Lokasi Kejadian",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 10),

        // ✅ Jika pakai titik lokasi langsung (koordinat)
        if (isAtLocation) ...[
          _buildMapWithMarker(latitude, longitude),
          if (locationDetails?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            const Text("Detail Lokasi:"),
            Text(locationDetails!, style: const TextStyle(color: Colors.black87)),
          ],
        ]

        // ✅ Jika berdasarkan desa
        else ...[
          if (village?.isNotEmpty == true) ...[
            const Text("Nama Desa/Kelurahan:", style: TextStyle(fontWeight: FontWeight.w600)),
            Text(village!, style: const TextStyle(color: Colors.black87)),
            const SizedBox(height: 8),
          ],
          if (locationDetails?.isNotEmpty == true) ...[
            const Text("Detail Lokasi:", style: TextStyle(fontWeight: FontWeight.w600)),
            Text(locationDetails!, style: const TextStyle(color: Colors.black87)),
            const SizedBox(height: 8),
          ],
          if (boundary?['coordinates'] != null)
            _buildMapWithBoundary(boundary!),
        ],
      ],
    ),
  );
}


  Widget _buildMapWithMarker(double lat, double lng) {
    final polygonPoints = _extractPolygonPoints(locationValidationArea);

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
            if (polygonPoints.isNotEmpty)
              PolygonLayer(
                polygons: [
                  Polygon(
                    points: polygonPoints,
                    color: Colors.transparent,
                    borderColor: Colors.red.shade700,
                    borderStrokeWidth: 2,
                  ),
                ],
              ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(lat, lng),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_pin, size: 40, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapWithBoundary(Map<String, dynamic> boundary) {
    final polygonPoints = _extractPolygonPoints(boundary);
    if (polygonPoints.length < 3) return const SizedBox();

    final center = _getPolygonCenter(polygonPoints);

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
                    Polygon(
                      points: polygonPoints,
                      color: Colors.lightGreen.withOpacity(0.3),
                      borderColor: Colors.green.shade800,
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "Wilayah pada peta di atas merupakan estimasi berdasarkan batas administratif desa.",
          style: TextStyle(fontSize: 12, color: Colors.black54),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

List<LatLng> _extractPolygonPoints(Map<String, dynamic>? geoJson) {
  try {
    final type = geoJson?['type'];
    final coords = geoJson?['coordinates'];

    if (type == 'Polygon' && coords is List && coords.isNotEmpty) {
      final outerRing = coords[0] as List;
      return outerRing.map<LatLng>((point) {
        final lng = (point[0] as num).toDouble();
        final lat = (point[1] as num).toDouble();
        return LatLng(lat, lng);  
      }).toList();
    }
  } catch (e) {
    debugPrint("❌ Gagal parsing polygon: $e");
  }
  return [];
}


  LatLng _getPolygonCenter(List<LatLng> points) {
    double latSum = 0, lngSum = 0;
    for (var p in points) {
      latSum += p.latitude;
      lngSum += p.longitude;
    }
    return LatLng(latSum / points.length, lngSum / points.length);
  }
}
