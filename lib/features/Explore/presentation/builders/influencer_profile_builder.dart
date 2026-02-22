import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/avatar_helper.dart';
import '../../../home/presentation/widgets/influencer_card.dart';
import '../../../influencer/logic/influencers_notifier.dart';
import '../../../influencer/data/models/influencer_model.dart';
import '../helpers/profile_navigation_helper.dart';
import '../widgets/category_profile_list.dart';

class InfluencerProfileBuilder {
  static Widget build(WidgetRef ref, BuildContext context) {
    final state = ref.watch(influencersProvider);
    final data = state.asData?.value;
    
    return CategoryProfileList<InfluencerModel>(
      items: data?.data ?? [],
      isLoading: state.isLoading,
      errorMessage: (data != null && data.isDataAvailable)
          ? null
          : (data?.message ?? state.error?.toString()),
      emptyMessage: 'No influencers available',
      itemBuilder: (context, influencer) {
        final location = ProfileNavigationHelper.formatLocation(
          influencer.city,
          influencer.state,
          influencer.country,
        );
        final avatarUrl = AvatarHelper.getAvatar(
          avatarUrl: influencer.avatarUrl,
          userId: influencer.id,
        );
        final displayName = influencer.additionalInfo?.displayName ?? influencer.name;

        return InfluencerCard(
          profileImage: avatarUrl,
          name: displayName,
          username: '@${influencer.name.toLowerCase().replaceAll(' ', '_')}',
          location: location,
          platform: influencer.additionalInfo?.primaryPlatform ?? 'Social Media',
          rating: influencer.averageRating ?? 0.0,
          likes: influencer.totalLikes ?? 0,
          followers: 0,
          onPortfolioTap: () => ProfileNavigationHelper.handlePortfolioTap(
            context,
            influencer.additionalInfo?.portfolioLink,
          ),
          onViewSlotsTap: () => ProfileNavigationHelper.navigateToSellerAdSlots(
            context,
            influencer.id.toString(),
            displayName,
            influencer.avatarUrl,
            'Influencer',
          ),
        );
      },
    );
  }
}
