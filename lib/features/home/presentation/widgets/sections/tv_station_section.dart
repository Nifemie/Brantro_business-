import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../controllers/re_useable/app_color.dart';
import '../../../../../controllers/re_useable/app_texts.dart';
import '../../../../../core/utils/platform_responsive.dart';
import '../../../../../core/widgets/skeleton_loading.dart';
import '../../../../tv_station/logic/tv_stations_notifier.dart';
import '../tv_station_card.dart';

class TvStationSection extends ConsumerStatefulWidget {
  const TvStationSection({super.key});

  @override
  ConsumerState<TvStationSection> createState() => _TvStationSectionState();
}

class _TvStationSectionState extends ConsumerState<TvStationSection> {
  @override
  void initState() {
    super.initState();
    // Fetch TV stations on load
    Future.microtask(() {
      ref.read(tvStationsProvider.notifier).fetchTvStations(0, 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tvStationsState = ref.watch(tvStationsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: PlatformResponsive.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TV Stations',
                style: AppTexts.h4(color: AppColors.textPrimary),
              ),
              GestureDetector(
                onTap: () {
                  context.push('/explore?category=TV\\nStations');
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
        tvStationsState.isInitialLoading
            ? SkeletonHorizontalList(
                cardWidth: 320.w,
                cardHeight: 380.h,
                itemCount: 3,
                isProfileCard: true,
              )
            : SizedBox(
          height: 380.h,
          child: tvStationsState.message != null && !tvStationsState.isDataAvailable
              ? Center(
                  child: Text(
                    'Error loading TV stations',
                    style: AppTexts.bodyMedium(color: AppColors.textPrimary),
                  ),
                )
              : (tvStationsState.data ?? []).isEmpty
              ? Center(
                  child: Text(
                    'No TV stations available',
                    style: AppTexts.bodyMedium(color: AppColors.textPrimary),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: PlatformResponsive.symmetric(horizontal: 16),
                  itemCount: (tvStationsState.data ?? []).length,
                  itemBuilder: (context, index) {
                    final station = (tvStationsState.data ?? [])[index];
                    final location = [
                      station.city,
                      station.state,
                      station.country,
                    ].where((e) => e != null).join(', ');

                    return Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: TvStationCard(
                        stationName:
                            station.additionalInfo?.businessName ??
                            station.name,
                        location: location.isEmpty ? 'Unknown' : location,
                        stationType:
                            station.additionalInfo?.broadcastType ?? 'Cable',
                        isFree: station.additionalInfo?.channelType == 'Free',
                        isLive: true,
                        rating: station.averageRating,
                        favorites: station.totalLikes,
                        yearsOnAir:
                            station.additionalInfo?.yearsOfOperation ?? 0,
                        categories: station.additionalInfo?.contentFocus ?? [],
                        broadcastArea:
                            (station.additionalInfo?.operatingRegions ?? [])
                                .join(', '),
                        onViewRates: () {
                          context.push('/seller-ad-slots/${station.id}', extra: {
                            'sellerName': station.additionalInfo?.businessName ?? station.name,
                            'sellerAvatar': station.avatarUrl,
                            'sellerType': 'TV Station',
                          });
                        },
                        onViewProfile: () {
                          context.push('/view-profile', extra: {
                            'userId': station.id,
                            'name': station.additionalInfo?.businessName ?? station.name,
                            'avatar': station.avatarUrl,
                            'location': location,
                            'about': 'Professional TV Station available for verified advertising, partnerships, and brand collaborations on Brantro.',
                            'genres': station.additionalInfo?.contentFocus ?? [],
                            'experience': '${station.additionalInfo?.yearsOfOperation ?? 0} yrs',
                            'projects': '0',
                            'specialization': station.additionalInfo?.broadcastType ?? 'Cable',
                            'profession': 'TV Station',
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
