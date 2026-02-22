import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/avatar_helper.dart';
import '../../../home/presentation/widgets/designer_card.dart';
import '../../../creative/logic/creatives_notifier.dart';
import '../../../creative/data/models/creative_model.dart';
import '../helpers/profile_navigation_helper.dart';
import '../widgets/category_profile_list.dart';

class DesignerProfileBuilder {
  static Widget build(WidgetRef ref, BuildContext context) {
    final state = ref.watch(creativesProvider);
    final data = state.asData?.value;
    
    return CategoryProfileList<CreativeModel>(
      items: data?.data ?? [],
      isLoading: state.isLoading,
      errorMessage: (data != null && data.isDataAvailable)
          ? null
          : (data?.message ?? state.error?.toString()),
      emptyMessage: 'No designers available',
      itemBuilder: (context, creative) {
        final location = ProfileNavigationHelper.formatLocation(
          creative.city,
          creative.state,
          creative.country,
        );
        final avatarUrl = AvatarHelper.getAvatar(
          avatarUrl: creative.avatarUrl,
          userId: creative.id,
        );
        final displayName = creative.additionalInfo?.displayName ?? creative.name;

        return DesignerCard(
          profileImage: avatarUrl,
          name: displayName,
          location: location,
          specialization: creative.additionalInfo?.specialization ?? '',
          yearsExperience: creative.additionalInfo?.yearsOfExperience ?? 0,
          likes: creative.totalLikes,
          followers: creative.additionalInfo?.numberOfProjects ?? 0,
          onViewPortfolio: () {},
          onViewServices: () => ProfileNavigationHelper.navigateToSellerAdSlots(
            context,
            creative.id.toString(),
            displayName,
            creative.avatarUrl,
            'Designer',
          ),
        );
      },
    );
  }
}
