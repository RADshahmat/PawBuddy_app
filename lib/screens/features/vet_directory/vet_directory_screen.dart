import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/simple_card.dart';
import '../../../widgets/animated_card.dart';
import '../../../utils/app_colors.dart';

class VetDirectoryScreen extends StatefulWidget {
  const VetDirectoryScreen({super.key});
  @override
  State<VetDirectoryScreen> createState() => _VetDirectoryScreenState();
}

class _VetDirectoryScreenState extends State<VetDirectoryScreen> {
  String _searchQuery = '';
  
  final List<Map<String, dynamic>> _vets = [
    {
      'name': 'Central Veterinary Hospital',
      'phone': '01745-137090',
      'location': 'Dhanmondi, Dhaka',
      'address': 'House 12, Road 7, Dhanmondi, Dhaka-1205',
      'rating': 4.8,
      'distance': '2.3 km',
      'services': ['Emergency Care', 'Surgery', 'Vaccination', 'X-Ray'],
      'availability': '24/7',
      'specialties': ['Small Animals', 'Emergency Medicine'],
      'imageUrl': 'assets/images/vet1.jpg',
    },
    {
      'name': 'City Pet Clinic',
      'phone': '01701-022274',
      'location': 'DIT Road, Dhaka',
      'address': '364 DIT Road, Malibagh, Dhaka-1217',
      'rating': 4.6,
      'distance': '3.1 km',
      'services': ['General Care', 'Grooming', 'Dental', 'Vaccination'],
      'availability': 'Daily 9AM-9PM',
      'specialties': ['Cats', 'Dogs', 'Grooming'],
      'imageUrl': 'assets/images/vet2.jpg',
    },
    {
      'name': 'Barishal Pet Clinic',
      'phone': '01739-846399',
      'location': 'Barishal',
      'address': 'Golden view market, Katpotti Rd, Barishal',
      'rating': 4.5,
      'distance': '156 km',
      'services': ['Emergency Care', 'X-Ray', 'Lab Tests', 'Surgery'],
      'availability': 'Daily 8AM-8PM',
      'specialties': ['Large Animals', 'Farm Animals'],
      'imageUrl': 'assets/images/vet3.jpg',
    },
    {
      'name': 'PAW Life Care',
      'phone': '01909-617994',
      'location': 'Lalmatia, Dhaka',
      'address': '1/2, Block- G, Lalmatia, Dhaka-1207',
      'rating': 4.9,
      'distance': '1.8 km',
      'services': ['24/7 Emergency', 'Surgery', 'Rehabilitation', 'ICU'],
      'availability': '24/7',
      'specialties': ['Critical Care', 'Orthopedics', 'Cardiology'],
      'imageUrl': 'assets/images/vet4.jpg',
    },
  ];

  List<Map<String, dynamic>> get _filteredVets {
    if (_searchQuery.isEmpty) return _vets;
    return _vets.where((vet) {
      return vet['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
             vet['location'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
             vet['services'].any((service) => 
                 service.toLowerCase().contains(_searchQuery.toLowerCase()));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Veterinary Directory'),
        backgroundColor: Colors.transparent,
      ),
      body: GradientBackground(
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.all(20),
              child: SimpleCard(
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: const InputDecoration(
                    hintText: 'Search vets, locations, or services...',
                    prefixIcon: Icon(Icons.search_rounded, color: AppColors.primary),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            
            // Results Count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    '${_filteredVets.length} veterinarians found',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      // Sort functionality
                    },
                    icon: const Icon(Icons.sort_rounded, size: 16),
                    label: const Text('Sort'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Vet List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filteredVets.length,
                itemBuilder: (context, index) {
                  final vet = _filteredVets[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: _buildVetCard(vet),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVetCard(Map<String, dynamic> vet) {
    return AnimatedCard(
      onTap: () => _showVetDetails(vet),
      child: SimpleCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    vet['imageUrl'],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.local_hospital_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vet['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              vet['location'],
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Text(
                            vet['distance'],
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Rating and Availability
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${vet['rating']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    vet['availability'],
                    style: const TextStyle(
                      color: AppColors.success,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Services
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: (vet['services'] as List<String>).take(3).map((service) => 
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    service,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ).toList(),
            ),
            
            const SizedBox(height: 16),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _makeCall(vet['phone']),
                    icon: const Icon(Icons.phone_rounded, size: 18),
                    label: const Text('Call'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showVetDetails(vet),
                    icon: const Icon(Icons.info_rounded, size: 18),
                    label: const Text('Details'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showVetDetails(Map<String, dynamic> vet) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SimpleCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      vet['imageUrl'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.local_hospital_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      vet['name'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              _buildDetailRow(Icons.location_on_rounded, 'Address', vet['address']),
              _buildDetailRow(Icons.phone_rounded, 'Phone', vet['phone']),
              _buildDetailRow(Icons.access_time_rounded, 'Hours', vet['availability']),
              _buildDetailRow(Icons.star_rounded, 'Rating', '${vet['rating']} / 5.0'),
              
              const SizedBox(height: 16),
              
              const Text(
                'Services:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (vet['services'] as List<String>).map((service) => 
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      service,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ).toList(),
              ),
              
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _makeCall(vet['phone']),
                      icon: const Icon(Icons.phone_rounded),
                      label: const Text('Call Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _makeCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch phone dialer'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
