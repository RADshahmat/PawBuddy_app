import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../widgets/simple_card.dart';
import '../../../../widgets/animated_card.dart';
import '../../../../utils/app_colors.dart';

class LocationPickerCard extends StatefulWidget {
  final Function(double lat, double lng, String address) onLocationSelected;
  final double? initialLat;
  final double? initialLng;

  const LocationPickerCard({
    Key? key,
    required this.onLocationSelected,
    this.initialLat,
    this.initialLng,
  }) : super(key: key);

  @override
  State<LocationPickerCard> createState() => _LocationPickerCardState();
}

class _LocationPickerCardState extends State<LocationPickerCard> {
  final MapController _mapController = MapController();
  LatLng _selectedLocation = const LatLng(23.8103, 90.4125); // Default to Dhaka
  String _selectedAddress = 'Dhaka, Bangladesh';
  bool _isLoadingLocation = false;
  bool _hasLocationPermission = false;

  final List<Map<String, dynamic>> _demoLocations = [
    {
      'name': 'Dhanmondi, Dhaka',
      'lat': 23.7461,
      'lng': 90.3742,
      'address': 'Dhanmondi, Dhaka-1205, Bangladesh'
    },
    {
      'name': 'Gulshan, Dhaka',
      'lat': 23.7925,
      'lng': 90.4078,
      'address': 'Gulshan, Dhaka-1212, Bangladesh'
    },
    {
      'name': 'Uttara, Dhaka',
      'lat': 23.8759,
      'lng': 90.3795,
      'address': 'Uttara, Dhaka-1230, Bangladesh'
    },
    {
      'name': 'Chittagong',
      'lat': 22.3569,
      'lng': 91.7832,
      'address': 'Chittagong, Bangladesh'
    },
    {
      'name': 'Sylhet',
      'lat': 24.8949,
      'lng': 91.8687,
      'address': 'Sylhet, Bangladesh'
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialLat != null && widget.initialLng != null) {
      _selectedLocation = LatLng(widget.initialLat!, widget.initialLng!);
    }
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.location.status;
    setState(() {
      _hasLocationPermission = status.isGranted;
    });
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    setState(() {
      _hasLocationPermission = status.isGranted;
    });

    if (status.isGranted) {
      _getCurrentLocation();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permission is required to use current location'),
          backgroundColor: AppColors.warning,
        ),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    if (!_hasLocationPermission) {
      await _requestLocationPermission();
      return;
    }

    setState(() => _isLoadingLocation = true);

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final newLocation = LatLng(position.latitude, position.longitude);
      setState(() {
        _selectedLocation = newLocation;
        _selectedAddress =
        'Current Location (${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)})';
      });

      _mapController.move(newLocation, 15.0);
      widget.onLocationSelected(position.latitude, position.longitude, _selectedAddress);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to get current location'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    setState(() {
      _selectedLocation = point;
      _selectedAddress =
      'Selected Location (${point.latitude.toStringAsFixed(6)}, ${point.longitude.toStringAsFixed(6)})';
    });
    widget.onLocationSelected(point.latitude, point.longitude, _selectedAddress);
  }

  void _selectPresetLocation(Map<String, dynamic> location) {
    final newLocation = LatLng(location['lat'], location['lng']);
    setState(() {
      _selectedLocation = newLocation;
      _selectedAddress = location['address'];
    });
    _mapController.move(newLocation, 15.0);
    widget.onLocationSelected(location['lat'], location['lng'], location['address']);
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // allows full height control
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75, // set max height (75% of screen)
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Popular Locations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              ..._demoLocations.map((location) {
                final isSelected = _selectedLocation.latitude == location['lat'] &&
                    _selectedLocation.longitude == location['lng'];

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: SimpleCard(
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isSelected
                                ? [AppColors.primary, AppColors.primaryLight]
                                : [AppColors.textLight, AppColors.textSecondary],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.location_on_rounded, color: Colors.white, size: 20),
                      ),
                      title: Text(
                        location['name'],
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? AppColors.primary : null,
                        ),
                      ),
                      subtitle: Text(
                        location['address'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                          : null,
                      onTap: () {
                        _selectPresetLocation(location);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        AnimatedCard(
          child: SimpleCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        maxZoom: 53.0,
                        onTap: _onMapTap,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.stray_animal_app',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: 40,
                              height: 40,
                              point: _selectedLocation,
                              child: const Icon(Icons.location_on_rounded, color: AppColors.error, size: 40),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Selected Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                Text(
                                  _selectedAddress,
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                              icon: _isLoadingLocation
                                  ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                                  : const Icon(Icons.my_location_rounded, size: 16),
                              label: Text(_isLoadingLocation ? 'Getting...' : 'Current'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.success,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _showLocationPicker,
                              icon: const Icon(Icons.list_rounded, size: 16),
                              label: const Text('Presets'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (!_hasLocationPermission)
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.warning_rounded, color: AppColors.warning, size: 16),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Location permission required for current location',
                                  style: TextStyle(color: AppColors.warning, fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
