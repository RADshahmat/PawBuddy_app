import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/simple_card.dart';
import '../../widgets/animated_card.dart';
import '../../utils/app_colors.dart';
import '../../models/user_model.dart';
import '../../services/posts_service.dart';
import '../../models/sell_post_model.dart';
import '../../models/pet_sitting_post_model.dart';
import '../../models/pet_sitter_profile_model.dart';
import '../../models/report_model.dart';

class MyPostsScreen extends StatefulWidget {
  const MyPostsScreen({super.key});

  @override
  State<MyPostsScreen> createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends State<MyPostsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PostsService _postsService = PostsService();
  
  bool _isLoading = false;
  List<SellPostModel> _sellPosts = [];
  List<PetSittingPostModel> _petSittingPosts = [];
  List<PetSitterProfileModel> _petSitterProfiles = [];
  List<ReportModel> _reportPosts = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadAllPosts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAllPosts() async {
    setState(() => _isLoading = true);
    
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    if (user != null) {
      try {
        // Load demo data for now
        _sellPosts = await _postsService.getMySellPosts(user.id);
        _petSittingPosts = await _postsService.getMyPetSittingPosts(user.id);
        _petSitterProfiles = await _postsService.getMyPetSitterProfiles(user.id);
        _reportPosts = await _postsService.getMyReportPosts(user.id);
      } catch (e) {
        print('Error loading posts: $e');
      }
    }
    
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Posts'),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(
              icon: Icon(Icons.sell, size: 20),
              text: 'Sell Posts',
            ),
            Tab(
              icon: Icon(Icons.pets, size: 20),
              text: 'Pet Sitting',
            ),
            Tab(
              icon: Icon(Icons.person, size: 20),
              text: 'Pet Sitter',
            ),
            Tab(
              icon: Icon(Icons.report, size: 20),
              text: 'Reports',
            ),
          ],
        ),
      ),
      body: GradientBackground(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildSellPostsTab(),
                  _buildPetSittingPostsTab(),
                  _buildPetSitterProfilesTab(),
                  _buildReportPostsTab(),
                ],
              ),
      ),
    );
  }

  Widget _buildSellPostsTab() {
    if (_sellPosts.isEmpty) {
      return _buildEmptyState(
        icon: Icons.sell,
        title: 'No Sell Posts',
        subtitle: 'You haven\'t created any sell posts yet.',
        buttonText: 'Create Sell Post',
        onPressed: () {
          // Navigate to create sell post screen
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _sellPosts.length,
      itemBuilder: (context, index) {
        final post = _sellPosts[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildSellPostCard(post),
        );
      },
    );
  }

  Widget _buildPetSittingPostsTab() {
    if (_petSittingPosts.isEmpty) {
      return _buildEmptyState(
        icon: Icons.pets,
        title: 'No Pet Sitting Posts',
        subtitle: 'You haven\'t created any pet sitting posts yet.',
        buttonText: 'Create Pet Sitting Post',
        onPressed: () {
          // Navigate to create pet sitting post screen
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _petSittingPosts.length,
      itemBuilder: (context, index) {
        final post = _petSittingPosts[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildPetSittingPostCard(post),
        );
      },
    );
  }

  Widget _buildPetSitterProfilesTab() {
    if (_petSitterProfiles.isEmpty) {
      return _buildEmptyState(
        icon: Icons.person,
        title: 'No Pet Sitter Profile',
        subtitle: 'You haven\'t created a pet sitter profile yet.',
        buttonText: 'Create Pet Sitter Profile',
        onPressed: () {
          // Navigate to create pet sitter profile screen
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _petSitterProfiles.length,
      itemBuilder: (context, index) {
        final profile = _petSitterProfiles[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildPetSitterProfileCard(profile),
        );
      },
    );
  }

  Widget _buildReportPostsTab() {
    if (_reportPosts.isEmpty) {
      return _buildEmptyState(
        icon: Icons.report,
        title: 'No Report Posts',
        subtitle: 'You haven\'t created any report posts yet.',
        buttonText: 'Create Report Post',
        onPressed: () {
          // Navigate to create report post screen
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _reportPosts.length,
      itemBuilder: (context, index) {
        final post = _reportPosts[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildReportPostCard(post),
        );
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Center(
      child: SimpleCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.add_rounded),
              label: Text(buttonText),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSellPostCard(SellPostModel post) {
    return AnimatedCard(
      child: SimpleCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    post.imageUrls.isNotEmpty ? post.imageUrls.first : '',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.sell,
                          color: AppColors.primary,
                          size: 30,
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
                        post.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '৳${post.price}',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(post.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildActionButtons(
                  onEdit: () => _editSellPost(post),
                  onDelete: () => _deleteSellPost(post.id),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              post.description,
              style: const TextStyle(fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetSittingPostCard(PetSittingPostModel post) {
    return AnimatedCard(
      child: SimpleCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    post.petImageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.pets,
                          color: AppColors.primary,
                          size: 30,
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
                        '${post.petName} - ${post.petType}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '৳${post.pricePerDay}/day',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(post.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildActionButtons(
                  onEdit: () => _editPetSittingPost(post),
                  onDelete: () => _deletePetSittingPost(post.id),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              post.description,
              style: const TextStyle(fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetSitterProfileCard(PetSitterProfileModel profile) {
    return AnimatedCard(
      child: SimpleCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    profile.profileImageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.person,
                          color: AppColors.primary,
                          size: 30,
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
                        profile.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${profile.rating} (${profile.reviewCount} reviews)',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '৳${profile.pricePerDay}/day',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildActionButtons(
                  onEdit: () => _editPetSitterProfile(profile),
                  onDelete: () => _deletePetSitterProfile(profile.id),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              profile.bio,
              style: const TextStyle(fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportPostCard(ReportModel post) {
    return AnimatedCard(
      child: SimpleCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    post.imageUrls.isNotEmpty ? post.imageUrls.first : '',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.report,
                          color: AppColors.primary,
                          size: 30,
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
                        '${post.animalType} - ${post.condition}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              post.locationAddress,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(post.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          post.statusDisplayName,
                          style: TextStyle(
                            color: _getStatusColor(post.status),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildActionButtons(
                  onEdit: () => _editReportPost(post),
                  onDelete: () => _deleteReportPost(post.id),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              post.description,
              style: const TextStyle(fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons({
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onEdit,
          icon: Icon(
            Icons.edit,
            color: AppColors.primary,
            size: 20,
          ),
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: onDelete,
          icon: Icon(
            Icons.delete,
            color: AppColors.error,
            size: 20,
          ),
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return AppColors.warning;
      case 'in_progress':
        return AppColors.secondary;
      case 'completed':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }

  // Edit functions
  void _editSellPost(SellPostModel post) {
    // Navigate to edit sell post screen
    print('Edit sell post: ${post.id}');
  }

  void _editPetSittingPost(PetSittingPostModel post) {
    // Navigate to edit pet sitting post screen
    print('Edit pet sitting post: ${post.id}');
  }

  void _editPetSitterProfile(PetSitterProfileModel profile) {
    // Navigate to edit pet sitter profile screen
    print('Edit pet sitter profile: ${profile.id}');
  }

  void _editReportPost(ReportModel post) {
    // Navigate to edit report post screen
    print('Edit report post: ${post.id}');
  }

  // Delete functions
  void _deleteSellPost(String postId) {
    _showDeleteConfirmation('sell post', () async {
      try {
        await _postsService.deleteSellPost(postId);
        _loadAllPosts();
        _showMessage('Sell post deleted successfully');
      } catch (e) {
        _showMessage('Failed to delete sell post', isError: true);
      }
    });
  }

  void _deletePetSittingPost(String postId) {
    _showDeleteConfirmation('pet sitting post', () async {
      try {
        await _postsService.deletePetSittingPost(postId);
        _loadAllPosts();
        _showMessage('Pet sitting post deleted successfully');
      } catch (e) {
        _showMessage('Failed to delete pet sitting post', isError: true);
      }
    });
  }

  void _deletePetSitterProfile(String profileId) {
    _showDeleteConfirmation('pet sitter profile', () async {
      try {
        await _postsService.deletePetSitterProfile(profileId);
        _loadAllPosts();
        _showMessage('Pet sitter profile deleted successfully');
      } catch (e) {
        _showMessage('Failed to delete pet sitter profile', isError: true);
      }
    });
  }

  void _deleteReportPost(String postId) {
    _showDeleteConfirmation('report post', () async {
      try {
        await _postsService.deleteReportPost(postId);
        _loadAllPosts();
        _showMessage('Report post deleted successfully');
      } catch (e) {
        _showMessage('Failed to delete report post', isError: true);
      }
    });
  }

  void _showDeleteConfirmation(String itemType, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete $itemType'),
        content: Text('Are you sure you want to delete this $itemType? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showMessage(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? AppColors.error : AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
