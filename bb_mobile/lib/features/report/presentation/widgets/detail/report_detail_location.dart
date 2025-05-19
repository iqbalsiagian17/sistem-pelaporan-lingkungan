import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:bb_mobile/core/utils/location_validator.dart';

class ReportDetailLocation extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String? village;
  final String? locationDetails;

  const ReportDetailLocation({
    super.key,
    required this.latitude,
    required this.longitude,
    this.village,
    this.locationDetails,
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
              )
            ],
          ),
          const SizedBox(height: 10),

          if (isAtLocation) ...[
            SizedBox(
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(latitude, longitude),
                    initialZoom: 17,
                    interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    // ✅ Tambahkan Polygon wilayah
                    PolygonLayer(
                        polygons: [
                          Polygon(
                            points: [
                              
                              // kordinat untuk balige
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
 

                              // kordinat untuk IT Del
 /*                              LatLng(2.3821346987402734, 99.14864504109096),  
                              LatLng(2.3838726531813705, 99.15010217927676), 
                              LatLng(2.3860159060928225, 99.14913878783454), 
                              LatLng(2.387439499090263, 99.15088260843959),  
                              LatLng(2.388608119104404, 99.14995753287604),  
                              LatLng(2.386462107041467, 99.14599140430448), 
                              LatLng(2.384369210862843, 99.14689521376397),  
                              LatLng(2.383476807463012, 99.14692711292173),  
                              LatLng(2.382124393177463, 99.14864643676253),    */

                            ],
                            color: Colors.green.withOpacity(0.3),
                            borderStrokeWidth: 2,
                            borderColor: Colors.green,
                          ),
                        ],
                      ),
                    // Marker titik lokasi laporan
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(latitude, longitude),
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
            ),
            if (locationDetails != null && locationDetails!.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text("Detail Lokasi:"),
              Text(
                locationDetails!,
                style: const TextStyle(color: Colors.black87),
              ),
            ],
          ] else ...[
            if (village != null && village!.isNotEmpty) ...[
              const Text(
                "Nama Desa/Kelurahan:",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(village!, style: const TextStyle(color: Colors.black87)),
              const SizedBox(height: 8),
            ],
            if (locationDetails != null && locationDetails!.isNotEmpty) ...[
              const Text(
                "Detail Lokasi:",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(locationDetails!, style: const TextStyle(color: Colors.black87)),
            ],
          ],
        ],
      ),
    );
  }
}
