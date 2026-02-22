import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/presentation/widgets/media_house_card.dart';
import '../../../media_house/logic/media_houses_notifier.dart';
import '../../../media_house/data/models/media_house_model.dart';
import '../helpers/profile_navigation_helper.dart';
import '../widgets/category_profile_list.dart';

class MediaHouseProfileBuilder {
  static Widget build(WidgetRef ref, BuildContext context) {
    final state = ref.watch(mediaHousesProvider);
    
    return CategoryProfileList<MediaHouseModel>(
      items: state.mediaHouses,
      isLoading: state.isLoading,
      errorMessage: state.error,
      emptyMessage: 'No media houses available',
      itemBuilder: (context, mediaHouse) {
        final location = ProfileNavigationHelper.formatLocation(
          mediaHouse.city,
          mediaHouse.state,
          mediaHouse.country,
        );
        final businessName = mediaHouse.additionalInfo?.businessName ?? mediaHouse.name;

        return MediaHouseCard(
          mediaHouseName: businessName,
          location: location,
          mediaTypes: mediaHouse.additionalInfo?.mediaTypes ?? [],
          rating: mediaHouse.averageRating,
          favorites: mediaHouse.totalLikes,
          yearsActive: mediaHouse.additionalInfo?.yearsOfOperation ?? 0,
          categories: mediaHouse.additionalInfo?.contentFocus ?? [],
          coverageArea: (mediaHouse.additionalInfo?.operatingRegions ?? []).join(', '),
          reach:
              '${(mediaHouse.additionalInfo?.estimatedMonthlyReach ?? 0) / 1000000}M /month',
          onPlatformTap: () {},
          onViewAdSlots: () => ProfileNavigationHelper.navigateToSellerAdSlots(
            context,
            mediaHouse.id.toString(),
            businessName,
            mediaHouse.avatarUrl,
            'Media House',
          ),
        );
      },
    );
  }
}
