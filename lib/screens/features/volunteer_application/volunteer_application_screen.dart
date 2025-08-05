import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/simple_card.dart';
import '../../../widgets/animated_card.dart';
import '../../../utils/app_colors.dart';
import '../../../models/rescue_team_model.dart';
import '../../../providers/auth_provider.dart';

class VolunteerApplicationScreen extends StatefulWidget {
  final RescueTeamModel rescueTeam;

  const VolunteerApplicationScreen({
    Key? key,
    required this.rescueTeam,
  }) : super(key: key);

  @override
  State<VolunteerApplicationScreen> createState() => _VolunteerApplicationScreenState();
}

class _VolunteerApplicationScreenState extends State<VolunteerApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _motivationController = TextEditingController();
  final _experienceController = TextEditingController();
  
  String _selectedAvailability = 'Weekends';
  final List<String> _availabilityOptions = [
    'Weekends',
    'Weekdays',
    'Evenings',
    'Flexible',
    'Full-time',
  ];
  
  final List<String> _allSkills = [
    'Animal Care',
    'First Aid',
    'Veterinary Knowledge',
    'Animal Handling',
    'Photography',
    'Social Media',
    'Transportation',
    'Fundraising',
    'Event Organization',
    'Medical Care',
    'Rehabilitation',
    'Training',
  ];
  
  List<String> _selectedSkills = [];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _motivationController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Application'),
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
                // Team Info Card
                SimpleCard(
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.rescueTeam.imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
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
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.rescueTeam.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Volunteer Application',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Motivation Section
                _buildSectionTitle('Why do you want to volunteer?'),
                const SizedBox(height: 12),
                SimpleCard(
                  child: TextFormField(
                    controller: _motivationController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Tell us about your motivation to help animals...',
                      border: InputBorder.none,
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(bottom: 60),
                        child: Icon(Icons.favorite_rounded, color: AppColors.primary),
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please share your motivation';
                      }
                      if (value!.length < 50) {
                        return 'Please provide more details (at least 50 characters)';
                      }
                      return null;
                    },
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Experience Section
                _buildSectionTitle('Previous Experience'),
                const SizedBox(height: 12),
                SimpleCard(
                  child: TextFormField(
                    controller: _experienceController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Describe any experience with animals, volunteering, or related activities...',
                      border: InputBorder.none,
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(bottom: 40),
                        child: Icon(Icons.work_rounded, color: AppColors.primary),
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please describe your experience (or write "No prior experience")';
                      }
                      return null;
                    },
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Availability Section
                _buildSectionTitle('Availability'),
                const SizedBox(height: 12),
                SimpleCard(
                  child: DropdownButtonFormField<String>(
                    value: _selectedAvailability,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.schedule_rounded, color: AppColors.primary),
                    ),
                    dropdownColor: Theme.of(context).cardColor,
                    items: _availabilityOptions.map((availability) => DropdownMenuItem(
                      value: availability,
                      child: Text(availability),
                    )).toList(),
                    onChanged: (value) => setState(() => _selectedAvailability = value!),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Skills Section
                _buildSectionTitle('Skills & Interests'),
                const SizedBox(height: 12),
                SimpleCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select skills that apply to you:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _allSkills.map((skill) {
                          final isSelected = _selectedSkills.contains(skill);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedSkills.remove(skill);
                                } else {
                                  _selectedSkills.add(skill);
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? AppColors.primary 
                                    : AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                skill,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      if (_selectedSkills.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            'Please select at least one skill',
                            style: TextStyle(
                              color: AppColors.error,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Submit Button
                AnimatedCard(
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitApplication,
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
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Submit Application',
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

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedSkills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one skill'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.currentUser!;

      // Here you would normally send the application to your backend
      // For now, we'll just show a success message
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Application submitted successfully! You will be notified of the decision.'),
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit application. Please try again.'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }
}
