import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/avatar_helper.dart';
import '../../../../core/utils/url_helper.dart';

/// Helper class for profile navigation actions
class ProfileNavigationHelper {
  ProfileNavigationHelper._();

  /// Navigate to seller ad slots screen
  static void navigateToSellerAdSlots(
    BuildContext context,
    String sellerId,
    String sellerName,
    String? avatarUrl,
    String sellerType,
  ) {
    context.push(
      '/seller-ad-slots/$sellerId',
      extra: {
        'sellerName': sellerName,
        'sellerAvatar': AvatarHelper.getAvatar(
          avatarUrl: avatarUrl,
          userId: sellerId,
        ),
        'sellerType': sellerType,
      },
    );
  }

  /// Navigate to asset details screen
  static void navigateToAssetDetails(BuildContext context, dynamic asset) {
    context.push('/asset-details', extra: asset);
  }

  /// Navigate to view profile screen
  static void navigateToViewProfile(
    BuildContext context, {
    required String userId,
    required String name,
    String? avatar,
    required String location,
    required String profession,
    required List<String> genres,
    required String experience,
    required double rating,
    required int likes,
    String? specialization,
  }) {
    context.push(
      '/view-profile',
      extra: {
        'userId': userId,
        'name': name,
        'avatar': avatar,
        'location': location,
        'about':
            'Professional $profession available for verified advertising, partnerships, and brand collaborations on Brantro.',
        'genres': genres,
        'experience': experience,
        'projects': '0',
        'specialization': specialization ?? '',
        'profession': profession,
        'rating': rating.toString(),
        'likes': likes.toString(),
        'productions': '0',
        'socialMedia': {},
        'features': [
          'Verified media partners',
          'Transparent pricing',
          'Campaign performance tracking',
        ],
      },
    );
  }

  /// Handle portfolio link tap
  static Future<void> handlePortfolioTap(
    BuildContext context,
    String? portfolioLink,
  ) async {
    await UrlHelper.openPortfolioLink(context, portfolioLink);
  }

  /// Format location from city, state, country
  static String formatLocation(String? city, String? state, String? country) {
    final location = [city, state, country]
        .where((e) => e != null && e.isNotEmpty)
        .join(', ');
    return location.isEmpty ? 'Unknown' : location;
  }
}
