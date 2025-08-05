import 'package:flutter/material.dart';
import '../../../widgets/glass_container.dart';
import '../../../widgets/animated_card.dart';
import '../../../utils/app_colors.dart';
import '../../../models/user_model.dart';
import '../../features/vet_directory/vet_directory_screen.dart';
import '../../features/volunteer/volunteer_screen.dart';
import '../../features/food_store/food_store_screen.dart';
import '../../features/education/education_screen.dart';
import '../../features/rewards/rewards_screen.dart';
import '../../features/leaderboard/leaderboard_screen.dart';

class FeatureGrid extends StatelessWidget {
  final UserModel user;

  const FeatureGrid({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final features = _getFeatures();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        itemCount: features.length,
        itemBuilder: (context, index) {
          final feature = features[index];
          return _buildFeatureCard(context, feature);
        },
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, Map<String, dynamic> feature) {
    final isPremium = feature['isPremium'] == true;
    final canAccess = !isPremium || user.canEarnPoints;
    
    return AnimatedCard(
      onTap: () => _handleFeatureTap(context, feature),
      child: GlassContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: feature['colors'] as List<Color>,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    feature['icon'] as IconData,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                if (isPremium && !canAccess)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.warning,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              feature['title'] as String,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            if (isPremium && !canAccess) ...[
              const SizedBox(height: 4),
              Text(
                'Premium',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.warning,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFeatures() {
    return [
      {
        'title': 'Vet Directory',
        'icon': Icons.local_hospital_rounded,
        'colors': [AppColors.error, Colors.red.shade400],
        'screen': VetDirectoryScreen(),
        'isPremium': false,
      },
      {
        'title': 'Volunteer',
        'icon': Icons.volunteer_activism_rounded,
        'colors': [AppColors.success, Colors.green.shade400],
        'screen': VolunteerScreen(),
        'isPremium': false,
      },
      {
        'title': 'Animal Food',
        'icon': Icons.restaurant_rounded,
        'colors': [AppColors.secondary, AppColors.secondaryLight],
        'screen': FoodStoreScreen(),
        'isPremium': false,
      },
      {
        'title': 'Education',
        'icon': Icons.school_rounded,
        'colors': [AppColors.primary, AppColors.primaryLight],
        'screen': EducationScreen(),
        'isPremium': false,
      },
      {
        'title': 'Rewards',
        'icon': Icons.card_giftcard_rounded,
        'colors': [AppColors.warning, Colors.amber.shade400],
        'screen': RewardsScreen(),
        'isPremium': true,
      },
      {
        'title': 'Leaderboard',
        'icon': Icons.leaderboard_rounded,
        'colors': [AppColors.accent, AppColors.accentLight],
        'screen': LeaderboardScreen(),
        'isPremium': true,
      },
    ];
  }

  void _handleFeatureTap(BuildContext context, Map<String, dynamic> feature) {
    final isPremium = feature['isPremium'] == true;
    
    if (isPremium && !user.canEarnPoints) {
      _showPremiumDialog(context);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => feature['screen'] as Widget),
      );
    }
  }

  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: GlassContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.warning, Colors.amber],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.workspace_premium,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Premium Feature',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Upgrade to Premium to unlock this feature and many more!',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Maybe Later'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Premium upgrade coming soon!'),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.warning,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Upgrade'),
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
}
