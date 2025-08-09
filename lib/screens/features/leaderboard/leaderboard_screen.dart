import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/glass_container.dart';
import '../../../widgets/animated_card.dart';
import '../../../utils/app_colors.dart';
import '../../../models/user_model.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});
  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  String _selectedPeriod = 'All Time';
  final List<String> _periods = ['All Time', 'This Month', 'This Week'];

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
    return Consumer2<AuthProvider, UserProvider>(
      builder: (context, authProvider, userProvider, child) {
        final currentUser = authProvider.currentUser!;
        
        // Show premium dialog for normal users
        if (!currentUser.canViewLeaderboard) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(context);
            _showPremiumDialog();
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        // Create leaderboard with current user
        final leaderboard = List<UserModel>.from(userProvider.leaderboard);
        
        // Add current user if not already in leaderboard
        if (!leaderboard.any((user) => user.id == currentUser.id)) {
          leaderboard.add(currentUser);
        } else {
          // Update current user's points in leaderboard
          final index = leaderboard.indexWhere((user) => user.id == currentUser.id);
          if (index != -1) {
            leaderboard[index] = currentUser;
          }
        }
        
        // Sort by points
        leaderboard.sort((a, b) => b.points.compareTo(a.points));
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('Leaderboard'),
            backgroundColor: Colors.transparent,
          ),
          body: GradientBackground(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Period Filter
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _periods.length,
                    itemBuilder: (context, index) {
                      final period = _periods[index];
                      final isSelected = _selectedPeriod == period;

                      return Container(
                        margin: const EdgeInsets.only(right: 12),
                        child: AnimatedCard(
                          onTap: () => setState(() => _selectedPeriod = period),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(
                                      colors: [AppColors.primary, AppColors.primaryLight],
                                    )
                                  : null,
                              color: isSelected ? null : Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: isSelected ? Colors.transparent : AppColors.glassBorder,
                              ),
                            ),
                            child: Text(
                              period,
                              style: TextStyle(
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),


                // Full Leaderboard
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: leaderboard.length,
                    itemBuilder: (context, index) {
                      final user = leaderboard[index];
                      final isCurrentUser = user.id == currentUser.id;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: _buildLeaderboardItem(user, index + 1, isCurrentUser),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _buildLeaderboardItem(UserModel user, int position, bool isCurrentUser) {
    return AnimatedCard(
      child: GlassContainer(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: isCurrentUser
                ? LinearGradient(
                    colors: [
                      AppColors.accent.withOpacity(0.2),
                      AppColors.accent.withOpacity(0.1),
                    ],
                  )
                : null,
            borderRadius: BorderRadius.circular(20),
            border: isCurrentUser
                ? Border.all(color: AppColors.accent.withOpacity(0.5), width: 2)
                : null,
          ),
          child: Row(
            children: [
              // Position
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _getPositionColors(position),
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$position',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // User Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          user.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isCurrentUser ? AppColors.accent : AppColors.textSecondary,
                          ),
                        ),
                        if (isCurrentUser) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'You',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getUserTypeColor(user.userType).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            user.userTypeString,
                            style: TextStyle(
                              color: _getUserTypeColor(user.userType),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Points
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${user.points}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const Text(
                    'points',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
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

  List<Color> _getPodiumColors(int position) {
    switch (position) {
      case 1:
        return [AppColors.warning, Colors.amber.shade400]; // Gold
      case 2:
        return [AppColors.textLight, Colors.grey.shade400]; // Silver
      case 3:
        return [Colors.brown, Colors.brown.shade400]; // Bronze
      default:
        return [AppColors.primary, AppColors.primaryLight];
    }
  }

  double _getPodiumHeight(int position) {
    switch (position) {
      case 1:
        return 60.0;
      case 2:
        return 45.0;
      case 3:
        return 30.0;
      default:
        return 20.0;
    }
  }

  List<Color> _getPositionColors(int position) {
    if (position <= 3) {
      return _getPodiumColors(position);
    } else if (position <= 10) {
      return [AppColors.primary, AppColors.primaryLight];
    } else {
      return [AppColors.textLight, AppColors.textSecondary];
    }
  }

  Color _getUserTypeColor(UserType userType) {
    switch (userType) {
      case UserType.premium:
        return AppColors.warning;
      case UserType.rescueTeam:
        return AppColors.error;
      case UserType.normal:
      default:
        return AppColors.textSecondary;
    }
  }

  void _showPremiumDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.warning, Colors.amber.shade400],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  size: 40,
                  color: Colors.white,
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
                'Leaderboard is available for Premium users only. Upgrade to Premium to see how you rank against other contributors!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
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
                            content: Text('Premium upgrade feature coming soon!'),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.warning,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Upgrade Now'),
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
