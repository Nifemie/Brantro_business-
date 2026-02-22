import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/presentation/widgets/tv_station_card.dart';
import '../../../tv_station/logic/tv_stations_notifier.dart';
import '../../../tv_station/data/models/tv_station_model.dart';
import '../helpers/profile_navigation_helper.dart';
import '../widgets/category_profile_list.dart';

class TvStationProfileBuilder {
  static Widget build(WidgetRef ref, BuildContext context) {
    final state = ref.watch(tvStationsProvider);
    final data = state.asData?.value;
    
    return CategoryProfileList<TvStationModel>(
      items: data?.data ?? [],
      isLoading: state.isLoading,
      errorMessage: (data != null && data.isDataAvailable)
          ? null
          : (data?.message ?? state.error?.toString()),
      emptyMessage: 'No TV stations available',
      itemBuilder: (context, station) {
        final location = ProfileNavigationHelper.formatLocation(
          station.city,
          station.state,
          station.country,
        );
        final businessName = station.additionalInfo?.businessName ?? station.name;

        return TvStationCard(
          stationName: businessName,
          location: location,
          stationType: station.additionalInfo?.broadcastType ?? 'Cable',
          isFree: station.additionalInfo?.channelType == 'Free',
          isLive: true,
          rating: station.averageRating,
          favorites: station.totalLikes,
          yearsOnAir: station.additionalInfo?.yearsOfOperation ?? 0,
          categories: station.additionalInfo?.contentFocus ?? [],
          broadcastArea: (station.additionalInfo?.operatingRegions ?? []).join(', '),
          onViewRates: () => ProfileNavigationHelper.navigateToSellerAdSlots(
            context,
            station.id.toString(),
            businessName,
            station.avatarUrl,
            'TV Station',
          ),
          onViewProfile: () => ProfileNavigationHelper.navigateToViewProfile(
            context,
            userId: station.id.toString(),
            name: businessName,
            avatar: station.avatarUrl,
            location: location,
            profession: 'TV Station',
            genres: station.additionalInfo?.contentFocus ?? [],
            experience: '${station.additionalInfo?.yearsOfOperation ?? 0} yrs',
            rating: station.averageRating,
            likes: station.totalLikes,
            specialization: station.additionalInfo?.broadcastType ?? 'Cable',
          ),
        );
      },
    );
  }
}
