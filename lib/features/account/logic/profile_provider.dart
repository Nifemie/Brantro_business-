import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/service/session_service.dart';

// Profile Header Data Model
class ProfileHeaderData {
  final String avatarUrl;
  final String fullName;
  final String email;
  final String role;
  final String experience;
  final int productions;
  final List<String> genres;
  final String userId;
  final String bannerUrl;
  final String phoneNumber;
  final String location;
  final int followers;
  final String status;
  final double rating;
  final int reviewsCount;

  const ProfileHeaderData({
    required this.avatarUrl,
    required this.fullName,
    required this.email,
    required this.role,
    required this.experience,
    required this.productions,
    required this.genres,
    required this.userId,
    this.bannerUrl = '',
    this.phoneNumber = '',
    this.location = '',
    this.followers = 0,
    this.status = 'ACTIVE',
    this.rating = 0.0,
    this.reviewsCount = 0,
  });
}

// Profile Header Provider
final profileHeaderProvider = FutureProvider<ProfileHeaderData>((ref) async {
  final isLoggedIn = await SessionService.isLoggedIn();
  
  if (!isLoggedIn) {
    return const ProfileHeaderData(
      avatarUrl: '',
      fullName: 'Guest',
      email: '',
      role: 'GUEST',
      experience: '0+ Years',
      productions: 0,
      genres: [],
      userId: 'guest',
    );
  }
  
  final user = await SessionService.getUser();
  final fullName = await SessionService.getUserFullname();
  final email = await SessionService.getUsername();
  
  // Calculate experience from yearsOfExperience in additionalInfo
  String experience = '0+ Years';
  if (user != null && user['additionalInfo'] != null) {
    final additionalInfo = user['additionalInfo'] as Map<String, dynamic>;
    final years = additionalInfo['yearsOfExperience'] ?? 0;
    experience = '$years+ Years';
  }
  
  final userId = user?['id']?.toString() ?? user?['userId']?.toString() ?? 'user';
  
  // Get productions and genres from additionalInfo
  int productions = 0;
  List<String> genres = [];
  
  if (user != null && user['additionalInfo'] != null) {
    final additionalInfo = user['additionalInfo'] as Map<String, dynamic>;
    
    // Get number of productions
    productions = additionalInfo['numberOfProductions'] ?? 0;
    
    // Get genres - handle both string and list formats
    if (additionalInfo['genres'] != null) {
      final genresData = additionalInfo['genres'];
      if (genresData is List) {
        genres = List<String>.from(genresData);
      } else if (genresData is String) {
        // Split by comma if it's a string like "Afrobeats, Gospel"
        genres = genresData.split(',').map((g) => g.trim()).toList();
      }
    }
  }
  
  // Build location string from state and country
  String location = '';
  if (user != null) {
    final state = user['state'] ?? '';
    final country = user['country'] ?? '';
    if (state.isNotEmpty && country.isNotEmpty) {
      location = '$state, $country';
    } else if (country.isNotEmpty) {
      location = country;
    }
  }
  
  // Get phone number
  final phoneNumber = user?['phoneNumber'] ?? '';
  
  // Get status
  final status = user?['status'] ?? 'ACTIVE';
  
  // Get rating and reviews (from backend or default to 0)
  final rating = (user?['averageRating'] ?? 0).toDouble();
  final reviewsCount = user?['totalReviews'] ?? 0;
  
  // Get followers count (TODO: This might come from a different endpoint)
  final followers = user?['followersCount'] ?? 0;
  
  return ProfileHeaderData(
    avatarUrl: user?['avatarUrl'] ?? '',
    fullName: fullName ?? user?['name'] ?? 'User',
    email: email ?? user?['emailAddress'] ?? '',
    role: user?['role'] ?? 'USER',
    experience: experience,
    productions: productions,
    genres: genres,
    userId: userId,
    bannerUrl: user?['coverUrl'] ?? '',
    phoneNumber: phoneNumber,
    location: location,
    followers: followers,
    status: status,
    rating: rating,
    reviewsCount: reviewsCount,
  );
});
