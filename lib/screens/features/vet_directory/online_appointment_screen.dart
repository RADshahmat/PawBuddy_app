import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/simple_card.dart';
import '../../../utils/app_colors.dart';
import '../../../providers/auth_provider.dart'; // For user data

class OnlineAppointmentScreen extends StatefulWidget {
  final Map<String, dynamic> vet;

  const OnlineAppointmentScreen({Key? key, required this.vet}) : super(key: key);

  @override
  State<OnlineAppointmentScreen> createState() => _OnlineAppointmentScreenState();
}

class _OnlineAppointmentScreenState extends State<OnlineAppointmentScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _petNameController;
  String? _selectedTimeSlot;

  final List<String> _timeSlots = [
    '9:00 AM - 10:00 AM',
    '11:00 AM - 12:00 PM',
    '2:00 PM - 3:00 PM',
    '4:00 PM - 5:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.currentUser;

    _nameController = TextEditingController(text: currentUser?.name ?? '');
    _phoneController = TextEditingController(text: currentUser?.phoneNumber ?? '');
    _emailController = TextEditingController(text: currentUser?.email ?? '');
    _petNameController = TextEditingController(text: 'Buddy'); // Demo pet name
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _petNameController.dispose();
    super.dispose();
  }

  void _submitAppointment() {
    if (_selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a time slot.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Here you would typically send the appointment data to a backend API
    print('Submitting appointment for:');
    print('Vet: ${widget.vet['name']}');
    print('Name: ${_nameController.text}');
    print('Phone: ${_phoneController.text}');
    print('Email: ${_emailController.text}');
    print('Pet Name: ${_petNameController.text}');
    print('Time Slot: $_selectedTimeSlot');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Appointment requested for ${widget.vet['name']} at $_selectedTimeSlot!'),
        backgroundColor: AppColors.success,
      ),
    );

    Navigator.pop(context); // Go back to previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment with ${widget.vet['name']}'),
        backgroundColor: Colors.transparent,
      ),
      body: GradientBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SimpleCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(_nameController, 'Your Name', Icons.person),
                    const SizedBox(height: 16),
                    _buildTextField(_phoneController, 'Phone Number', Icons.phone, keyboardType: TextInputType.phone),
                    const SizedBox(height: 16),
                    _buildTextField(_emailController, 'Email Address', Icons.email, keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 24),
                    Text(
                      'Pet Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(_petNameController, 'Pet Name', Icons.pets),
                    const SizedBox(height: 24),
                    Text(
                      'Select Time Slot',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedTimeSlot,
                          hint: const Text('Choose a time slot'),
                          icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.primary),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedTimeSlot = newValue;
                            });
                          },
                          items: _timeSlots.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _submitAppointment,
                        icon: const Icon(Icons.check_circle_rounded, size: 24),
                        label: const Text(
                          'Confirm Appointment',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}
