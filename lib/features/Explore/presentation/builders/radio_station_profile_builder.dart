import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/presentation/widgets/radio_station_card.dart';
import '../../../radio_station/logic/radio_stations_notifier.dart';
import '../../../radio_station/data/models/radio_station_model.dart';
import '../helpers/profile_navigation_helper.dart';
import '../widgets/category_profile_list.dart';

class RadioStationProfileBuilder {
  static Widget build(WidgetRef ref, BuildContext context) {
    final state = ref.watch(radioStationsProvider);
    final data = state.asData?.value;
    
    return CategoryProfileList<RadioStationModel>(
      items: data?.data ?? [],
      isLoading: state.isLoading,
      errorMessage: (data != null && data.isDataAvailable)
          ? null
          : (data?.message ?? state.error?.toString()),
      emptyMessage: 'No radio stations available',
      itemBuilder: (context, station) {
        final location = ProfileNavigationHelper.formatLocation(
          station.city,
          station.state,
          station.country,
        );
        final businessName = station.additionalInfo?.businessName ?? station.name;

        return RadioStationCard(
          stationName: businessName,
          location: location,
          stationType: station.additionalInfo?.broadcastBand ?? 'FM',
          rating: station.averageRating,
          favorites: station.totalLikes,
          yearsOnAir: station.additionalInfo?.yearsOfOperation ?? 0,
          categories: station.additionalInfo?.contentFocus ?? [],
          onBookAdSlot: () => ProfileNavigationHelper.navigateToSellerAdSlots(
            context,
            station.id.toString(),
            businessName,
            station.avatarUrl,
            'Radio Station',
          ),
          onViewProfile: () => ProfileNavigationHelper.navigateToViewProfile(
            context,
            userId: station.id.toString(),
            name: businessName,
            avatar: station.avatarUrl,
            location: location,
            profession: 'Radio Station',
            genres: station.additionalInfo?.contentFocus ?? [],
            experience: '${station.additionalInfo?.yearsOfOperation ?? 0} yrs',
            rating: station.averageRating,
            likes: station.totalLikes,
            specialization: station.additionalInfo?.broadcastBand ?? 'FM',
          ),
        );
      },
    );
  }
}
