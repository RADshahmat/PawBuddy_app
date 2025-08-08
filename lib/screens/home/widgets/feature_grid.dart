import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/user_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/animated_card.dart';
import '../../../widgets/premium_feature_card.dart';
import '../../../utils/app_colors.dart';
import '../../features/vet_directory/vet_directory_screen.dart';
import '../../features/volunteer/volunteer_screen.dart';
import '../../features/food_store/food_store_screen.dart';
import '../../features/education/education_screen.dart';
import '../../features/rewards/rewards_screen.dart';
import '../../features/vetbot/vetbot_screen.dart';
import '../../features/leaderboard/leaderboard_screen.dart';
import '../../features/pet_sitting/pet_sitting_screen.dart';
import '../../features/report/report_screen.dart';

class FeatureGrid extends StatelessWidget {
  final UserModel user;

  const FeatureGrid({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final isPremium = authProvider.currentUser?.userType == UserType.premium ||
            authProvider.currentUser?.userType == UserType.rescueTeam;

        final features = [
          {
            'title': 'Sell Pet',
            'icon': Icons.sell_rounded,
            'color': const Color(0xFFEF8644), // Red
            'isPremium': false,
            'screen': const ReportScreen("sell"),
          },
          {
            'title': 'Volunteer',
            'icon': Icons.volunteer_activism_rounded,
            'color': const Color(0xFF10B981), // Emerald
            'isPremium': false,
            'screen': const VolunteerScreen(),
          },
          {
            'title': 'Vet Directory',
            'icon': Icons.local_hospital_rounded,
            'color': const Color(0xFF6366F1), // Indigo
            'isPremium': false,
            'screen': const VetDirectoryScreen(),
          },
          {
            'title': 'Animal Food',
            'icon': Icons.pets_rounded,
            'color': const Color(0xFF059669), // Green
            'isPremium': true,
            'screen':  FoodStoreScreen(),
          },

          {
            'title': 'Education',
            'icon': Icons.school_rounded,
            'color': const Color(0xFF9885C3), // Violet
            'isPremium': true,
            'screen': const EducationScreen(),
          },

          {
            'title': 'Pet Shelter',
            'icon': Icons.night_shelter_rounded,
            'color': const Color(0xFFEC4899), // Pink
            'isPremium': true,
            'screen':  PetSittingScreen(),
          },
          {
            'title': 'VetBot',
            'icon': Icons.chat_rounded,
            'color': const Color(0xFF06B6D4), // Cyan
            'isPremium': true,
            'screen': const VetBotScreen(),
          },
          {
            'title': 'Rewards',
            'icon': Icons.card_giftcard_rounded,
            'color': const Color(0xFFF59E0B), // Amber
            'isPremium': true,
            'screen':  RewardsScreen(),
          },
          {
            'title': 'Leaderboard',
            'icon': Icons.leaderboard_rounded,
            'color': AppColors.secondaryDark,
            'isPremium': true,
            'screen': const LeaderboardScreen(),
          },
        ];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.85,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: features.length,
            itemBuilder: (context, index) {
              final feature = features[index];
              final isLocked = feature['isPremium'] as bool && !isPremium;

              return AnimatedCard(
                onTap: () {
                  if (isLocked) {
                    PremiumFeatureCard.showPremiumDialog(context);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => feature['screen'] as Widget,
                      ),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        (feature['color'] as Color),
                        (feature['color'] as Color).withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: (feature['color'] as Color).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              feature['icon'] as IconData,
                              size: 32,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              feature['title'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      if (isLocked)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.warning,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.lock,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
