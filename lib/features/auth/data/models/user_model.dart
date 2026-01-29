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
  final bool? isVerified;
  final String? status;
  final int? averageRating;
  final int? totalLikes;
  final DateTime? lastLoginAt;

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
    this.isVerified,
    this.status,
    this.averageRating,
    this.totalLikes,
    this.lastLoginAt,
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
      isVerified: json['isVerified'],
      status: json['status'],
      averageRating: json['averageRating'],
      totalLikes: json['totalLikes'],
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'])
          : null,
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
    };
  }
}
