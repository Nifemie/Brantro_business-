import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/color_utils.dart';
import '../../../../../core/utils/platform_responsive.dart';
import '../../../../../core/widgets/skeleton_loading.dart';
import '../../../../creatives/logic/creatives_notifier.dart';
import '../../../../cart/presentation/widgets/add_to_campaign_sheet.dart';
import '../../../../cart/data/models/cart_item_model.dart';
import '../creative_card.dart';

class CreativesSection extends ConsumerStatefulWidget {
  const CreativesSection({super.key});

  @override
  ConsumerState<CreativesSection> createState() => _CreativesSectionState();
}

class _CreativesSectionState extends ConsumerState<CreativesSection> {
  @override
  Widget build(BuildContext context) {
    final creativesState = ref.watch(creativesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: PlatformResponsive.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Creatives',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.push('/creatives');
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        creativesState.when(
          loading: () => SkeletonHorizontalList(
            cardWidth: 320.w,
            cardHeight: 520.h,
            itemCount: 3,
          ),
          error: (error, _) => SizedBox(
            height: 520.h,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  SizedBox(height: 12.h),
                  Text(
                    'Error loading creatives',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(creativesProvider.notifier)
                          .fetchCreatives(page: 0, size: 10);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
          data: (state) {
            final creatives = state.data ?? [];

            if (state.message != null && !state.isDataAvailable) {
              return SizedBox(
                height: 520.h,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48),
                      SizedBox(height: 12.h),
                      Text(
                        'Error loading creatives',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          state.message ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(creativesProvider.notifier)
                              .fetchCreatives(page: 0, size: 10);
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (creatives.isEmpty) {
              return SizedBox(
                height: 520.h,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_library_outlined,
                        size: 48.sp,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Creatives are not available for now',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Check back later for new creatives',
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SizedBox(
              height: 520.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: PlatformResponsive.symmetric(horizontal: 16),
                itemCount: creatives.length,
                itemBuilder: (context, index) {
                  final creative = creatives[index];
                  return Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: SizedBox(
                      width: 320.w,
                      child: CreativeCard(
                        title: creative.title,
                        description: creative.cleanDescription,
                        fileSize: creative.fileSizeFormatted,
                        dimensions: creative.dimensionsFormatted,
                        formats: List<String>.from(
                          creative.fileFormat.map(
                            (f) => f.toString().toUpperCase(),
                          ),
                        ),
                        downloads: creative.downloads,
                        rating: creative.averageRating,
                        price: creative.formattedPrice,
                        imageUrl: creative.thumbnailUrl,
                        tags: <String>[creative.type, creative.format],
                        onViewDetails: () {
                          context.push('/creative-details/${creative.id}');
                        },
                        onBuy: () {
                          final cartItem = CartItem(
                            id: creative.id.toString(),
                            type: 'creative',
                            title: creative.title,
                            description: creative.cleanDescription,
                            price: creative.formattedPrice,
                            imageUrl: creative.thumbnailUrl,
                            sellerName:
                                creative.owner?.name ?? 'Brantro Africa',
                            sellerType: creative.type,
                            metadata: {
                              'fileSize': creative.fileSizeFormatted,
                              'dimensions': creative.dimensionsFormatted,
                              'formats': creative.fileFormat,
                              'downloads': creative.downloads,
                              'rating': creative.averageRating,
                              'tags': creative.tagsList,
                            },
                          );
                          AddToCampaignSheet.show(context, cartItem);
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
