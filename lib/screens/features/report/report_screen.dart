import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/simple_card.dart';
import '../../../widgets/animated_card.dart';
import '../../../utils/app_colors.dart';
import '../../../models/user_model.dart';
import 'widgets/location_picker_card.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

class ReportScreen extends StatefulWidget {
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  String _selectedAnimalType = 'Dog';
  String _selectedCondition = 'Injured';
  List<File> _images = [];
  bool _isSubmitting = false;
  double? _latitude;
  double? _longitude;
  String? _locationAddress;

  final List<String> _animalTypes = ['Dog', 'Cat', 'Bird', 'Rabbit', 'Other'];
  final List<String> _conditions = [
    'Injured',
    'Severely Injured',
    'Sick',
    'Healthy but Stray',
    'Abandoned',
    'Lost',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser!;

    if (!user.canUploadMultipleImages && _images.isNotEmpty) {
      _showSnackBar(
        'Normal users can only upload 1 image. Upgrade to Premium for more!',
        AppColors.warning,
      );
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _onLocationSelected(double lat, double lng, String address) {
    setState(() {
      _latitude = lat;
      _longitude = lng;
      _locationAddress = address;
    });
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    if (_images.isEmpty) {
      _showSnackBar('Please add at least one image', AppColors.error);
      return;
    }

    if (_latitude == null || _longitude == null) {
      _showSnackBar('Please select location on map', AppColors.error);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final uri = Uri.parse('https://pawbuddy.cse.pstu.ac.bd/api/reports');
      var request = http.MultipartRequest('POST', uri);

      // Add form fields with corrected names
      request.fields['title'] = "testing";
      request.fields['animalType'] = _selectedAnimalType;

      // rename condition → animalCondition
      request.fields['animalCondition'] = _selectedCondition;

      request.fields['description'] = _descriptionController.text;

      // location as JSON string (object with lat, long)
      request.fields['location.latitude'] = _latitude.toString();
      request.fields['location.longitude'] = _longitude.toString();

      // Add reportedBy user id (your schema uses this key)
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.currentUser!;
      request.fields['userId'] = user.id;
      //request.fields['reportedBy'] = user.id;

      // Optional: add contact info if available

      // Add images as 'photos[]' (matching schema's photos array)
      for (var image in _images) {
        final mimeType =
            lookupMimeType(image.path) ?? 'application/octet-stream';
        final mediaTypeSplit = mimeType.split('/');
        final multipartFile = await http.MultipartFile.fromPath(
          'images[]',
          image.path,
          contentType: MediaType(mediaTypeSplit[0], mediaTypeSplit[1]),
          filename: path.basename(image.path),
        );
        request.files.add(multipartFile);
      }

      // Send request
      final response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        authProvider.addPoints(50);
        _showSnackBar(
          'Report submitted successfully! +50 points earned',
          AppColors.success,
        );
        Navigator.pop(context);
      } else {
        final responseBody = await response.stream.bytesToString();
        _showSnackBar(
          'Failed: ${response.statusCode} - $responseBody',
          AppColors.error,
        );
      }
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}', AppColors.error);
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Stray Animal'),
        backgroundColor: Colors.transparent,
      ),
      body: GradientBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Points Info Card
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    final user = authProvider.currentUser!;
                    if (!user.canEarnPoints) return const SizedBox.shrink();

                    return AnimatedCard(
                      child: SimpleCard(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.success,
                                    Colors.green.shade400,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.stars_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Text(
                                'Earn 50 points for each report!',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Animal Type Selection
                _buildSectionTitle('Animal Type'),
                const SizedBox(height: 12),
                SimpleCard(
                  child: DropdownButtonFormField<String>(
                    value: _selectedAnimalType,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.pets_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                    dropdownColor: Theme.of(context).cardColor,
                    items: _animalTypes
                        .map(
                          (type) =>
                              DropdownMenuItem(value: type, child: Text(type)),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedAnimalType = value!),
                  ),
                ),

                const SizedBox(height: 20),

                // Condition Selection
                _buildSectionTitle('Animal Condition'),
                const SizedBox(height: 12),
                SimpleCard(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCondition,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.health_and_safety_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                    dropdownColor: Theme.of(context).cardColor,
                    items: _conditions
                        .map(
                          (condition) => DropdownMenuItem(
                            value: condition,
                            child: Text(condition),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedCondition = value!),
                  ),
                ),

                const SizedBox(height: 20),

                // Location Selection with Map
                LocationPickerCard(
                  onLocationSelected: _onLocationSelected,
                  initialLat: _latitude,
                  initialLng: _longitude,
                ),

                const SizedBox(height: 20),

                // Description Field
                _buildSectionTitle('Description'),
                const SizedBox(height: 12),
                SimpleCard(
                  child: TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText:
                          'Provide additional details about the animal...',
                      border: InputBorder.none,
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(bottom: 60),
                        child: Icon(
                          Icons.description_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please provide a description';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Image Section
                _buildSectionTitle('Photos'),
                const SizedBox(height: 12),

                // Add Image Button
                AnimatedCard(
                  onTap: _pickImage,
                  child: SimpleCard(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.primaryLight,
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Take Photo',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            final user = authProvider.currentUser!;
                            if (!user.canUploadMultipleImages) {
                              return Text(
                                'Normal users: 1 image limit',
                                style: TextStyle(
                                  color: AppColors.warning,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Image Preview
                if (_images.isNotEmpty) ...[
                  _buildSectionTitle('Selected Images (${_images.length})'),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 12),
                          child: Stack(
                            children: [
                              SimpleCard(
                                width: 120,
                                height: 120,
                                padding: const EdgeInsets.all(4),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.file(
                                    _images[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () => _removeImage(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: AppColors.error,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close_rounded,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // Submit Button
                AnimatedCard(
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.success, Colors.green.shade400],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Submit Report',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }
}
