import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/glass_container.dart';
import '../../../widgets/animated_card.dart';
import '../../../utils/app_colors.dart';
import '../../../models/user_model.dart';

class RewardsScreen extends StatefulWidget {
  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  final List<Map<String, dynamic>> _rewards = [
    {
      'id': '1',
      'title': 'Pet Food Voucher',
      'description': '৳500 voucher for premium pet food',
      'points': 1000,
      'category': 'Food',
      'icon': Icons.restaurant_rounded,
      'color': [AppColors.secondary, AppColors.secondaryLight],
      'available': true,
      'validUntil': '31 Dec 2024',
      'terms': [
        'Valid at participating pet stores',
        'Cannot be combined with other offers',
        'Non-transferable and non-refundable',
        'Valid for 30 days from redemption',
      ],
    },
    {
      'id': '2',
      'title': 'Veterinary Checkup',
      'description': 'Free basic health checkup for your pet',
      'points': 1500,
      'category': 'Healthcare',
      'icon': Icons.medical_services_rounded,
      'color': [AppColors.error, Colors.red.shade400],
      'available': true,
      'validUntil': '30 Nov 2024',
      'terms': [
        'Valid at partner veterinary clinics',
        'Includes basic examination only',
        'Additional treatments charged separately',
        'Appointment required in advance',
      ],
    },
    {
      'id': '3',
      'title': 'Pet Grooming Session',
      'description': 'Professional grooming service for dogs/cats',
      'points': 800,
      'category': 'Grooming',
      'icon': Icons.pets_rounded,
      'color': [AppColors.accent, AppColors.accentLight],
      'available': true,
      'validUntil': '15 Jan 2025',
      'terms': [
        'Valid at selected grooming centers',
        'Includes bath, nail trim, and basic styling',
        'Large dogs may require additional charges',
        'Booking required 24 hours in advance',
      ],
    },
    {
      'id': '4',
      'title': 'Animal Rescue Donation',
      'description': '৳1000 donation to local animal shelter',
      'points': 2000,
      'category': 'Charity',
      'icon': Icons.favorite_rounded,
      'color': [AppColors.success, Colors.green.shade400],
      'available': true,
      'validUntil': 'No expiry',
      'terms': [
        'Donation made on your behalf',
        'Tax receipt provided if requested',
        'Funds used for animal care and shelter maintenance',
        'Donation acknowledgment sent via email',
      ],
    },
    {
      'id': '5',
      'title': 'Premium App Features',
      'description': '3 months of premium app features',
      'points': 1200,
      'category': 'Digital',
      'icon': Icons.star_rounded,
      'color': [AppColors.warning, Colors.amber.shade400],
      'available': false,
      'validUntil': '31 Mar 2025',
      'terms': [
        'Includes unlimited photo uploads',
        'Priority support and notifications',
        'Advanced reporting features',
        'Auto-renewal can be disabled anytime',
      ],
    },
    {
      'id': '6',
      'title': 'Pet Training Session',
      'description': 'One-on-one training session with expert',
      'points': 1800,
      'category': 'Training',
      'icon': Icons.school_rounded,
      'color': [AppColors.primary, AppColors.primaryLight],
      'available': true,
      'validUntil': '28 Feb 2025',
      'terms': [
        'Valid for dogs and cats only',
        '1-hour session with certified trainer',
        'Basic obedience and behavior training',
        'Follow-up consultation included',
      ],
    },
  ];

