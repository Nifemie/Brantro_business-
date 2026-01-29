import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/color_utils.dart';
import '../../../../../core/utils/platform_responsive.dart';
import '../../../../../core/widgets/skeleton_loading.dart';
import '../../../../billboard/logic/billboards_notifier.dart';
import '../billboard_card.dart';

class BillboardSection extends ConsumerStatefulWidget {
  const BillboardSection({super.key});

  @override
  ConsumerState<BillboardSection> createState() => _BillboardSectionState();
}

class _BillboardSectionState extends ConsumerState<BillboardSection> {
  @override
  void initState() {
    super.initState();
    // Fetch billboards on init (public endpoint - no auth required)
    Future.microtask(() {
      ref.read(billboardsProvider.notifier).fetchBillboards(page: 0, size: 15);
    });
  }

  @override
  Widget build(BuildContext context) {
    final billboardsState = ref.watch(billboardsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: PlatformResponsive.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Billboards',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.push('/explore?category=Billboards');
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
        if (billboardsState.isInitialLoading)
          SkeletonHorizontalList(
            cardWidth: 320.w,
            cardHeight: 500.h,
            itemCount: 3,
          )
        else if (billboardsState.message != null && !billboardsState.isDataAvailable)
          SizedBox(
            height: 500.h,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  SizedBox(height: 12.h),
                  Text(
                    'Error loading billboards',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      billboardsState.message ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(billboardsProvider.notifier)
                          .fetchBillboards(page: 0, size: 15);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          )
        else if ((billboardsState.data ?? []).isEmpty)
          SizedBox(
            height: 500.h,
            child: Center(child: Text('No billboards found')),
          )
        else
          SizedBox(
            height: 500.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: PlatformResponsive.symmetric(horizontal: 16),
              children: (billboardsState.data ?? []).map((billboard) {
                final location = [
                  billboard.city,
                  billboard.state,
                  billboard.country,
                ].where((e) => e.isNotEmpty).join(', ');

                // Parse features string into list
                final featuresList = billboard.features?.split(',').map((e) => e.trim()).toList() ?? [];

                return Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: SizedBox(
                    width: 320.w,
                    child: BillboardCard(
                      imageUrl: billboard.thumbnail ?? 'assets/promotions/billboard1.jpg',
                      category: billboard.category?.name ?? 'Billboard',
                      location: location.isEmpty ? billboard.address : location,
                      title: billboard.title,
                      subtitle: billboard.description,
                      tags: featuresList,
                      additionalInfo: billboard.specifications ?? '',
                      rating: billboard.averageRating,
                      ratedBy: billboard.totalLikes > 0 ? '${billboard.totalLikes} likes' : '',
                      price: '₦${billboard.baseRateAmount.toStringAsFixed(0)}',
                      priceUnit: 'per ${billboard.baseRateUnit.toLowerCase()}',
                      likes: billboard.totalLikes,
                      onLikeTap: () {},
                      onBookTap: () {
                        // Navigate to specific slots for this billboard
                        context.push(
                          '/seller-ad-slots/${billboard.ownerId}',
                          extra: {
                            'sellerName': billboard.title,
                            'sellerAvatar': billboard.thumbnail,
                            'sellerType': 'Billboard',
                          },
                        );
                      },
                      onViewDetailsTap: () {
                        // Navigate to billboard details
                        context.push('/asset-details', extra: billboard);
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
