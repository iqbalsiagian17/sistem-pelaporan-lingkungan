import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class LocationValidator {
  /// Fungsi utama untuk mengecek apakah [lat, lon] berada di dalam area validasi lokasi (GeoJSON Polygon)
  static bool isInsideValidationArea({
  required double lat,
  required double lon,
  required Map<String, dynamic>? geoJson,
}) {
  debugPrint("🟡 Mengecek lokasi: lat=$lat, lon=$lon");
  debugPrint("📦 GeoJSON: ${geoJson}");

  if (geoJson == null ||
      geoJson['type'] != 'Polygon' ||
      geoJson['coordinates'] == null ||
      geoJson['coordinates'] is! List) {
    debugPrint("❌ GeoJSON tidak valid atau bukan Polygon.");
    return false;
  }

  try {
    final coordsRaw = geoJson['coordinates'];
    final rawPolygon = List<List<dynamic>>.from(coordsRaw[0]);

    final polygonPoints = rawPolygon.map((point) {
      final lng = (point[0] as num).toDouble();
      final lat = (point[1] as num).toDouble();
      debugPrint("🔹 Titik Polygon: lat=$lat, lon=$lng");
      return LatLng(lat, lng);
    }).toList();

    final result = _isPointInPolygon(LatLng(lat, lon), polygonPoints);
    debugPrint("✅ Titik berada di dalam polygon? $result");
    return result;
  } catch (e) {
    debugPrint("❌ Gagal parsing GeoJSON: $e");
    return false;
  }
}


  /// Fungsi pengecekan titik dalam polygon (algoritma ray-casting)
  static bool _isPointInPolygon(LatLng point, List<LatLng> polygon) {
    int i, j = polygon.length - 1;
    bool isInside = false;

    for (i = 0; i < polygon.length; i++) {
      if ((polygon[i].latitude > point.latitude) != (polygon[j].latitude > point.latitude) &&
          (point.longitude <
              (polygon[j].longitude - polygon[i].longitude) *
                      (point.latitude - polygon[i].latitude) /
                      (polygon[j].latitude - polygon[i].latitude) +
                  polygon[i].longitude)) {
        isInside = !isInside;
      }
      j = i;
    }

    return isInside;
  }
}
