import 'package:latlong2/latlong.dart';

class LocationValidator {
  // 🟢 Koordinat resmi wilayah Kecamatan Balige
  static const List<LatLng> _baligePolygon = [

    // Koordinat polygon Balige
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

    // Koordinat polygon It Del
/*     LatLng(2.3821346987402734, 99.14864504109096),  
    LatLng(2.3838726531813705, 99.15010217927676), 
    LatLng(2.3860159060928225, 99.14913878783454), 
    LatLng(2.387439499090263, 99.15088260843959),  
    LatLng(2.388608119104404, 99.14995753287604),  
    LatLng(2.386462107041467, 99.14599140430448), 
    LatLng(2.384369210862843, 99.14689521376397),  
    LatLng(2.383476807463012, 99.14692711292173),  
    LatLng(2.382124393177463, 99.14864643676253),    */
  ];

  // Mengecek apakah koordinat berada dalam polygon wilayah Kecamatan Balige
  static bool isInsideBaligeArea(double lat, double lon) {
    final userLocation = LatLng(lat, lon);
    return _isPointInPolygon(userLocation, _baligePolygon);
  }

  /// Fungsi untuk mengecek apakah titik berada di dalam polygon
  static bool _isPointInPolygon(LatLng point, List<LatLng> polygon) {
    int i, j = polygon.length - 1;
    bool isInside = false;

    for (i = 0; i < polygon.length; i++) {
      if (point.latitude > polygon[i].latitude != point.latitude > polygon[j].latitude &&
          point.longitude < (polygon[j].longitude - polygon[i].longitude) *
              (point.latitude - polygon[i].latitude) /
              (polygon[j].latitude - polygon[i].latitude) +
              polygon[i].longitude) {
        isInside = !isInside;
      }
      j = i;
    }
    return isInside;
  }
}
