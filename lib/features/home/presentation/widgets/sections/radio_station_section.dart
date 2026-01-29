import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../controllers/re_useable/app_color.dart';
import '../../../../../controllers/re_useable/app_texts.dart';
import '../../../../../core/utils/platform_responsive.dart';
import '../../../../../core/widgets/skeleton_loading.dart';
import '../../../../radio_station/logic/radio_stations_notifier.dart';
import '../radio_station_card.dart';

class RadioStationSection extends ConsumerStatefulWidget {
  const RadioStationSection({super.key});

  @override
  ConsumerState<RadioStationSection> createState() =>
      _RadioStationSectionState();
}

class _RadioStationSectionState extends ConsumerState<RadioStationSection> {
  @override
  void initState() {
    super.initState();
    // Fetch radio stations on load
    Future.microtask(() {
      ref.read(radioStationsProvider.notifier).fetchRadioStations(0, 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    final radioStationsState = ref.watch(radioStationsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: PlatformResponsive.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Radio Stations',
                style: AppTexts.h4(color: AppColors.textPrimary),
              ),
              GestureDetector(
                onTap: () {
                  context.push('/explore?category=Radio\\nStations');
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
        radioStationsState.isInitialLoading
            ? SkeletonHorizontalList(
                cardWidth: 320.w,
                cardHeight: 340.h,
                itemCount: 3,
                isProfileCard: true,
              )
            : SizedBox(
          height: 340.h,
          child: radioStationsState.message != null && !radioStationsState.isDataAvailable
              ? Center(
                  child: Text(
                    'Error loading radio stations',
                    style: AppTexts.bodyMedium(color: AppColors.textPrimary),
                  ),
                )
              : (radioStationsState.data ?? []).isEmpty
              ? Center(
                  child: Text(
                    'No radio stations available',
                    style: AppTexts.bodyMedium(color: AppColors.textPrimary),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: PlatformResponsive.symmetric(horizontal: 16),
                  itemCount: (radioStationsState.data ?? []).length,
                  itemBuilder: (context, index) {
                    final station = (radioStationsState.data ?? [])[index];
                    final location = [
                      station.city,
                      station.state,
                      station.country,
                    ].where((e) => e != null).join(', ');

                    return Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: RadioStationCard(
                        stationName:
                            station.additionalInfo?.businessName ??
                            station.name,
                        location: location.isEmpty ? 'Unknown' : location,
                        stationType:
                            station.additionalInfo?.broadcastBand ?? 'FM',
                        rating: station.averageRating,
                        favorites: station.totalLikes,
                        yearsOnAir:
                            station.additionalInfo?.yearsOfOperation ?? 0,
                        categories: station.additionalInfo?.contentFocus ?? [],
                        onBookAdSlot: () {
                          context.push('/seller-ad-slots/${station.id}', extra: {
                            'sellerName': station.additionalInfo?.businessName ?? station.name,
                            'sellerAvatar': station.avatarUrl,
                            'sellerType': 'Radio Station',
                          });
                        },
                        onViewProfile: () {
                          context.push('/view-profile', extra: {
                            'userId': station.id,
                            'name': station.additionalInfo?.businessName ?? station.name,
                            'avatar': station.avatarUrl,
                            'location': location,
                            'about': 'Professional Radio Station available for verified advertising, partnerships, and brand collaborations on Brantro.',
                            'genres': station.additionalInfo?.contentFocus ?? [],
                            'experience': '${station.additionalInfo?.yearsOfOperation ?? 0} yrs',
                            'projects': '0',
                            'specialization': station.additionalInfo?.broadcastBand ?? 'FM',
                            'profession': 'Radio Station',
                            'rating': station.averageRating.toString(),
                            'likes': station.totalLikes.toString(),
                            'productions': '0',
                            'socialMedia': {},
                            'features': [
                              'Verified media partners',
                              'Transparent pricing',
                              'Campaign performance tracking',
                            ],
                          });
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
