import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/avatar_helper.dart';
import '../../../home/presentation/widgets/ugc_creator_card.dart';
import '../../../ugc_creator/logic/ugc_creators_notifier.dart';
import '../../../ugc_creator/data/models/ugc_creator_model.dart';
import '../helpers/profile_navigation_helper.dart';
import '../widgets/category_profile_list.dart';

class UgcCreatorProfileBuilder {
  static Widget build(WidgetRef ref, BuildContext context) {
    final state = ref.watch(ugcCreatorsProvider);
    final data = state.asData?.value;
    
    return CategoryProfileList<UgcCreatorModel>(
      items: data?.data ?? [],
      isLoading: state.isLoading,
      errorMessage: (data != null && data.isDataAvailable)
          ? null
          : (data?.message ?? state.error?.toString()),
      emptyMessage: 'No UGC creators available',
      itemBuilder: (context, creator) {
        final location = ProfileNavigationHelper.formatLocation(
          creator.city,
          creator.state,
          creator.country,
        );
        final avatarUrl = AvatarHelper.getAvatar(
          avatarUrl: creator.avatarUrl,
          userId: creator.id,
        );
        final displayName = creator.additionalInfo?.displayName ?? creator.name;

        return UgcCreatorCard(
          profileImage: avatarUrl,
          name: displayName,
          location: location,
          workType: creator.additionalInfo?.availabilityType ?? 'Campaign Based',
          categories: creator.additionalInfo?.niches ?? [],
          skills: creator.additionalInfo?.contentStyle ?? [],
          contentType: (creator.additionalInfo?.contentFormats ?? []).join(', '),
          rating: creator.averageRating,
          likes: creator.totalLikes,
          onViewServices: () => ProfileNavigationHelper.navigateToSellerAdSlots(
            context,
            creator.id.toString(),
            displayName,
            creator.avatarUrl,
            'UGC Creator',
          ),
        );
      },
    );
  }
}
