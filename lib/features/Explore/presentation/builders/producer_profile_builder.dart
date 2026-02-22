import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/avatar_helper.dart';
import '../../../home/presentation/widgets/producer_card.dart';
import '../../../producer/logic/producers_notifier.dart';
import '../../../producer/data/models/producer_model.dart';
import '../helpers/profile_navigation_helper.dart';
import '../widgets/category_profile_list.dart';

class ProducerProfileBuilder {
  static Widget build(WidgetRef ref, BuildContext context) {
    final state = ref.watch(producersProvider);
    final data = state.asData?.value;
    
    return CategoryProfileList<ProducerModel>(
      items: data?.data ?? [],
      isLoading: state.isLoading,
      errorMessage: (data != null && data.isDataAvailable)
          ? null
          : (data?.message ?? state.error?.toString()),
      emptyMessage: 'No producers available',
      itemBuilder: (context, producer) {
        final location = ProfileNavigationHelper.formatLocation(
          producer.city,
          producer.state,
          producer.country,
        );
        final avatarUrl = AvatarHelper.getAvatar(
          avatarUrl: producer.avatarUrl,
          userId: producer.id,
        );
        final businessName = producer.additionalInfo?.businessName ?? producer.name;

        return ProducerCard(
          avatarUrl: avatarUrl,
          name: businessName,
          location: location,
          rating: producer.averageRating,
          likes: producer.totalLikes ?? 0,
          productions: producer.additionalInfo?.numberOfProductions ?? 0,
          onViewAdSlotsTap: () => ProfileNavigationHelper.navigateToSellerAdSlots(
            context,
            producer.id.toString(),
            businessName,
            producer.avatarUrl,
            'Producer',
          ),
        );
      },
    );
  }
}
