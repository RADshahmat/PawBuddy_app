import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/glass_container.dart';
import '../../../widgets/animated_card.dart';
import '../../../utils/app_colors.dart';

class VolunteerScreen extends StatefulWidget {
  const VolunteerScreen({super.key});
  @override
  State<VolunteerScreen> createState() => _VolunteerScreenState();
}

class _VolunteerScreenState extends State<VolunteerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  final List<Map<String, dynamic>> _volunteerOpportunities = [
    {
      'title': 'Animal Rescue Operations',
      'description': 'Join rescue teams to help save injured and abandoned animals',
      'points': 200,
      'duration': '2-4 hours',
      'difficulty': 'Medium',
      'icon': Icons.pets_rounded,
      'color': [AppColors.primary, AppColors.primaryLight],
      'requirements': ['Physical fitness', 'Animal handling experience preferred'],
      'location': 'Various locations in Dhaka',
    },
    {
      'title': 'Animal Shelter Care',
      'description': 'Help care for animals at local shelters - feeding, cleaning, and socializing',
      'points': 150,
      'duration': '3-5 hours',
      'difficulty': 'Easy',
      'icon': Icons.home_rounded,
      'color': [AppColors.success, Colors.green.shade400],
      'requirements': ['Love for animals', 'Basic hygiene knowledge'],
      'location': 'Animal shelters in Dhaka',
    },
    {
      'title': 'Street Animal Feeding',
      'description': 'Organize and participate in street animal feeding programs',
      'points': 100,
      'duration': '1-2 hours',
      'difficulty': 'Easy',
      'icon': Icons.restaurant_rounded,
      'color': [AppColors.warning, Colors.amber.shade400],
      'requirements': ['Transportation', 'Basic animal safety knowledge'],
      'location': 'Street locations across the city',
    },
    {
      'title': 'Veterinary Assistance',
      'description': 'Assist veterinarians during medical procedures and checkups',
      'points': 250,
      'duration': '4-6 hours',
      'difficulty': 'Hard',
      'icon': Icons.medical_services_rounded,
      'color': [AppColors.error, Colors.red.shade400],
      'requirements': ['Medical background preferred', 'Strong stomach'],
      'location': 'Veterinary clinics',
    },
    {
      'title': 'Animal Awareness Campaigns',
      'description': 'Help spread awareness about animal welfare in communities',
      'points': 120,
      'duration': '2-3 hours',
      'difficulty': 'Easy',
      'icon': Icons.campaign_rounded,
      'color': [AppColors.secondary, AppColors.secondaryLight],
      'requirements': ['Good communication skills', 'Passion for animal welfare'],
      'location': 'Community centers, schools',
    },
    {
      'title': 'Animal Transportation',
      'description': 'Help transport rescued animals to shelters and veterinary clinics',
      'points': 180,
      'duration': '1-3 hours',
      'difficulty': 'Medium',
      'icon': Icons.local_shipping_rounded,
      'color': [AppColors.accent, AppColors.accentLight],
      'requirements': ['Valid driving license', 'Vehicle access'],
      'location': 'Various pickup and drop-off points',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Opportunities'),
        backgroundColor: Colors.transparent,
      ),
      body: GradientBackground(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                AnimatedCard(
                  child: GlassContainer(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.success, Colors.green.shade400],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.volunteer_activism_rounded,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Make a Difference',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Join our community of volunteers and help save animal lives',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Stats Row
                Row(
                  children: [
                    Expanded(child: _buildStatCard('Active\nVolunteers', '1,247', Icons.people_rounded)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildStatCard('Animals\nSaved', '3,892', Icons.pets_rounded)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildStatCard('Hours\nContributed', '15,634', Icons.access_time_rounded)),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                const Text(
                  'Available Opportunities',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Volunteer Opportunities List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _volunteerOpportunities.length,
                  itemBuilder: (context, index) {
                    final opportunity = _volunteerOpportunities[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: _buildOpportunityCard(opportunity),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return AnimatedCard(
      child: GlassContainer(
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: AppColors.primary,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpportunityCard(Map<String, dynamic> opportunity) {
    return AnimatedCard(
      onTap: () => _showOpportunityDetails(opportunity),
      child: GlassContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: opportunity['color'] as List<Color>,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    opportunity['icon'] as IconData,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        opportunity['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        opportunity['description'],
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Info Tags
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildInfoTag(
                  '${opportunity['points']} pts',
                  Icons.stars_rounded,
                  AppColors.warning,
                ),
                _buildInfoTag(
                  opportunity['duration'],
                  Icons.access_time_rounded,
                  AppColors.primary,
                ),
                _buildInfoTag(
                  opportunity['difficulty'],
                  Icons.signal_cellular_alt_rounded,
                  _getDifficultyColor(opportunity['difficulty']),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _joinVolunteer(opportunity),
                style: ElevatedButton.styleFrom(
                  backgroundColor: (opportunity['color'] as List<Color>)[0],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Join This Opportunity',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTag(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppColors.success;
      case 'medium':
        return AppColors.warning;
      case 'hard':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  void _showOpportunityDetails(Map<String, dynamic> opportunity) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: opportunity['color'] as List<Color>,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      opportunity['icon'] as IconData,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      opportunity['title'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              Text(
                opportunity['description'],
                style: const TextStyle(fontSize: 16),
              ),
              
              const SizedBox(height: 16),
              
              _buildDetailRow('Points Earned', '${opportunity['points']} points'),
              _buildDetailRow('Duration', opportunity['duration']),
              _buildDetailRow('Difficulty', opportunity['difficulty']),
              _buildDetailRow('Location', opportunity['location']),
              
              const SizedBox(height: 16),
              
              const Text(
                'Requirements:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              ...(opportunity['requirements'] as List<String>).map((req) => 
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 16,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(req)),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _joinVolunteer(opportunity);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: (opportunity['color'] as List<Color>)[0],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Join Now'),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
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

  void _joinVolunteer(Map<String, dynamic> opportunity) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.addPoints(opportunity['points'] as int);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Successfully joined ${opportunity['title']}! +${opportunity['points']} points earned',
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