  final List<Map<String, dynamic>> _pointsActivities = [
    {
      'activity': 'Report Stray Animal',
      'points': 50,
      'icon': Icons.pets_rounded,
      'color': AppColors.primary,
    },
    {
      'activity': 'Join Volunteer Program',
      'points': 200,
      'icon': Icons.volunteer_activism_rounded,
      'color': AppColors.success,
    },
    {
      'activity': 'Help Animal Rescue',
      'points': 150,
      'icon': Icons.local_hospital_rounded,
      'color': AppColors.error,
    },
    {
      'activity': 'Share Educational Content',
      'points': 25,
      'icon': Icons.share_rounded,
      'color': AppColors.secondary,
    },
    {
      'activity': 'Complete Profile',
      'points': 100,
      'icon': Icons.person_rounded,
      'color': AppColors.accent,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
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
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser!;
        
        // Show premium dialog for normal users
        if (!user.canEarnPoints) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(context);
            _showPremiumDialog();
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('Rewards & Points'),
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
                    // Points Display Card
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: AnimatedCard(
                        child: GlassContainer(
                          child: Column(
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
                                  Icons.stars_rounded,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '${user.points}',
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              const Text(
                                'Total Reward Points',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              LinearProgressIndicator(
                                value: (user.points % 1000) / 1000,
                                backgroundColor: AppColors.textLight.withOpacity(0.3),
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.warning),
                                borderRadius: BorderRadius.circular(8),
                                minHeight: 8,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${1000 - (user.points % 1000)} points to next milestone',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // How to Earn Points
                    const Text(
                      'How to Earn Points',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    ...List.generate(_pointsActivities.length, (index) {
                      final activity = _pointsActivities[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: AnimatedCard(
                          child: GlassContainer(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: (activity['color'] as Color).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    activity['icon'] as IconData,
                                    color: activity['color'] as Color,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    activity['activity'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [AppColors.success, Colors.green.shade400],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '+${activity['points']} pts',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    
                    const SizedBox(height: 32),
                    
                    // Available Rewards
                    const Text(
                      'Available Rewards',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    ...List.generate(_rewards.length, (index) {
                      final reward = _rewards[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: _buildRewardCard(reward, user),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRewardCard(Map<String, dynamic> reward, UserModel user) {
    final canAfford = user.points >= reward['points'];
    final isAvailable = reward['available'] as bool;
    final canRedeem = canAfford && isAvailable;
    
    return AnimatedCard(
      onTap: () => _showRewardDetails(reward, user),
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
                      colors: reward['color'] as List<Color>,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    reward['icon'] as IconData,
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
                        reward['title'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isAvailable ? null : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        reward['description'],
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
                if (!isAvailable)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.textLight.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Unavailable',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Points and Category
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: canAfford 
                          ? [AppColors.success, Colors.green.shade400]
                          : [AppColors.textLight, AppColors.textSecondary],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${reward['points']} points',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: (reward['color'] as List<Color>)[0].withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    reward['category'],
                    style: TextStyle(
                      color: (reward['color'] as List<Color>)[0],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Valid until ${reward['validUntil']}',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canRedeem ? () => _redeemReward(reward, user) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canRedeem 
                      ? (reward['color'] as List<Color>)[0]
                      : AppColors.textLight,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  canRedeem 
                      ? 'Redeem Now'
                      : !canAfford 
                          ? 'Need ${reward['points'] - user.points} more points'
                          : 'Currently Unavailable',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRewardDetails(Map<String, dynamic> reward, UserModel user) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
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
                          colors: reward['color'] as List<Color>,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        reward['icon'] as IconData,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        reward['title'],
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
                  reward['description'],
                  style: const TextStyle(fontSize: 16),
                ),
                
                const SizedBox(height: 20),
                
                Row(
                  children: [
                    const Text(
                      'Required Points: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${reward['points']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: user.points >= reward['points'] 
                            ? AppColors.success 
                            : AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                Row(
                  children: [
                    const Text(
                      'Your Points: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${user.points}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                const Text(
                  'Terms & Conditions:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                ...(reward['terms'] as List<String>).map((term) => 
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: (reward['color'] as List<Color>)[0],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            term,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: (user.points >= reward['points'] && reward['available']) 
                            ? () {
                                Navigator.pop(context);
                                _redeemReward(reward, user);
                              } 
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (reward['color'] as List<Color>)[0],
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Redeem'),
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
      ),
    );
  }

  void _redeemReward(Map<String, dynamic> reward, UserModel user) {
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
                    colors: [AppColors.success, Colors.green.shade400],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Reward Redeemed!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'You have successfully redeemed "${reward['title']}"',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Redemption Code',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'AR${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Save this code for redemption',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Deduct points
                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                  authProvider.addPoints(-(reward['points'] as int));
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${reward['points']} points deducted from your account'),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
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
                'Rewards and points system is available for Premium users only. Upgrade to Premium to unlock this feature and start earning points!',
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
