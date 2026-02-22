import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../controllers/re_useable/app_color.dart';
import '../../../../../controllers/re_useable/app_texts.dart';
import '../../../../../core/widgets/skeleton_loading.dart';
import '../ad_slot_card.dart';
import '../../../../ad_slot/logic/ad_slot_notifier.dart';

class FeaturedCampaignsSection extends ConsumerWidget {
  const FeaturedCampaignsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adSlotState = ref.watch(adSlotProvider);
    final hasData = (adSlotState.data ?? []).isNotEmpty;
    final isLoading = adSlotState.isInitialLoading;
    final hasError = adSlotState.message != null && !adSlotState.isDataAvailable;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Featured Campaigns', style: AppTexts.h3()),
              TextButton(
                onPressed: () {
                  context.push('/campaigns-list');
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

        // Content based on state
        if (isLoading && !hasData)
          _buildLoadingState()
        else if (hasError)
          _buildErrorState(adSlotState.message!, ref)
        else if (!hasData)
          _buildEmptyState()
        else
          _buildAdSlotsList(adSlotState.data ?? []),
      ],
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 480.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 3,
        itemBuilder: (context, index) => SkeletonCampaignCard(
          width: 320.w,
          height: 480.h,
        ),
      ),
    );
  }

  Widget _buildErrorState(String error, WidgetRef ref) {
    return Container(
      height: 480.h,
      padding: EdgeInsets.all(16.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
            SizedBox(height: 16.h),
            Text('Failed to load campaigns', style: AppTexts.h4()),
            SizedBox(height: 8.h),
            Text(
              error,
              style: AppTexts.bodySmall(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () =>
                  ref.read(adSlotProvider.notifier).loadAdSlots(refresh: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
              ),
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 480.h,
      padding: EdgeInsets.all(16.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.campaign_outlined,
              size: 48.sp,
              color: AppColors.grey400,
            ),
            SizedBox(height: 16.h),
            Text('Campaigns are not available for now', style: AppTexts.h4()),
            SizedBox(height: 8.h),
            Text(
              'Check back later for new opportunities',
              style: AppTexts.bodySmall(color: AppColors.grey600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdSlotsList(List adSlots) {
    // Take first 10 for featured section
    final featuredSlots = adSlots.take(10).toList();

    return SizedBox(
      height: 480.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: featuredSlots.length,
        itemBuilder: (context, index) {
          final adSlot = featuredSlots[index];
          return AdSlotCard(
            sellerName: adSlot.sellerName,
            sellerType: adSlot.partnerType,
            campaignTitle: adSlot.title,
            category: adSlot.primaryPlatform?.name ?? adSlot.partnerType,
            subcategory: adSlot.primaryPlatform?.handle ?? '',
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
    );
  }
}
