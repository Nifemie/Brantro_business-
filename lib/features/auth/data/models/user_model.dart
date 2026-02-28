import 'signup_request.dart';

class UserModel {
  final dynamic id; // Can be int or String
  final String name;
  final String emailAddress;
  final String phoneNumber;
  final String accountType;
  final String role;
  final String authProvider;
  final String? profilePicture;
  final String country;
  final String? state;
  final String? city;
  final String? address;
  final ArtistInfo? artistInfo;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  // Additional fields from backend
  final String? alias;
  final String? bio;
  final String? avatarUrl;
  final String? coverUrl;
  final bool? isVerified;
  final String? status;
  final int? averageRating;
  final int? totalLikes;
  final int? totalAdSlots;
  final DateTime? lastLoginAt;
  final Map<String, dynamic>? additionalInfo;
  final int? referredId;
  final int? referredById;
  final int? walletId;
  final int? createdById;

  UserModel({
    required this.id,
    required this.name,
    required this.emailAddress,
    required this.phoneNumber,
    required this.accountType,
    required this.role,
    required this.authProvider,
    this.profilePicture,
    required this.country,
    this.state,
    this.city,
    this.address,
    this.artistInfo,
    this.createdAt,
    this.updatedAt,
    this.alias,
    this.bio,
    this.avatarUrl,
    this.coverUrl,
    this.isVerified,
    this.status,
    this.averageRating,
    this.totalLikes,
    this.totalAdSlots,
    this.lastLoginAt,
    this.additionalInfo,
    this.referredId,
    this.referredById,
    this.walletId,
    this.createdById,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      emailAddress: json['emailAddress'] ?? json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? json['phone'] ?? '',
      accountType: json['accountType'] ?? 'INDIVIDUAL',
      role: json['role'] ?? '',
      authProvider: json['authProvider'] ?? 'INTERNAL',
      profilePicture: json['profilePicture'],
      country: json['country'] ?? '',
      state: json['state'],
      city: json['city'],
      address: json['address'],
      artistInfo: json['artistInfo'] != null
          ? ArtistInfo.fromJson(json['artistInfo'])
          : null,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
      alias: json['alias'],
      bio: json['bio'],
      avatarUrl: json['avatarUrl'],
      coverUrl: json['coverUrl'],
      isVerified: json['isVerified'],
      status: json['status'],
      averageRating: json['averageRating'],
      totalLikes: json['totalLikes'],
      totalAdSlots: json['totalAdSlots'],
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'])
          : null,
      additionalInfo: json['additionalInfo'] != null
          ? Map<String, dynamic>.from(json['additionalInfo'])
          : null,
      referredId: json['referredId'],
      referredById: json['referredById'],
      walletId: json['walletId'],
      createdById: json['createdById'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'emailAddress': emailAddress,
      'phoneNumber': phoneNumber,
      'accountType': accountType,
      'role': role,
      'authProvider': authProvider,
      if (profilePicture != null) 'profilePicture': profilePicture,
      'country': country,
      if (state != null) 'state': state,
      if (city != null) 'city': city,
      if (address != null) 'address': address,
      if (artistInfo != null) 'artistInfo': artistInfo!.toJson(),
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (alias != null) 'alias': alias,
      if (bio != null) 'bio': bio,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      if (coverUrl != null) 'coverUrl': coverUrl,
      if (isVerified != null) 'isVerified': isVerified,
      if (status != null) 'status': status,
      if (averageRating != null) 'averageRating': averageRating,
      if (totalLikes != null) 'totalLikes': totalLikes,
      if (totalAdSlots != null) 'totalAdSlots': totalAdSlots,
      if (lastLoginAt != null) 'lastLoginAt': lastLoginAt!.toIso8601String(),
      if (additionalInfo != null) 'additionalInfo': additionalInfo,
      if (referredId != null) 'referredId': referredId,
      if (referredById != null) 'referredById': referredById,
      if (walletId != null) 'walletId': walletId,
      if (createdById != null) 'createdById': createdById,
    };
  }
}
