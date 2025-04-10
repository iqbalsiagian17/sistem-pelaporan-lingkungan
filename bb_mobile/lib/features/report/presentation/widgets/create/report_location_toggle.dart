import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class ReportLocationToggle extends StatefulWidget {
  final bool isAtLocation;
  final ValueChanged<bool> onChange;
  final bool isDisabled;

  const ReportLocationToggle({
    super.key,
    required this.isAtLocation,
    required this.onChange,
    this.isDisabled = false,
  });

  @override
  State<ReportLocationToggle> createState() => _ReportLocationToggleState();
}

class _ReportLocationToggleState extends State<ReportLocationToggle> with WidgetsBindingObserver {
  bool isLocationAvailable = false;
  bool isChecking = false;
  int countdown = 0;
  Timer? _countdownTimer;
  StreamSubscription<ServiceStatus>? _serviceStatusStream;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkLocationAvailability();
    _serviceStatusStream = Geolocator.getServiceStatusStream().listen((_) {
      _checkLocationAvailability();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _countdownTimer?.cancel();
    _serviceStatusStream?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startCountdownAndRefresh(); // Mulai ulang countdown saat kembali ke app
    }
  }

  Future<void> _checkLocationAvailability() async {
    try {
      setState(() => isChecking = true);
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      final permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }

      if (!serviceEnabled || permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        if (!mounted) return;
          setState(() {
            isLocationAvailable = false;
            isChecking = false;
          });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      setState(() {
        isLocationAvailable = position != null;
        isChecking = false;
        countdown = 0;
      });
    } catch (_) {
    if (!mounted) return;
      setState(() {
        isLocationAvailable = false;
        isChecking = false;
      });
    }
  }

  void _startCountdownAndRefresh() {
    if (countdown > 0) return;
    countdown = 10;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        countdown--;
        if (countdown <= 0) {
          timer.cancel();
          _checkLocationAvailability();
        }
      });
    });
  }

Future<void> _showLocationMap(BuildContext context) async {
  try {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    // Get current position of the user
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (context.mounted) Navigator.pop(context);

    if (context.mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("Lokasi Anda Sekarang",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: FlutterMap(
                    options: MapOptions(
                      center: LatLng(position.latitude, position.longitude),
                      zoom: 16.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                      ),
                      // Polygon layer for Balige area boundary using GeoJSON coordinates
                      PolygonLayer(
                        polygons: [
                          Polygon(
                            points: [
                              
                              // kordinat untuk balige
/*                               LatLng(2.3495373075169397, 99.03711737302717), 
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
 */

                              // kordinat untuk IT Del
                              LatLng(2.3821346987402734, 99.14864504109096),  
                              LatLng(2.3838726531813705, 99.15010217927676), 
                              LatLng(2.3860159060928225, 99.14913878783454), 
                              LatLng(2.387439499090263, 99.15088260843959),  
                              LatLng(2.388608119104404, 99.14995753287604),  
                              LatLng(2.386462107041467, 99.14599140430448), 
                              LatLng(2.384369210862843, 99.14689521376397),  
                              LatLng(2.383476807463012, 99.14692711292173),  
                              LatLng(2.382124393177463, 99.14864643676253),   

                            ],
                            color: Colors.green.withOpacity(0.3),
                            borderStrokeWidth: 2,
                            borderColor: Colors.green,
                          ),
                        ],
                      ),
                      // Marker for current location
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(position.latitude, position.longitude),
                            width: 40,
                            height: 40,
                            child: const Icon(Icons.location_pin, size: 40, color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    "Lat: ${position.latitude}, Long: ${position.longitude}",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  } catch (_) {
    if (context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menampilkan lokasi")),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    final infoColor = isLocationAvailable ? const Color(0xFF2E7D32) : const Color(0xFFF57F17);
    final bgColor = isLocationAvailable ? const Color(0xFFE8F5E9) : const Color(0xFFFFF8E1);
    final borderColor = isLocationAvailable ? const Color(0xFF66BB6A) : const Color(0xFFFFEE58);
    final icon = isLocationAvailable ? Icons.check_circle : Icons.warning_amber_rounded;
    final message = isLocationAvailable
        ? "Lokasi Anda telah berhasil terdeteksi secara otomatis melalui GPS."
        : "Kami belum bisa mendeteksi lokasi Anda. Pastikan GPS aktif dan izin lokasi telah diberikan.";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Apakah Anda masih di lokasi kejadian?",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: widget.isDisabled ? null : () => widget.onChange(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.isAtLocation ? const Color(0xFF66BB6A) : Colors.white,
                  foregroundColor: widget.isAtLocation ? Colors.white : Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Masih di Lokasi"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: widget.isDisabled ? null : () => widget.onChange(false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: !widget.isAtLocation ? const Color(0xFF66BB6A) : Colors.white,
                  foregroundColor: !widget.isAtLocation ? Colors.white : Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Tidak di Lokasi"),
              ),
            ),
          ],
        ),
        if (widget.isAtLocation) ...[
          const SizedBox(height: 12),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: infoColor, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        message,
                        style: TextStyle(fontSize: 14, color: infoColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: isLocationAvailable
                      ? TextButton.icon(
                          onPressed: () => _showLocationMap(context),
                          icon: const Icon(Icons.map, size: 18),
                          label: const Text("Lihat Lokasi Saya"),
                        )
                      : (countdown > 0
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2)),
                                const SizedBox(width: 10),
                                Text("Mengecek lokasi... ($countdown detik)"),
                              ],
                            )
                          : TextButton.icon(
                              onPressed: _startCountdownAndRefresh,
                              icon: const Icon(Icons.refresh, size: 18),
                              label: const Text("Coba Lagi"),
                            )),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
