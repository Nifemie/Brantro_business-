import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/presentation/widgets/billboard_card.dart';
import '../../../billboard/logic/billboards_notifier.dart';
import '../../../billboard/data/models/billboard_model.dart';
import '../helpers/profile_navigation_helper.dart';
import '../widgets/category_profile_list.dart';

class BillboardProfileBuilder {
  static Widget build(WidgetRef ref, BuildContext context) {
    final state = ref.watch(billboardsProvider);
    final data = state.asData?.value;
    
    return CategoryProfileList<BillboardModel>(
      items: data?.data ?? [],
      isLoading: state.isLoading,
      errorMessage: (data != null && data.isDataAvailable)
          ? null
          : (data?.message ?? state.error?.toString()),
      emptyMessage: 'No billboards available',
      itemBuilder: (context, billboard) {
        final featuresList =
            billboard.features?.split(',').map((e) => e.trim()).toList() ?? [];

        return BillboardCard(
          imageUrl: billboard.thumbnailUrl,
          category: billboard.category?.name ?? 'Billboard',
          location: billboard.fullLocation.isEmpty 
              ? billboard.address 
              : billboard.fullLocation,
          title: billboard.title,
          subtitle: billboard.cleanDescription,
          tags: featuresList,
          additionalInfo: billboard.specifications ?? '',
          rating: billboard.averageRating,
          ratedBy: billboard.totalLikes > 0
              ? '${billboard.totalLikes} likes'
              : '',
          price: billboard.formattedPrice,
          priceUnit: billboard.baseRateAmount > 0
              ? 'per ${billboard.baseRateUnit.toLowerCase()}'
              : '',
          likes: billboard.totalLikes,
          onLikeTap: () {},
          onBookTap: () => ProfileNavigationHelper.navigateToSellerAdSlots(
            context,
            billboard.ownerId.toString(),
            billboard.owner?.name ?? 'Billboard',
            billboard.owner?.avatarUrl,
            'Billboard',
          ),
          onViewDetailsTap: () => ProfileNavigationHelper.navigateToAssetDetails(
            context,
            billboard,
          ),
        );
      },
    );
  }
}
