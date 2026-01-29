import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/color_utils.dart';
import '../../../../../core/utils/platform_responsive.dart';
import '../../../../../core/widgets/skeleton_loading.dart';
import '../../../../digital_screen/logic/digital_screens_notifier.dart';
import '../digital_screen_card.dart';

class DigitalScreenSection extends ConsumerStatefulWidget {
  const DigitalScreenSection({super.key});

  @override
  ConsumerState<DigitalScreenSection> createState() => _DigitalScreenSectionState();
}

class _DigitalScreenSectionState extends ConsumerState<DigitalScreenSection> {
  @override
  void initState() {
    super.initState();
    // Fetch digital screens on init (public endpoint - no auth required)
    Future.microtask(() {
      ref.read(digitalScreensProvider.notifier).fetchDigitalScreens(page: 0, size: 15);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screensState = ref.watch(digitalScreensProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: PlatformResponsive.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Digital Screens',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.push('/explore?category=Digital\\nScreens');
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
        if (screensState.isInitialLoading)
          SkeletonHorizontalList(
            cardWidth: 320.w,
            cardHeight: 450.h,
            itemCount: 3,
          )
        else if (screensState.message != null && !screensState.isDataAvailable)
          SizedBox(
            height: 450.h,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  SizedBox(height: 12.h),
                  Text(
                    'Error loading digital screens',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      screensState.message ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(digitalScreensProvider.notifier)
                          .fetchDigitalScreens(page: 0, size: 15);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          )
        else if ((screensState.data ?? []).isEmpty)
          SizedBox(
            height: 450.h,
            child: Center(child: Text('No digital screens found')),
          )
        else
          SizedBox(
            height: 480.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: PlatformResponsive.symmetric(horizontal: 16),
              children: (screensState.data ?? []).map((screen) {
                final location = [
                  screen.city,
                  screen.state,
                  screen.country,
                ].where((e) => e.isNotEmpty).join(', ');

                // Parse features string into list
                final featuresList = screen.features?.split(',').map((e) => e.trim()).toList() ?? [];

                return Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: DigitalScreenCard(
                    imageUrl: screen.thumbnail ?? 'assets/promotions/digital_screen1.jpg',
                    screenName: screen.title,
                    location: location.isEmpty ? screen.address : location,
                    description: screen.description,
                    features: featuresList,
                    specifications: screen.specifications ?? '',
                    priceStarting: '₦${screen.baseRateAmount.toStringAsFixed(0)}',
                    priceUnit: '/${screen.baseRateUnit.toLowerCase()}',
                    likes: screen.totalLikes,
                    provider: screen.owner?.name ?? '',
                    onLikeTap: () {},
                    onBookScreen: () {
                      // Navigate to specific slots for this digital screen
                      context.push(
                        '/seller-ad-slots/${screen.ownerId}',
                        extra: {
                          'sellerName': screen.title,
                          'sellerAvatar': screen.thumbnail,
                          'sellerType': 'Digital Screen',
                        },
                      );
                    },
                    onViewDetailsTap: () {
                      // Navigate to digital screen details (unified screen)
                      context.push('/asset-details', extra: screen);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
