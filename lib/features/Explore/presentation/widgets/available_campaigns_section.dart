import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../../../ad_slot/logic/ad_slot_notifier.dart';
import '../../../home/presentation/widgets/ad_slot_card.dart';
import '../../logic/explore_controller.dart';

class AvailableCampaignsSection extends ConsumerWidget {
  final String initialCategory;
  final VoidCallback? onSeeAll;

  const AvailableCampaignsSection({
    super.key,
    required this.initialCategory,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exploreState = ref.watch(exploreControllerProvider(initialCategory));
    final category = exploreState.category;
    final filters = exploreState.filters;
    final selectedSort = exploreState.selectedSort;
    
    final adSlotState = ref.watch(adSlotProvider);

    // Filter ad slots based on category and applied filters
    var filteredSlots = (adSlotState.data ?? []).where((slot) {
      // 1. Category filter (from screen initialization)
      if (category.isNotEmpty) {
        final type = slot.partnerType.toLowerCase();
        final cat = category.toLowerCase();

        bool match = false;
        if (cat.contains('radio')) match = type.contains('radio');
        else if (cat.contains('tv') || cat.contains('television')) match = type.contains('tv');
        else if (cat.contains('billboard')) match = type.contains('billboard');
        else if (cat.contains('influencer')) match = type.contains('influencer');
        else if (cat.contains('media')) match = type.contains('media');
        else if (cat.contains('artist')) match = type.contains('artist');
        else if (cat.contains('producer')) match = type.contains('producer');
        else if (cat.contains('creative')) match = type.contains('creative');
        else match = true;

        if (!match) return false;
      }

      // 2. Role filter (from FilterBottomSheet)
      if (filters['role'] != null) {
        if (slot.partnerType.toUpperCase() != filters['role']) return false;
      }

      // 3. Category filter (from FilterBottomSheet - ad types)
      if (filters['category'] != null) {
        if (slot.partnerType.toUpperCase() != filters['category']) return false;
      }

      return true;
    }).toList();

    // 4. Sorting
    if (selectedSort == 'Price: Low to High') {
      filteredSlots.sort((a, b) => (double.tryParse(a.price) ?? 0).compareTo(double.tryParse(b.price) ?? 0));
    } else if (selectedSort == 'Price: High to Low') {
      filteredSlots.sort((a, b) => (double.tryParse(b.price) ?? 0).compareTo(double.tryParse(a.price) ?? 0));
    } else if (selectedSort == 'Rating') {
      filteredSlots.sort((a, b) {
        final ratingA = a.user?['averageRating'] ?? 0.0;
        final ratingB = b.user?['averageRating'] ?? 0.0;
        return (ratingB as num).compareTo(ratingA as num);
      });
    }

    if (adSlotState.isInitialLoading) {
      return SizedBox(
        height: 420.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: 3,
          itemBuilder: (context, index) => SkeletonCampaignCard(
            width: 320.w,
            height: 420.h,
          ),
        ),
      );
    }

    if (filteredSlots.isEmpty) {
      if (adSlotState.message != null && !adSlotState.isDataAvailable) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Error loading campaigns',
            style: AppTexts.bodyMedium(color: Colors.red),
          ),
        );
      }
      return const SizedBox.shrink(); 
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Available Campaigns', style: AppTexts.h3()),
              TextButton(
                onPressed: () {
                  context.push('/campaigns-list?category=$category');
                },
                child: Text(
                  'See All',
                  style: AppTexts.bodyMedium(color: AppColors.primaryColor),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 420.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: filteredSlots.length,
            itemBuilder: (context, index) {
              final adSlot = filteredSlots[index];
              return AdSlotCard(
                sellerName: adSlot.sellerName,
                sellerType: adSlot.partnerType,
                campaignTitle: adSlot.title,
                category: adSlot.partnerType,
                subcategory: adSlot.contentTypes.isNotEmpty
                    ? adSlot.contentTypes.first
                    : 'General',
                features: adSlot.features,
                location: adSlot.location,
                reach: adSlot.audienceSize,
                price: adSlot.formattedPrice,
                sellerImage: adSlot.sellerAvatar,
                adSlotId: adSlot.id.toString(),
                onViewSlot: () {
                  context.push('/ad-slot-details/${adSlot.id}', extra: adSlot);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
