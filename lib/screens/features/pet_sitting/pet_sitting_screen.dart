import 'package:flutter/material.dart';
import '../../../widgets/glass_container.dart';
import '../../../widgets/animated_card.dart';
import '../../../utils/app_colors.dart';
import '../../../models/pet_model.dart';
import '../../../models/pet_sitter_model.dart';
import 'widgets/pet_post_card.dart';
import 'widgets/pet_sitter_card.dart';
import 'add_pet_post_screen.dart';
import 'pet_sitters_screen.dart';
import 'join_as_pet_sitter_screen.dart';

class PetSittingScreen extends StatefulWidget {
  @override
  _PetSittingScreenState createState() => _PetSittingScreenState();
}

class _PetSittingScreenState extends State<PetSittingScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  List<PetModel> _petPosts = [];
  List<PetSitterModel> _nearbyPetSitters = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    setState(() {
      // Force rebuild to show/hide FAB based on current tab
    });
  }

  void _loadData() {
    // Mock data - replace with API calls
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _petPosts = _getMockPetPosts();
          _nearbyPetSitters = _getMockPetSitters();
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPetPostsTab(),
                    _buildPetSittersTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    if (_tabController.index == 0) {
      // Pet Posts tab - Show Add Pet Post button
      return FloatingActionButton.extended(
        onPressed: () => _navigateToAddPetPost(),
        backgroundColor: AppColors.primary,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text('Add Pet Post', style: TextStyle(color: Colors.white)),
        heroTag: "addPetPost",
      );
    } else {
      // Pet Sitters tab - Show Join as Pet Sitter button
      return FloatingActionButton.extended(
        onPressed: () => _navigateToJoinAsPetSitter(),
        backgroundColor: AppColors.secondary,
        icon: Icon(Icons.person_add, color: Colors.white),
        label: Text('Join as Sitter', style: TextStyle(color: Colors.white)),
        heroTag: "joinAsSitter",
      );
    }
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pet Sitting',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  'Find care for your pets',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.pets,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: TextStyle(fontWeight: FontWeight.w600),
        tabs: [
          Tab(text: 'Pet Posts'),
          Tab(text: 'Pet Sitters'),
        ],
      ),
    );
  }

  Widget _buildPetPostsTab() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Pet Posts',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all pet posts
                },
                child: Text('View All'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: _petPosts.length,
            itemBuilder: (context, index) {
              return PetPostCard(pet: _petPosts[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPetSittersTab() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nearby Pet Sitters',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PetSittersScreen()),
                ),
                child: Text('View All'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: _nearbyPetSitters.length,
            itemBuilder: (context, index) {
              return PetSitterCard(petSitter: _nearbyPetSitters[index]);
            },
          ),
        ),
      ],
    );
  }

  void _navigateToAddPetPost() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddPetPostScreen()),
    ).then((_) {
      if (mounted) {
        _loadData();
      }
    });
  }

  void _navigateToJoinAsPetSitter() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => JoinAsPetSitterScreen()),
    ).then((_) {
      if (mounted) {
        _loadData();
      }
    });
  }

  List<PetModel> _getMockPetPosts() {
    return [
      PetModel(
        id: '1',
        name: 'Buddy',
        type: 'Dog',
        breed: 'Golden Retriever',
        age: 3,
        description: 'Friendly and energetic dog looking for a caring sitter while I\'m away for work.',
        imageUrl: 'https://images.unsplash.com/photo-1552053831-71594a27632d?w=400',
        ownerId: 'owner1',
        ownerName: 'Sarah Johnson',
        ownerPhone: '+880123456789',
        latitude: 23.8103,
        longitude: 90.4125,
        address: 'Dhanmondi, Dhaka',
        createdAt: DateTime.now().subtract(Duration(hours: 2)),
        isAvailable: true,
        requirements: ['Daily walks', 'Feeding twice a day', 'Playtime'],
        pricePerDay: 1500.0,
      ),
      PetModel(
        id: '2',
        name: 'Whiskers',
        type: 'Cat',
        breed: 'Persian',
        age: 2,
        description: 'Calm and loving cat needs someone to look after while I travel.',
        imageUrl: 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=400',
        ownerId: 'owner2',
        ownerName: 'Ahmed Rahman',
        ownerPhone: '+880987654321',
        latitude: 23.7461,
        longitude: 90.3742,
        address: 'Gulshan, Dhaka',
        createdAt: DateTime.now().subtract(Duration(hours: 5)),
        isAvailable: true,
        requirements: ['Litter box cleaning', 'Regular feeding', 'Gentle brushing'],
        pricePerDay: 1200.0,
      ),
    ];
  }

  List<PetSitterModel> _getMockPetSitters() {
    return [
      PetSitterModel(
        id: '1',
        name: 'Maria Khan',
        email: 'maria@example.com',
        phone: '+880111222333',
        imageUrl: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400',
        rating: 4.8,
        reviewCount: 45,
        bio: 'Experienced pet sitter with 5+ years of caring for dogs and cats. I love animals and treat them like family.',
        services: ['Pet Sitting', 'Dog Walking', 'Pet Grooming'],
        petTypes: ['Dogs', 'Cats'],
        pricePerDay: 1000.0,
        latitude: 23.8103,
        longitude: 90.4125,
        address: 'Dhanmondi, Dhaka',
        isAvailable: true,
        experienceYears: 5,
        certifications: ['Pet First Aid', 'Animal Behavior'],
        joinedDate: DateTime.now().subtract(Duration(days: 365)),
      ),
      PetSitterModel(
        id: '2',
        name: 'Karim Ahmed',
        email: 'karim@example.com',
        phone: '+880444555666',
        imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
        rating: 4.6,
        reviewCount: 32,
        bio: 'Professional pet care specialist. Available for overnight stays and daily visits.',
        services: ['Pet Sitting', 'Overnight Care', 'Pet Training'],
        petTypes: ['Dogs', 'Cats', 'Birds'],
        pricePerDay: 1200.0,
        latitude: 23.7461,
        longitude: 90.3742,
        address: 'Gulshan, Dhaka',
        isAvailable: true,
        experienceYears: 3,
        certifications: ['Pet Care Certificate'],
        joinedDate: DateTime.now().subtract(Duration(days: 200)),
      ),
    ];
  }
}
