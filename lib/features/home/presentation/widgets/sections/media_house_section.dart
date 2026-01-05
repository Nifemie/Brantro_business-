import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../controllers/re_useable/app_color.dart';
import '../../../../../controllers/re_useable/app_texts.dart';
import '../../../../../core/utils/platform_responsive.dart';
import '../../../../media_house/logic/media_houses_notifier.dart';
import '../media_house_card.dart';

class MediaHouseSection extends ConsumerStatefulWidget {
  const MediaHouseSection({super.key});

  @override
  ConsumerState<MediaHouseSection> createState() => _MediaHouseSectionState();
}

class _MediaHouseSectionState extends ConsumerState<MediaHouseSection> {
  @override
  void initState() {
    super.initState();
    // Fetch media houses on load
    Future.microtask(() {
      ref.read(mediaHousesProvider.notifier).fetchMediaHouses(0, 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaHousesState = ref.watch(mediaHousesProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: PlatformResponsive.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Media Houses',
                style: AppTexts.h4(color: AppColors.textPrimary),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Navigate to explore screen for media houses
                },
                child: Text(
                  'View All',
                  style: AppTexts.linkLarge(color: AppColors.primaryColor),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 360.h,
          child: mediaHousesState.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                )
              : mediaHousesState.error != null
              ? Center(
                  child: Text(
                    'Error loading media houses',
                    style: AppTexts.bodyMedium(color: AppColors.textPrimary),
                  ),
                )
              : mediaHousesState.mediaHouses.isEmpty
              ? Center(
                  child: Text(
                    'No media houses available',
                    style: AppTexts.bodyMedium(color: AppColors.textPrimary),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: PlatformResponsive.symmetric(horizontal: 16),
                  itemCount: mediaHousesState.mediaHouses.length,
                  itemBuilder: (context, index) {
                    final mediaHouse = mediaHousesState.mediaHouses[index];
                    final location = [
                      mediaHouse.city,
                      mediaHouse.state,
                      mediaHouse.country,
                    ].where((e) => e != null).join(', ');

                    return Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: MediaHouseCard(
                        mediaHouseName:
                            mediaHouse.additionalInfo?.businessName ??
                            mediaHouse.name,
                        location: location.isEmpty ? 'Unknown' : location,
                        mediaTypes: mediaHouse.additionalInfo?.mediaTypes ?? [],
                        rating: mediaHouse.averageRating,
                        favorites: mediaHouse.totalLikes,
                        yearsActive:
                            mediaHouse.additionalInfo?.yearsOfOperation ?? 0,
                        categories:
                            mediaHouse.additionalInfo?.contentFocus ?? [],
                        coverageArea:
                            (mediaHouse.additionalInfo?.operatingRegions ?? [])
                                .join(', '),
                        reach:
                            '${(mediaHouse.additionalInfo?.estimatedMonthlyReach ?? 0) / 1000000}M /month',
                        onPlatformTap: () {
                          // TODO: Navigate to platform page
                        },
                        onViewAdSlots: () {
                          // TODO: Navigate to ad slots page
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
