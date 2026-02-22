import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/presentation/widgets/digital_screen_card.dart';
import '../../../digital_screen/logic/digital_screens_notifier.dart';
import '../../../digital_screen/data/models/digital_screen_model.dart';
import '../helpers/profile_navigation_helper.dart';
import '../widgets/category_profile_list.dart';

class DigitalScreenProfileBuilder {
  static Widget build(WidgetRef ref, BuildContext context) {
    final state = ref.watch(digitalScreensProvider);
    final data = state.asData?.value;
    
    return CategoryProfileList<DigitalScreenModel>(
      items: data?.data ?? [],
      isLoading: state.isLoading,
      errorMessage: (data != null && data.isDataAvailable)
          ? null
          : (data?.message ?? state.error?.toString()),
      emptyMessage: 'No digital screens available',
      itemBuilder: (context, screen) {
        final featuresList =
            screen.features?.split(',').map((e) => e.trim()).toList() ?? [];

        return DigitalScreenCard(
          imageUrl: screen.thumbnailUrl,
          screenName: screen.title,
          location: screen.fullLocation.isEmpty 
              ? screen.address 
              : screen.fullLocation,
          description: screen.cleanDescription,
          features: featuresList,
          specifications: screen.specifications ?? '',
          priceStarting: screen.formattedPrice,
          priceUnit: screen.baseRateAmount > 0 
              ? '/${screen.baseRateUnit.toLowerCase()}' 
              : '',
          likes: screen.totalLikes,
          provider: screen.owner?.name ?? '',
          onLikeTap: () {},
          onBookScreen: () => ProfileNavigationHelper.navigateToSellerAdSlots(
            context,
            screen.ownerId.toString(),
            screen.owner?.name ?? 'Digital Screen',
            screen.owner?.avatarUrl,
            'Digital Screen',
          ),
          onViewDetailsTap: () => ProfileNavigationHelper.navigateToAssetDetails(
            context,
            screen,
          ),
        );
      },
    );
  }
}
