import 'package:flutter/material.dart';
import '../../../widgets/glass_container.dart';
import '../../../utils/app_colors.dart';
import '../../../models/pet_sitter_model.dart';
import 'widgets/pet_sitter_card.dart';

class PetSittersScreen extends StatefulWidget {
  @override
  _PetSittersScreenState createState() => _PetSittersScreenState();
}

class _PetSittersScreenState extends State<PetSittersScreen> {
  List<PetSitterModel> _allPetSitters = [];
  List<PetSitterModel> _filteredPetSitters = [];
  String _selectedFilter = 'All';
  bool _isLoading = true;

  final List<String> _filters = ['All', 'Available', 'Top Rated', 'Nearby'];

  @override
  void initState() {
    super.initState();
    _loadPetSitters();
  }

  void _loadPetSitters() {
    // Mock data - replace with API call
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _allPetSitters = _getMockPetSitters();
        _filteredPetSitters = _allPetSitters;
        _isLoading = false;
      });
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
              _buildFilterTabs(),
              Expanded(
                child: _isLoading ? _buildLoadingState() : _buildPetSittersList(),
              ),
            ],
          ),
        ),
      ),
    );
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
                  'Pet Sitters',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  'Find trusted pet sitters near you',
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
              Icons.person_search,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          
          return Container(
            margin: EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                  _applyFilter();
                });
              },
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }

  Widget _buildPetSittersList() {
    if (_filteredPetSitters.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_search,
              size: 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'No pet sitters found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: _filteredPetSitters.length,
      itemBuilder: (context, index) {
        return PetSitterCard(petSitter: _filteredPetSitters[index]);
      },
    );
  }

  void _applyFilter() {
    switch (_selectedFilter) {
      case 'Available':
        _filteredPetSitters = _allPetSitters.where((sitter) => sitter.isAvailable).toList();
        break;
      case 'Top Rated':
        _filteredPetSitters = _allPetSitters.where((sitter) => sitter.rating >= 4.5).toList();
        break;
      case 'Nearby':
        // TODO: Implement location-based filtering
        _filteredPetSitters = _allPetSitters;
        break;
      default:
        _filteredPetSitters = _allPetSitters;
    }
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
      PetSitterModel(
        id: '3',
        name: 'Fatima Rahman',
        email: 'fatima@example.com',
        phone: '+880777888999',
        imageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400',
        rating: 4.9,
        reviewCount: 67,
        bio: 'Veterinary student with passion for animal care. Specializes in medical needs pets.',
        services: ['Pet Sitting', 'Medical Care', 'Emergency Care'],
        petTypes: ['Dogs', 'Cats', 'Rabbits'],
        pricePerDay: 1500.0,
        latitude: 23.7808,
        longitude: 90.2792,
        address: 'Uttara, Dhaka',
        isAvailable: false,
        experienceYears: 4,
        certifications: ['Veterinary Assistant', 'Pet First Aid'],
        joinedDate: DateTime.now().subtract(Duration(days: 500)),
      ),
      PetSitterModel(
        id: '4',
        name: 'Rashid Hassan',
        email: 'rashid@example.com',
        phone: '+880555666777',
        imageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
        rating: 4.4,
        reviewCount: 28,
        bio: 'Dog trainer and pet behaviorist. Great with training and behavioral issues.',
        services: ['Pet Training', 'Dog Walking', 'Behavioral Consultation'],
        petTypes: ['Dogs'],
        pricePerDay: 800.0,
        latitude: 23.7286,
        longitude: 90.3854,
        address: 'Wari, Dhaka',
        isAvailable: true,
        experienceYears: 2,
        certifications: ['Dog Training Certificate'],
        joinedDate: DateTime.now().subtract(Duration(days: 150)),
      ),
    ];
  }
}
