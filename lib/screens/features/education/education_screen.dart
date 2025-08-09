import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/glass_container.dart';
import '../../../widgets/animated_card.dart';
import '../../../utils/app_colors.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});
  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  String _selectedCategory = 'All';
  
  final List<String> _categories = ['All', 'Care Tips', 'Health', 'Training', 'Emergency'];
  
  final List<Map<String, dynamic>> _educationalContent = [
    {
      'title': 'Basic Pet Care Essentials',
      'category': 'Care Tips',
      'description': 'Learn the fundamental care requirements for different types of pets',
      'content': 'Proper nutrition, regular exercise, grooming, and veterinary care are essential for pet health. Provide fresh water daily, maintain a clean living environment, and establish routines.',
      'tips': [
        'Provide fresh water and quality food daily',
        'Maintain regular feeding schedules',
        'Ensure proper shelter and comfortable bedding',
        'Regular grooming and hygiene maintenance',
        'Schedule routine veterinary checkups',
      ],
      'icon': Icons.pets_rounded,
      'color': [AppColors.primary, AppColors.primaryLight],
      'readTime': '5 min read',
      'difficulty': 'Beginner',
      'url': 'https://www.aspca.org/pet-care/general-pet-care',
    },
    {
      'title': 'Recognizing Pet Health Issues',
      'category': 'Health',
      'description': 'Early signs and symptoms that indicate your pet needs medical attention',
      'content': 'Watch for changes in appetite, behavior, energy levels, and physical appearance. Early detection of health issues can save your pet\'s life.',
      'tips': [
        'Monitor eating and drinking habits',
        'Watch for changes in behavior or energy',
        'Check for unusual lumps or bumps',
        'Observe bathroom habits and frequency',
        'Notice any difficulty breathing or walking',
      ],
      'icon': Icons.health_and_safety_rounded,
      'color': [AppColors.error, Colors.red.shade400],
      'readTime': '7 min read',
      'difficulty': 'Intermediate',
      'url': 'https://www.petmd.com/dog/general-health',
    },
    {
      'title': 'Emergency First Aid for Animals',
      'category': 'Emergency',
      'description': 'Life-saving techniques every pet owner should know',
      'content': 'In emergency situations, quick action can save an animal\'s life. Learn basic first aid techniques and when to seek immediate veterinary care.',
      'tips': [
        'Keep a pet first aid kit ready',
        'Learn CPR techniques for animals',
        'Know how to stop bleeding safely',
        'Understand signs of poisoning',
        'Have emergency vet contacts ready',
      ],
      'icon': Icons.emergency_rounded,
      'color': [AppColors.warning, Colors.amber.shade400],
      'readTime': '10 min read',
      'difficulty': 'Advanced',
      'url': 'https://www.redcross.org/get-help/how-to-prepare-for-emergencies/types-of-emergencies/pet-safety',
    },
    {
      'title': 'Training Your Pet Effectively',
      'category': 'Training',
      'description': 'Positive reinforcement techniques for better behavior',
      'content': 'Consistent, positive training methods help build strong bonds with pets while ensuring good behavior and safety.',
      'tips': [
        'Use positive reinforcement consistently',
        'Start training early and be patient',
        'Keep training sessions short and fun',
        'Reward good behavior immediately',
        'Never use punishment or harsh methods',
      ],
      'icon': Icons.school_rounded,
      'color': [AppColors.success, Colors.green.shade400],
      'readTime': '8 min read',
      'difficulty': 'Intermediate',
      'url': 'https://www.humanesociety.org/resources/dog-training-tips',
    },
    {
      'title': 'Nutrition Guidelines for Pets',
      'category': 'Health',
      'description': 'Understanding proper nutrition for different animals',
      'content': 'Proper nutrition is fundamental to pet health. Different animals have different dietary needs based on age, size, and health conditions.',
      'tips': [
        'Choose age-appropriate food',
        'Avoid toxic foods for pets',
        'Maintain proper portion sizes',
        'Provide species-specific nutrition',
        'Consult vet for special dietary needs',
      ],
      'icon': Icons.restaurant_rounded,
      'color': [AppColors.secondary, AppColors.secondaryLight],
      'readTime': '6 min read',
      'difficulty': 'Beginner',
      'url': 'https://www.petnutritionalliance.org/',
    },
    {
      'title': 'Creating a Safe Environment',
      'category': 'Care Tips',
      'description': 'Pet-proofing your home and surroundings',
      'content': 'A safe environment prevents accidents and injuries. Learn how to identify and eliminate potential hazards in your pet\'s environment.',
      'tips': [
        'Remove toxic plants and substances',
        'Secure dangerous areas and objects',
        'Provide appropriate toys and enrichment',
        'Maintain clean living spaces',
        'Check for escape routes and hazards',
      ],
      'icon': Icons.security_rounded,
      'color': [AppColors.accent, AppColors.accentLight],
      'readTime': '5 min read',
      'difficulty': 'Beginner',
      'url': 'https://www.aspca.org/pet-care/animal-poison-control',
    },
    {
      'title': 'Understanding Animal Behavior',
      'category': 'Training',
      'description': 'Interpreting your pet\'s body language and signals',
      'content': 'Understanding animal behavior helps build better relationships and prevents behavioral problems. Learn to read your pet\'s signals.',
      'tips': [
        'Observe body language and postures',
        'Understand vocalizations and sounds',
        'Recognize stress and anxiety signs',
        'Learn species-specific behaviors',
        'Respond appropriately to different moods',
      ],
      'icon': Icons.psychology_rounded,
      'color': [AppColors.primary, AppColors.primaryLight],
      'readTime': '9 min read',
      'difficulty': 'Intermediate',
      'url': 'https://www.animalbehaviorcollege.com/',
    },
    {
      'title': 'Helping Stray Animals',
      'category': 'Emergency',
      'description': 'Safe approaches to helping animals in need',
      'content': 'When encountering stray or injured animals, it\'s important to approach safely and know when to call for professional help.',
      'tips': [
        'Approach slowly and calmly',
        'Assess the situation for safety',
        'Contact local animal control or rescue',
        'Provide temporary shelter if safe',
        'Document the animal\'s condition and location',
      ],
      'icon': Icons.favorite_rounded,
      'color': [AppColors.error, Colors.red.shade400],
      'readTime': '7 min read',
      'difficulty': 'Intermediate',
      'url': 'https://www.humanesociety.org/resources/helping-stray-cats',
    },
  ];

  List<Map<String, dynamic>> get _filteredContent {
    if (_selectedCategory == 'All') return _educationalContent;
    return _educationalContent.where((content) => content['category'] == _selectedCategory).toList();
  }

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
        title: const Text('Animal Education'),
        backgroundColor: Colors.transparent,
      ),
      body: GradientBackground(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: AnimatedCard(
                child: GlassContainer(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryLight],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.school_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Learn Animal Care',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Essential knowledge for animal welfare',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Category Filter
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;

                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: AnimatedCard(
                      onTap: () => setState(() => _selectedCategory = category),
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
                          category,
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

            // Content List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filteredContent.length,
                itemBuilder: (context, index) {
                  final content = _filteredContent[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: _buildContentCard(content),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard(Map<String, dynamic> content) {
    return AnimatedCard(
      onTap: () => _showContentDetails(content),
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
                      colors: content['color'] as List<Color>,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    content['icon'] as IconData,
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
                        content['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        content['description'],
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
                  content['category'],
                  Icons.category_rounded,
                  AppColors.secondary,
                ),
                _buildInfoTag(
                  content['readTime'],
                  Icons.access_time_rounded,
                  AppColors.primary,
                ),
                _buildInfoTag(
                  content['difficulty'],
                  Icons.signal_cellular_alt_rounded,
                  _getDifficultyColor(content['difficulty']),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showContentDetails(content),
                    icon: const Icon(Icons.menu_book_rounded, size: 18),
                    label: const Text('Read More'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (content['color'] as List<Color>)[0],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => _launchURL(content['url']),
                  icon: const Icon(Icons.open_in_new_rounded, size: 18),
                  label: const Text('Source'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textLight,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
      case 'beginner':
        return AppColors.success;
      case 'intermediate':
        return AppColors.warning;
      case 'advanced':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  void _showContentDetails(Map<String, dynamic> content) {
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
                          colors: content['color'] as List<Color>,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        content['icon'] as IconData,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        content['title'],
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
                  content['content'],
                  style: const TextStyle(fontSize: 16),
                ),
                
                const SizedBox(height: 20),
                
                const Text(
                  'Key Tips:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                ...(content['tips'] as List<String>).map((tip) => 
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: (content['color'] as List<Color>)[0],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            tip,
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
                      child: ElevatedButton.icon(
                        onPressed: () => _launchURL(content['url']),
                        icon: const Icon(Icons.open_in_new_rounded),
                        label: const Text('Learn More'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (content['color'] as List<Color>)[0],
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
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Could not open the link'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }
}
