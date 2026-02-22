import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../artist/logic/artists_notifier.dart';
import '../../influencer/logic/influencers_notifier.dart';
import '../../radio_station/logic/radio_stations_notifier.dart';
import '../../tv_station/logic/tv_stations_notifier.dart';
import '../../media_house/logic/media_houses_notifier.dart';
import '../../creative/logic/creatives_notifier.dart';
import '../../ugc_creator/logic/ugc_creators_notifier.dart';
import '../../producer/logic/producers_notifier.dart';
import '../../ad_slot/logic/ad_slot_notifier.dart';

class ExploreState {
  final String category;
  final Map<String, dynamic> filters;
  final String selectedSort;
  final TextEditingController searchController;

  ExploreState({
    required this.category,
    required this.filters,
    required this.selectedSort,
    required this.searchController,
  });

  ExploreState copyWith({
    String? category,
    Map<String, dynamic>? filters,
    String? selectedSort,
    TextEditingController? searchController,
  }) {
    return ExploreState(
      category: category ?? this.category,
      filters: filters ?? this.filters,
      selectedSort: selectedSort ?? this.selectedSort,
      searchController: searchController ?? this.searchController,
    );
  }
}

class ExploreController extends StateNotifier<ExploreState> {
  final Ref ref;

  ExploreController(this.ref, String initialCategory)
    : super(
        ExploreState(
          category: initialCategory,
          filters: {},
          selectedSort: 'Rating',
          searchController: TextEditingController(),
        ),
      );

  void initialize(String category) {
    updateCategory(category);
    _fetchDataForCategory(category);
    ref.read(adSlotProvider.notifier).loadAdSlots();
  }

  void updateCategory(String category) {
    state = state.copyWith(category: category);
    _fetchDataForCategory(category);
  }

  void _fetchDataForCategory(String category) {
    final cat = category.toLowerCase();
    if (cat.contains('artist')) {
      ref.read(artistsProvider.notifier).fetchArtists();
    } else if (cat.contains('influencer')) {
      ref.read(influencersProvider.notifier).fetchInfluencers();
    } else if (cat.contains('radio')) {
      ref.read(radioStationsProvider.notifier).fetchRadioStations(0, 10);
    } else if (cat.contains('tv')) {
      ref.read(tvStationsProvider.notifier).fetchTvStations(0, 10);
    } else if (cat.contains('media')) {
      ref.read(mediaHousesProvider.notifier).fetchMediaHouses(0, 10);
    } else if (cat.contains('designer') || cat.contains('creative')) {
      ref.read(creativesProvider.notifier).fetchCreatives(page: 0, limit: 10);
    } else if (cat.contains('ugc')) {
      ref.read(ugcCreatorsProvider.notifier).fetchUgcCreators();
    } else if (cat.contains('film') || cat.contains('producer')) {
      ref.read(producersProvider.notifier).fetchProducers();
    }
  }

  void updateFilters(Map<String, dynamic> filters) {
    state = state.copyWith(filters: filters);
  }

  void updateSort(String sort) {
    state = state.copyWith(selectedSort: sort);
  }

  void clearFilters() {
    state = state.copyWith(filters: {});
  }

  @override
  void dispose() {
    state.searchController.dispose();
    super.dispose();
  }
}

final exploreControllerProvider =
    StateNotifierProvider.family<ExploreController, ExploreState, String>((
      ref,
      initialCategory,
    ) {
      return ExploreController(ref, initialCategory);
    });
