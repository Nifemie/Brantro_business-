import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../controllers/re_useable/app_color.dart';
import '../../../../../controllers/re_useable/app_texts.dart';
import '../../../../../core/utils/platform_responsive.dart';
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
                  // TODO: Navigate to explore screen for radio stations
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
          height: 340.h,
          child: radioStationsState.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                )
              : radioStationsState.error != null
              ? Center(
                  child: Text(
                    'Error loading radio stations',
                    style: AppTexts.bodyMedium(color: AppColors.textPrimary),
                  ),
                )
              : radioStationsState.radioStations.isEmpty
              ? Center(
                  child: Text(
                    'No radio stations available',
                    style: AppTexts.bodyMedium(color: AppColors.textPrimary),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: PlatformResponsive.symmetric(horizontal: 16),
                  itemCount: radioStationsState.radioStations.length,
                  itemBuilder: (context, index) {
                    final station = radioStationsState.radioStations[index];
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
                          // TODO: Navigate to booking page
                        },
                        onViewProfile: () {
                          // TODO: Navigate to profile page
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
