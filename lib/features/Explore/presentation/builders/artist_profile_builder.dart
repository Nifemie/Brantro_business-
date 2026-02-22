import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/avatar_helper.dart';
import '../../../home/presentation/widgets/artist_profile_card.dart';
import '../../../artist/logic/artists_notifier.dart';
import '../../../artist/data/models/artist_model.dart';
import '../helpers/profile_navigation_helper.dart';
import '../widgets/category_profile_list.dart';

class ArtistProfileBuilder {
  static Widget build(WidgetRef ref, BuildContext context) {
    final state = ref.watch(artistsProvider);
    final data = state.asData?.value;
    
    return CategoryProfileList<ArtistModel>(
      items: data?.data ?? [],
      isLoading: state.isLoading,
      errorMessage: (data != null && data.isDataAvailable)
          ? null
          : (data?.message ?? state.error?.toString()),
      emptyMessage: 'No artists available',
      itemBuilder: (context, artist) {
        final location = ProfileNavigationHelper.formatLocation(
          artist.city,
          artist.state,
          artist.country,
        );
        final avatarUrl = AvatarHelper.getAvatar(
          avatarUrl: artist.avatarUrl,
          userId: artist.id,
        );
        final stageName = artist.additionalInfo?.stageName ?? artist.name;

        return ArtistProfileCard(
          userId: artist.id,
          profileImage: avatarUrl,
          name: stageName,
          location: location,
          tags: artist.additionalInfo?.genres ?? [],
          rating: artist.averageRating,
          likes: artist.totalLikes ?? 0,
          works: artist.additionalInfo?.numberOfProductions ?? 0,
          isFavorite: false,
          onFavoriteTap: () {},
          onViewSlotsTap: () => ProfileNavigationHelper.navigateToSellerAdSlots(
            context,
            artist.id.toString(),
            stageName,
            artist.avatarUrl,
            'Artist',
          ),
        );
      },
    );
  }
}
