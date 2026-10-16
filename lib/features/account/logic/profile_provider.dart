import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/service/session_service.dart';
import '../../../core/network/api_client.dart';
import '../data/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProfileRepository(apiClient);
});

// Profile Header Data Model
class ProfileHeaderData {
  final String avatarUrl;
  final String fullName;
  final String email;
  final String role;
  final List<String> roles;
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
    this.roles = const [],
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

  bool hasRole(String targetRole) {
    final target = targetRole.trim().toUpperCase();
    if (role.trim().toUpperCase() == target) return true;
    return roles.any((r) => r.trim().toUpperCase() == target);
  }

  bool get isInfluencer =>
      hasRole('INFLUENCER') ||
      hasRole('PRODUCER') ||
      hasRole('ARTIST') ||
      hasRole('TV_STATION') ||
      hasRole('RADIO_STATION') ||
      hasRole('UGC_CREATOR') ||
      hasRole('MEDIA_HOUSE');

  bool get isCreator =>
      hasRole('CREATOR') ||
      hasRole('CREATIVE') ||
      hasRole('DESIGNER');

  bool get isHost => hasRole('HOST');
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
      roles: ['GUEST'],
      experience: '0+ Years',
      productions: 0,
      genres: [],
      userId: 'guest',
    );
  }
  
  final user = await SessionService.getUser();
  final userId = user?['id']?.toString() ?? user?['userId']?.toString() ?? 'user';
  
  Map<String, dynamic>? activeUser = user != null ? Map<String, dynamic>.from(user) : null;
  
  if (userId != 'user' && userId != 'guest') {
    final profileRepository = ref.read(profileRepositoryProvider);
    try {
      final payload = await profileRepository.getUserDetails(userId);
      activeUser = payload;
    } catch (e) {
      print('Failed to fetch user details from server: $e');
    }
  }

  final fullName = await SessionService.getUserFullname();
  final email = await SessionService.getUsername();
  
  // Calculate experience from yearsOfExperience in additionalInfo
  String experience = '0+ Years';
  if (activeUser != null && activeUser['additionalInfo'] != null) {
    final additionalInfo = activeUser['additionalInfo'] as Map<String, dynamic>;
    final years = additionalInfo['yearsOfExperience'] ?? 0;
    experience = '$years+ Years';
  }
  
  // Get productions and genres from additionalInfo
  int productions = 0;
  List<String> genres = [];
  
  if (activeUser != null && activeUser['additionalInfo'] != null) {
    final additionalInfo = activeUser['additionalInfo'] as Map<String, dynamic>;
    
    // Get number of productions
    productions = additionalInfo['numberOfProductions'] ?? 0;
    
    // Get genres - handle both string and list formats
    if (additionalInfo['genres'] != null) {
      final genresData = additionalInfo['genres'];
      if (genresData is List) {
        genres = List<String>.from(genresData);
      } else if (genresData is String) {
        genres = genresData.split(',').map((g) => g.trim()).toList();
      }
    }
  }
  
  // Build location string from state and country
  String location = '';
  if (activeUser != null) {
    final state = activeUser['state'] ?? '';
    final country = activeUser['country'] ?? '';
    if (state.isNotEmpty && country.isNotEmpty) {
      location = '$state, $country';
    } else if (country.isNotEmpty) {
      location = country;
    }
  }
  
  final phoneNumber = activeUser?['phoneNumber'] ?? '';
  final status = activeUser?['status'] ?? 'ACTIVE';
  final rating = (activeUser?['averageRating'] ?? 0).toDouble();
  final reviewsCount = activeUser?['totalReviews'] ?? 0;
  final followers = activeUser?['followersCount'] ?? 0;

  // Parse multi-role personas
  final List<String> parsedRoles = [];
  if (activeUser != null) {
    if (activeUser['roles'] is List) {
      for (var r in (activeUser['roles'] as List)) {
        if (r != null && r.toString().isNotEmpty) {
          parsedRoles.add(r.toString().trim().toUpperCase());
        }
      }
    } else if (activeUser['roles'] is String) {
      final split = (activeUser['roles'] as String).split(',');
      for (var r in split) {
        if (r.trim().isNotEmpty) {
          parsedRoles.add(r.trim().toUpperCase());
        }
      }
    }

    if (activeUser['role'] != null && activeUser['role'].toString().isNotEmpty) {
      final singleRole = activeUser['role'].toString().trim().toUpperCase();
      if (!parsedRoles.contains(singleRole)) {
        parsedRoles.add(singleRole);
      }
    }
  }
  
  return ProfileHeaderData(
    avatarUrl: activeUser?['avatarUrl'] ?? '',
    fullName: activeUser?['name'] ?? fullName ?? 'User',
    email: activeUser?['emailAddress'] ?? email ?? '',
    role: activeUser?['role'] ?? 'USER',
    roles: parsedRoles,
    experience: experience,
    productions: productions,
    genres: genres,
    userId: userId,
    bannerUrl: activeUser?['coverUrl'] ?? '',
    phoneNumber: phoneNumber,
    location: location,
    followers: followers,
    status: status,
    rating: rating,
    reviewsCount: reviewsCount,
  );
});
