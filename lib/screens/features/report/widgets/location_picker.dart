import 'package:flutter/material.dart';
import '../../../../widgets/gradient_background.dart';
import '../../../../widgets/glass_container.dart';
import '../../../../utils/app_colors.dart';

class LocationPicker extends StatefulWidget {
  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  double _selectedLat = 23.8103; // Default to Dhaka
  double _selectedLng = 90.4125;
  String _selectedAddress = 'Dhaka, Bangladesh';

  // Demo locations for Bangladesh
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: _confirmLocation,
            child: const Text(
              'Confirm',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: GradientBackground(
        child: Column(
          children: [
            // Map Placeholder (In real app, use Google Maps or similar)
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.all(20),
                child: GlassContainer(
                  child: Stack(
                    children: [
                      // Map background
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.secondary.withOpacity(0.3),
                              AppColors.primary.withOpacity(0.3),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.map_rounded,
                                size: 80,
                                color: AppColors.primary,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Interactive Map',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Tap on locations below to select',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Location marker
                      const Center(
                        child: Icon(
                          Icons.location_on_rounded,
                          size: 40,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Location List
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _demoLocations.length,
                        itemBuilder: (context, index) {
                          final location = _demoLocations[index];
                          final isSelected = _selectedLat == location['lat'] && 
                                           _selectedLng == location['lng'];
                          
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: GlassContainer(
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
                                  child: Icon(
                                    Icons.location_on_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                title: Text(
                                  location['name'],
                                  style: TextStyle(
                                    fontWeight: isSelected 
                                        ? FontWeight.bold 
                                        : FontWeight.w500,
                                    color: isSelected 
                                        ? AppColors.primary 
                                        : null,
                                  ),
                                ),
                                subtitle: Text(
                                  location['address'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                trailing: isSelected
                                    ? const Icon(
                                        Icons.check_circle_rounded,
                                        color: AppColors.primary,
                                      )
                                    : null,
                                onTap: () => _selectLocation(location),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Selected Location Info
            Container(
              padding: const EdgeInsets.all(20),
              child: GlassContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selected Location',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selectedAddress,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Lat: ${_selectedLat.toStringAsFixed(6)}, Lng: ${_selectedLng.toStringAsFixed(6)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectLocation(Map<String, dynamic> location) {
    setState(() {
      _selectedLat = location['lat'];
      _selectedLng = location['lng'];
      _selectedAddress = location['address'];
    });
  }

  void _confirmLocation() {
    Navigator.pop(context, {
      'latitude': _selectedLat,
      'longitude': _selectedLng,
      'address': _selectedAddress,
    });
  }
}
