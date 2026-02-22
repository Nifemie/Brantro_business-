import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ad_slot/logic/ad_slot_notifier.dart';
import '../../Digital_services/logic/services_notifier.dart';
import '../../ugc_creator/logic/ugc_creators_notifier.dart';
import '../../artist/logic/artists_notifier.dart';
import '../../billboard/logic/billboards_notifier.dart';
import '../../digital_screen/logic/digital_screens_notifier.dart';
import '../../influencer/logic/influencers_notifier.dart';
import '../../tv_station/logic/tv_stations_notifier.dart';
import '../../radio_station/logic/radio_stations_notifier.dart';
import '../../producer/logic/producers_notifier.dart';
import '../../creatives/logic/creatives_notifier.dart';

/// Handles refreshing all home screen sections
class HomeRefreshHandler {
  final WidgetRef ref;

  HomeRefreshHandler(this.ref);

  /// Refresh all sections on home screen
  Future<void> refreshAllSections() async {
    try {
      await Future.wait<void>([
        // Featured Campaigns
        ref.read(adSlotProvider.notifier).loadAdSlots(refresh: true).catchError((e) => null),
        
        // Digital Services
        ref.read(servicesProvider.notifier).fetchServices(page: 0, size: 10).catchError((e) => null),
        
        // UGC Creators
        ref.read(ugcCreatorsProvider.notifier).fetchUgcCreators(page: 0, limit: 10).catchError((e) => null),
        
        // Artists
        ref.read(artistsProvider.notifier).fetchArtists(page: 1, limit: 10).catchError((e) => null),
        
        // Billboards
        ref.read(billboardsProvider.notifier).fetchBillboards(page: 0, size: 15).catchError((e) => null),
        
        // Digital Screens
        ref.read(digitalScreensProvider.notifier).fetchDigitalScreens(page: 0, size: 15).catchError((e) => null),
        
        // Influencers
        ref.read(influencersProvider.notifier).fetchInfluencers(page: 0, limit: 10).catchError((e) => null),
        
        // TV Stations
        ref.read(tvStationsProvider.notifier).fetchTvStations(0, 10).catchError((e) => null),
        
        // Radio Stations
        ref.read(radioStationsProvider.notifier).fetchRadioStations(0, 10).catchError((e) => null),
        
        // Producers
        ref.read(producersProvider.notifier).fetchProducers(page: 1, limit: 10).catchError((e) => null),
        
        // Creatives
        ref.read(creativesProvider.notifier).fetchCreatives(page: 0, size: 10).catchError((e) => null),
      ]);
    } catch (e) {
      // Silently handle errors
    }
  }

  /// Check if any provider has a network error
  bool hasNetworkError() {
    final artistsAsync = ref.read(artistsProvider);
    final billboardsAsync = ref.read(billboardsProvider);
    final digitalScreensAsync = ref.read(digitalScreensProvider);
    final ugcAsync = ref.read(ugcCreatorsProvider);
    final influencersAsync = ref.read(influencersProvider);
    final producersAsync = ref.read(producersProvider);
    final tvStationsAsync = ref.read(tvStationsProvider);
    final radioStationsAsync = ref.read(radioStationsProvider);
    final servicesAsync = ref.read(servicesProvider);
    final creativesAsync = ref.read(creativesProvider);
    
    return artistsAsync.hasError ||
        billboardsAsync.hasError ||
        digitalScreensAsync.hasError ||
        ugcAsync.hasError ||
        influencersAsync.hasError ||
        tvStationsAsync.hasError ||
        radioStationsAsync.hasError ||
        producersAsync.hasError ||
        servicesAsync.hasError ||
        creativesAsync.hasError;
  }
}
