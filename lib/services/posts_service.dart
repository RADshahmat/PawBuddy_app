import '../models/sell_post_model.dart';
import '../models/pet_sitting_post_model.dart';
import '../models/pet_sitter_profile_model.dart';
import '../models/report_model.dart';

class PostsService {
  // API endpoints - replace with actual backend URLs
  static const String _baseUrl = 'https://api.pawbuddy.com';
  static const String _sellPostsEndpoint = '$_baseUrl/sell-posts';
  static const String _petSittingPostsEndpoint = '$_baseUrl/pet-sitting-posts';
  static const String _petSitterProfilesEndpoint = '$_baseUrl/pet-sitter-profiles';
  static const String _reportPostsEndpoint = '$_baseUrl/report-posts';

  // Demo data for testing
  Future<List<SellPostModel>> getMySellPosts(String userId) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Return demo data
    return [
      SellPostModel(
        id: '1',
        userId: userId,
        title: 'Premium Dog Food - Royal Canin',
        description: 'High quality dog food, barely used. Perfect for medium sized dogs.',
        price: 2500.0,
        category: 'Pet Food',
        imageUrls: ['/placeholder.svg?height=200&width=200&text=Dog+Food'],
        location: 'Dhanmondi, Dhaka',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        isAvailable: true,
      ),
      SellPostModel(
        id: '2',
        userId: userId,
        title: 'Cat Carrier Bag',
        description: 'Comfortable and secure carrier bag for cats. Used only twice.',
        price: 1200.0,
        category: 'Pet Accessories',
        imageUrls: ['/placeholder.svg?height=200&width=200&text=Cat+Carrier'],
        location: 'Gulshan, Dhaka',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        isAvailable: true,
      ),
    ];
  }

  Future<List<PetSittingPostModel>> getMyPetSittingPosts(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      PetSittingPostModel(
        id: '1',
        userId: userId,
        petName: 'Buddy',
        petType: 'Dog',
        petBreed: 'Golden Retriever',
        petAge: 3,
        description: 'Friendly and well-trained dog. Needs daily walks and feeding twice a day.',
        petImageUrl: '/placeholder.svg?height=200&width=200&text=Golden+Retriever',
        pricePerDay: 500.0,
        startDate: DateTime.now().add(const Duration(days: 7)),
        endDate: DateTime.now().add(const Duration(days: 14)),
        requirements: ['Daily walks', 'Feeding twice a day', 'Medication at 8 PM'],
        location: 'Dhanmondi, Dhaka',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isActive: true,
      ),
    ];
  }

  Future<List<PetSitterProfileModel>> getMyPetSitterProfiles(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      PetSitterProfileModel(
        id: '1',
        userId: userId,
        name: 'John Doe',
        bio: 'Experienced pet sitter with 5+ years of experience. Love taking care of all types of pets.',
        profileImageUrl: '/placeholder.svg?height=200&width=200&text=Pet+Sitter',
        rating: 4.8,
        reviewCount: 24,
        pricePerDay: 800.0,
        services: ['Pet Sitting', 'Dog Walking', 'Pet Grooming'],
        petTypes: ['Dogs', 'Cats', 'Birds'],
        experienceYears: 5,
        location: 'Gulshan, Dhaka',
        isAvailable: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
    ];
  }

  Future<List<ReportModel>> getMyReportPosts(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      ReportModel(
        id: '1',
        userId: userId,
        animalType: 'Dog',
        condition: 'Injured',
        description: 'Found injured dog near Dhanmondi lake, needs immediate medical attention',
        latitude: 23.7461,
        longitude: 90.3742,
        locationAddress: 'Dhanmondi Lake, Dhaka',
        imageUrls: ['/placeholder.svg?height=200&width=200&text=Injured+Dog'],
        reportedAt: DateTime.now().subtract(const Duration(hours: 2)),
        status: 'in_progress',
        assignedRescueTeamId: '1',
      ),
      ReportModel(
        id: '2',
        userId: userId,
        animalType: 'Cat',
        condition: 'Healthy but stray',
        description: 'Stray cat family with kittens, looking for shelter',
        latitude: 23.8103,
        longitude: 90.4125,
        locationAddress: 'Gulshan Circle 1, Dhaka',
        imageUrls: ['/placeholder.svg?height=200&width=200&text=Cat+Family'],
        reportedAt: DateTime.now().subtract(const Duration(days: 1)),
        status: 'completed',
      ),
    ];
  }

  // Delete methods
  Future<void> deleteSellPost(String postId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: Implement actual API call
    // await http.delete('$_sellPostsEndpoint/$postId');
  }

  Future<void> deletePetSittingPost(String postId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: Implement actual API call
    // await http.delete('$_petSittingPostsEndpoint/$postId');
  }

  Future<void> deletePetSitterProfile(String profileId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: Implement actual API call
    // await http.delete('$_petSitterProfilesEndpoint/$profileId');
  }

  Future<void> deleteReportPost(String postId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: Implement actual API call
    // await http.delete('$_reportPostsEndpoint/$postId');
  }

  // Update methods for edit functionality
  Future<void> updateSellPost(String postId, SellPostModel post) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: Implement actual API call
    // await http.put('$_sellPostsEndpoint/$postId', body: post.toJson());
  }

  Future<void> updatePetSittingPost(String postId, PetSittingPostModel post) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: Implement actual API call
    // await http.put('$_petSittingPostsEndpoint/$postId', body: post.toJson());
  }

  Future<void> updatePetSitterProfile(String profileId, PetSitterProfileModel profile) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: Implement actual API call
    // await http.put('$_petSitterProfilesEndpoint/$profileId', body: profile.toJson());
  }

  Future<void> updateReportPost(String postId, ReportModel post) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: Implement actual API call
    // await http.put('$_reportPostsEndpoint/$postId', body: post.toJson());
  }
}
