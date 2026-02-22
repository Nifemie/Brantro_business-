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
  ConsumerState<DigitalScreenSection> createState() =>
      _DigitalScreenSectionState();
}

class _DigitalScreenSectionState extends ConsumerState<DigitalScreenSection> {
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
        screensState.when(
          loading: () => SkeletonHorizontalList(
            cardWidth: 320.w,
            cardHeight: 450.h,
            itemCount: 3,
          ),
          error: (error, _) => SizedBox(
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
                      error.toString(),
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
          ),
          data: (state) {
            final screens = state.data ?? [];

            if (screens.isEmpty) {
              return SizedBox(
                height: 450.h,
                child: Center(child: Text('No digital screens found')),
              );
            }

            return SizedBox(
              height: 480.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: PlatformResponsive.symmetric(horizontal: 16),
                children: screens.map((screen) {
                  final location = [
                    screen.city,
                    screen.state,
                    screen.country,
                  ].where((e) => e.isNotEmpty).join(', ');

                  // Parse features string into list
                  final featuresList =
                      screen.features
                          ?.split(',')
                          .map((e) => e.trim())
                          .toList() ??
                      [];

                  return Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: DigitalScreenCard(
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
                      onBookScreen: () {
                        // Navigate to specific slots for this digital screen
                        context.push(
                          '/seller-ad-slots/${screen.ownerId}',
                          extra: {
                            'sellerName': screen.title,
                            'sellerAvatar': screen.thumbnailUrl,
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
            );
          },
        ),
      ],
    );
  }
}
