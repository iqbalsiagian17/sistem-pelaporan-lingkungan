// Tambahkan semua import seperti biasa
import 'dart:async';
import 'package:bb_mobile/core/utils/location_validator.dart';
import 'package:bb_mobile/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class ReportLocationToggle extends StatefulWidget {
  final bool isAtLocation;
  final ValueChanged<bool> onChange;
  final bool isDisabled;
  final VoidCallback? onForceChangeToNotAtLocation;

  const ReportLocationToggle({
    super.key,
    required this.isAtLocation,
    required this.onChange,
    this.isDisabled = false,
    this.onForceChangeToNotAtLocation,
  });

  @override
  State<ReportLocationToggle> createState() => _ReportLocationToggleState();
}

class _ReportLocationToggleState extends State<ReportLocationToggle> with WidgetsBindingObserver {
  bool isLocationAvailable = false;
  bool isChecking = false;
  bool _hasShownOutOfAreaDialog = false;
  int countdown = 0;
  Timer? _countdownTimer;
  StreamSubscription<ServiceStatus>? _serviceStatusStream;
  late ValueNotifier<bool> disableAtLocationButton;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    disableAtLocationButton = ValueNotifier(false);
    _checkLocationAvailability();
    _serviceStatusStream = Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      if (status == ServiceStatus.enabled) {
        _checkLocationAvailability(forceEnable: true);
      } else {
        _checkLocationAvailability();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _countdownTimer?.cancel();
    _serviceStatusStream?.cancel();
    disableAtLocationButton.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startCountdownAndRefresh();
    }
  }

  Future<void> _checkLocationAvailability({bool forceEnable = false}) async {
    try {
      setState(() => isChecking = true);
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (!serviceEnabled || permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        setState(() {
          isLocationAvailable = false;
          isChecking = false;
          countdown = 0;
        });
        widget.onChange(false);
        disableAtLocationButton.value = true;
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      setState(() {
        isLocationAvailable = true;
        isChecking = false;
        countdown = 0;
      });

      final lat = position.latitude;
      final long = position.longitude;
      final isInsideBalige = LocationValidator.isInsideBaligeArea(lat, long);

      if (!isInsideBalige) {
        if (!mounted) return;
        if (!_hasShownOutOfAreaDialog) {
          _hasShownOutOfAreaDialog = true;
          await _showOutOfAreaDialog();
        }

        widget.onForceChangeToNotAtLocation?.call();
        disableAtLocationButton.value = true;
        return;
      }

      if (forceEnable) {
        widget.onChange(true);
        disableAtLocationButton.value = false;
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        isLocationAvailable = false;
        isChecking = false;
        countdown = 0;
      });
      widget.onChange(false);
      disableAtLocationButton.value = true;
    }
  }

  Future<void> _showOutOfAreaDialog() async {
    await showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 24,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
              const SizedBox(height: 12),
              const Text(
                "Lokasi Di Luar Area Pelaporan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                "Sistem mendeteksi bahwa Anda berada di luar wilayah Kecamatan Balige.\n\n"
                "Silakan lanjutkan dengan mengisi informasi lokasi secara manual agar laporan tetap dapat diproses.",
                style: TextStyle(fontSize: 14, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: "Mengerti",
                onPressed: () => Navigator.of(context).pop(),
                color: Colors.green[700]!,
                textColor: Colors.white,
              ),
            ],
          ),
        );
      },
    );
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
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

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
        const Text("Apakah Anda masih di lokasi kejadian?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ValueListenableBuilder<bool>(
                valueListenable: disableAtLocationButton,
                builder: (context, isDisabledManual, child) {
                  return ElevatedButton(
                    onPressed: (widget.isDisabled || isDisabledManual) ? null : () => widget.onChange(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.isAtLocation ? const Color(0xFF66BB6A) : Colors.white,
                      foregroundColor: widget.isAtLocation ? Colors.white : Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Masih di Lokasi"),
                  );
                },
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
                                const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
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
