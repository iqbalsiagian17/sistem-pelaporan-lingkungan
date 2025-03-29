import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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
              Icon(Icons.location_on, color: Colors.green),
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
                    initialZoom: 15,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                    ),
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
            const SizedBox(height: 10),
            Text(
              "Latitude: $latitude\nLongitude: $longitude",
              style: const TextStyle(color: Colors.black87),
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
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              village!,
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 8),
          ],
          if (locationDetails != null && locationDetails!.isNotEmpty) ...[
            const Text(
              "Detail Lokasi:",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              locationDetails!,
              style: const TextStyle(color: Colors.black87),
            ),
          ],
        ],
        ],
      ),
    );
  }
}
