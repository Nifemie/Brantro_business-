import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../controllers/re_useable/app_texts.dart';
import '../../../controllers/re_useable/filter_bottom_sheet.dart';
import '../../home/presentation/widgets/reusable_card.dart';
import '../../home/presentation/widgets/influencer_card.dart';
import '../../home/presentation/widgets/billboard_card.dart';
import '../../home/presentation/widgets/artist_profile_card.dart';
import '../../home/presentation/widgets/radio_station_card.dart';
import '../../home/presentation/widgets/tv_station_card.dart';
import '../../home/presentation/widgets/media_house_card.dart';
import '../../home/presentation/widgets/digital_screen_card.dart';
import '../../home/presentation/widgets/designer_card.dart';
import '../../home/presentation/widgets/ugc_creator_card.dart';
import '../../home/presentation/widgets/film_producer_card.dart';
import '../../home/presentation/widgets/producer_card.dart';
import '../../artist/logic/artists_notifier.dart';
import '../../influencer/logic/influencers_notifier.dart';
import '../../radio_station/logic/radio_stations_notifier.dart';
import '../../tv_station/logic/tv_stations_notifier.dart';
import '../../media_house/logic/media_houses_notifier.dart';
import '../../creative/logic/creatives_notifier.dart';
import '../../ugc_creator/logic/ugc_creators_notifier.dart';
import '../../producer/logic/producers_notifier.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  final String? category;

  const ExploreScreen({super.key, this.category});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedSort = 'Recommended';

  @override
  void initState() {
    super.initState();
    // Fetch data based on category
    if (widget.category?.toLowerCase().contains('artist') ?? false) {
      Future.microtask(() {
        ref.read(artistsProvider.notifier).fetchArtists();
      });
    } else if (widget.category?.toLowerCase().contains('influencer') ?? false) {
      Future.microtask(() {
        ref.read(influencersProvider.notifier).fetchInfluencers();
      });
    } else if (widget.category?.toLowerCase().contains('radio') ?? false) {
      Future.microtask(() {
        ref.read(radioStationsProvider.notifier).fetchRadioStations(0, 10);
      });
    } else if (widget.category?.toLowerCase().contains('tv') ?? false) {
      Future.microtask(() {
        ref.read(tvStationsProvider.notifier).fetchTvStations(0, 10);
      });
    } else if (widget.category?.toLowerCase().contains('media') ?? false) {
      Future.microtask(() {
        ref.read(mediaHousesProvider.notifier).fetchMediaHouses(0, 10);
      });
    } else if (widget.category?.toLowerCase().contains('designer') ?? false) {
      Future.microtask(() {
        ref.read(creativesProvider.notifier).fetchCreatives();
      });
    } else if (widget.category?.toLowerCase().contains('creative') ?? false) {
      Future.microtask(() {
        ref.read(creativesProvider.notifier).fetchCreatives();
      });
    } else if (widget.category?.toLowerCase().contains('ugc') ?? false) {
      Future.microtask(() {
        ref.read(ugcCreatorsProvider.notifier).fetchUgcCreators();
      });
    } else if ((widget.category?.toLowerCase().contains('film') ?? false) ||
               (widget.category?.toLowerCase().contains('producer') ?? false)) {
      Future.microtask(() {
        ref.read(producersProvider.notifier).fetchProducers();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String? _getCategoryImage() {
    if (widget.category == null) return null;

    final category = widget.category!.toLowerCase();
    if (category.contains('artist')) return 'assets/promotions/Davido1.jpg';
    if (category.contains('billboard'))
      return 'assets/promotions/billboard1.jpg';
    if (category.contains('tv') || category.contains('television'))
      return 'assets/promotions/billboard2.jpg';
    if (category.contains('radio')) return 'assets/promotions/billboard3.jpg';
    if (category.contains('influencer')) return 'assets/promotions/Davido1.jpg';
    if (category.contains('media')) return 'assets/promotions/billboard2.jpg';
    if (category.contains('digital') || category.contains('screen'))
      return 'assets/promotions/billboard3.jpg';
    if (category.contains('designer') || category.contains('creative'))
      return 'assets/promotions/billboard1.jpg';

    return 'assets/promotions/Davido1.jpg'; // Default
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: AppColors.backgroundPrimary,
        child: Column(
          children: [
            // Category header image (if category is selected)
            if (widget.category != null && _getCategoryImage() != null)
              Stack(
                children: [
                  // Category image
                  Container(
                    height: 200.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(_getCategoryImage()!),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Back button
                  Positioned(
                    top: 16.h,
                    left: 16.w,
                    child: SafeArea(
                      bottom: false,
                      child: GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Category title overlay
                  Positioned(
                    bottom: 20.h,
                    left: 16.w,
                    right: 16.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.category!,
                          style: AppTexts.h1(color: Colors.white),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Explore ${widget.category!.toLowerCase()}',
                          style: AppTexts.bodyMedium(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            // Fixed top section with SafeArea
            SafeArea(
              bottom: false,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar
                    _buildSearchBar(),
                    SizedBox(height: 16.h),

                    // Filter & Sort row
                    _buildFilterSortRow(),
                  ],
                ),
              ),
            ),

            // Scrollable content - show role-specific cards or regular listings
            Expanded(child: _getContentWidget()),
          ],
        ),
      ),
    );
  }

  Widget _getContentWidget() {
    final category = widget.category?.toLowerCase() ?? '';

    if (category.contains('influencer')) {
      return _buildInfluencersList();
    } else if (category.contains('billboard')) {
      return _buildBillboardsList();
    } else if (category.contains('digital') || category.contains('screen')) {
      return _buildDigitalScreensList();
    } else if (category.contains('artist')) {
      return _buildArtistsList();
    } else if (category.contains('radio')) {
      return _buildRadioStationsList();
    } else if (category.contains('tv') || category.contains('television')) {
      return _buildTvStationsList();
    } else if (category.contains('media')) {
      return _buildMediaHousesList();
    } else if (category.contains('designer') || category.contains('creative')) {
      return _buildDesignersList();
    } else if (category.contains('ugc')) {
      return _buildUgcCreatorsList();
    } else if (category.contains('film') || category.contains('producer')) {
      return _buildFilmProducersList();
    } else {
      return _buildListingsGrid();
    }
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey200, width: 1),
      ),
      child: TextField(
        controller: _searchController,
        style: AppTexts.bodyMedium(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Search by name, location, platform…',
          hintStyle: AppTexts.bodyMedium(color: AppColors.grey400),
          prefixIcon: Icon(Icons.search, color: AppColors.grey400, size: 24.sp),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: AppColors.grey400,
                    size: 20.sp,
                  ),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildFilterSortRow() {
    return Row(
      children: [
        // Filter button
        Expanded(
          child: GestureDetector(
            onTap: () {
              FilterBottomSheet.show(context);
            },
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.grey300, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.tune, color: AppColors.textPrimary, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Filter',
                    style: AppTexts.bodyMedium(color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),

        // Sort dropdown
        Expanded(
          child: PopupMenuButton<String>(
            initialValue: selectedSort,
            onSelected: (value) {
              setState(() {
                selectedSort = value;
              });
            },
            offset: Offset(0, 50.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            itemBuilder: (context) => [
              _buildSortMenuItem('Recommended'),
              _buildSortMenuItem('Price: Low to High'),
              _buildSortMenuItem('Price: High to Low'),
              _buildSortMenuItem('Most Booked'),
              _buildSortMenuItem('Rating'),
            ],
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.grey300, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sort, color: AppColors.textPrimary, size: 20.sp),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: Text(
                      'Sort',
                      style: AppTexts.bodyMedium(color: AppColors.textPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.grey400,
                    size: 20.sp,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildSortMenuItem(String value) {
    return PopupMenuItem<String>(
      value: value,
      child: Text(
        value,
        style: AppTexts.bodyMedium(
          color: selectedSort == value
              ? AppColors.primaryColor
              : AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildListingsGrid() {
    return Center(
      child: Text(
        'Coming soon',
        style: AppTexts.bodyMedium(color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildInfluencersList() {
    final influencersState = ref.watch(influencersProvider);

    if (influencersState.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      );
    }

    if (influencersState.error != null) {
      return Center(
        child: Text(
          'Error loading influencers: ${influencersState.error}',
          style: AppTexts.bodyMedium(color: AppColors.textPrimary),
        ),
      );
    }

    if (influencersState.influencers.isEmpty) {
      return Center(
        child: Text(
          'No influencers available',
          style: AppTexts.bodyMedium(color: AppColors.textPrimary),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: influencersState.influencers.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final influencer = influencersState.influencers[index];
        final location = [
          influencer.city,
          influencer.state,
          influencer.country,
        ].where((e) => e != null).join(', ');

        return InfluencerCard(
          profileImage: influencer.avatarUrl ?? 'assets/promotions/Davido1.jpg',
          name: influencer.additionalInfo?.displayName ?? influencer.name,
          username: '@${influencer.name.toLowerCase().replaceAll(' ', '_')}',
          location: location.isEmpty ? 'Unknown' : location,
          platform:
              influencer.additionalInfo?.primaryPlatform ?? 'Social Media',
          rating: influencer.averageRating ?? 0.0,
          likes: influencer.totalLikes ?? 0,
          followers: 0,
          onPortfolioTap: () {
            // TODO: Navigate to portfolio
          },
          onViewSlotsTap: () {
            // TODO: Navigate to view slots
          },
        );
      },
    );
  }

  Widget _buildBillboardsList() {
    return Center(
      child: Text(
        'Coming soon',
        style: AppTexts.bodyMedium(color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildArtistsList() {
    final artistsState = ref.watch(artistsProvider);

    if (artistsState.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      );
    }

    if (artistsState.error != null) {
      return Center(
        child: Text(
          'Error loading artists: ${artistsState.error}',
          style: AppTexts.bodyMedium(color: AppColors.textPrimary),
        ),
      );
    }

    if (artistsState.artists.isEmpty) {
      return Center(
        child: Text(
          'No artists available',
          style: AppTexts.bodyMedium(color: AppColors.textPrimary),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: artistsState.artists.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final artist = artistsState.artists[index];
        final location = [
          artist.city,
          artist.state,
          artist.country,
        ].where((e) => e != null).join(', ');

        return ArtistProfileCard(
          profileImage: artist.avatarUrl ?? 'assets/promotions/Davido1.jpg',
          name: artist.additionalInfo?.stageName ?? artist.name,
          location: location.isEmpty ? 'Unknown' : location,
          tags: artist.additionalInfo?.genres ?? [],
          rating: artist.averageRating,
          likes: artist.totalLikes ?? 0,
          works: artist.additionalInfo?.numberOfProductions ?? 0,
          isFavorite: false,
          onFavoriteTap: () {
            // TODO: Handle favorite action
          },
          onViewSlotsTap: () {
            // TODO: Navigate to ad slots page
          },
        );
      },
    );
  }

  Widget _buildRadioStationsList() {
    final radioStationsState = ref.watch(radioStationsProvider);

    if (radioStationsState.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      );
    }

    if (radioStationsState.error != null) {
      return Center(
        child: Text(
          'Error loading radio stations: ${radioStationsState.error}',
          style: AppTexts.bodyMedium(color: AppColors.textPrimary),
        ),
      );
    }

    if (radioStationsState.radioStations.isEmpty) {
      return Center(
        child: Text(
          'No radio stations available',
          style: AppTexts.bodyMedium(color: AppColors.textPrimary),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: radioStationsState.radioStations.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final station = radioStationsState.radioStations[index];
        final location = [
          station.city,
          station.state,
          station.country,
        ].where((e) => e != null).join(', ');

        return RadioStationCard(
          stationName: station.additionalInfo?.businessName ?? station.name,
          location: location.isEmpty ? 'Unknown' : location,
          stationType: station.additionalInfo?.broadcastBand ?? 'FM',
          rating: station.averageRating,
          favorites: station.totalLikes,
          yearsOnAir: station.additionalInfo?.yearsOfOperation ?? 0,
          categories: station.additionalInfo?.contentFocus ?? [],
          onBookAdSlot: () {
            // TODO: Navigate to booking page
          },
          onViewProfile: () {
            // TODO: Navigate to profile page
          },
        );
      },
    );
  }

  Widget _buildTvStationsList() {
    final tvStationsState = ref.watch(tvStationsProvider);

    if (tvStationsState.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      );
    }

    if (tvStationsState.error != null) {
      return Center(
        child: Text(
          'Error loading TV stations: ${tvStationsState.error}',
          style: AppTexts.bodyMedium(color: AppColors.textPrimary),
        ),
      );
    }

    if (tvStationsState.tvStations.isEmpty) {
      return Center(
        child: Text(
          'No TV stations available',
          style: AppTexts.bodyMedium(color: AppColors.textPrimary),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: tvStationsState.tvStations.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final station = tvStationsState.tvStations[index];
        final location = [
          station.city,
          station.state,
          station.country,
        ].where((e) => e != null).join(', ');

        return TvStationCard(
          stationName: station.additionalInfo?.businessName ?? station.name,
          location: location.isEmpty ? 'Unknown' : location,
          stationType: station.additionalInfo?.broadcastType ?? 'Cable',
          isFree: station.additionalInfo?.channelType == 'Free',
          isLive: true,
          rating: station.averageRating,
          favorites: station.totalLikes,
          yearsOnAir: station.additionalInfo?.yearsOfOperation ?? 0,
          categories: station.additionalInfo?.contentFocus ?? [],
          broadcastArea: (station.additionalInfo?.operatingRegions ?? []).join(
            ', ',
          ),
          onViewRates: () {
            // TODO: Navigate to rates page
          },
          onViewProfile: () {
            // TODO: Navigate to profile page
          },
        );
      },
    );
  }

  Widget _buildMediaHousesList() {
    final mediaHousesState = ref.watch(mediaHousesProvider);

    if (mediaHousesState.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      );
    }

    if (mediaHousesState.error != null) {
      return Center(
        child: Text(
          'Error loading media houses: ${mediaHousesState.error}',
          style: AppTexts.bodyMedium(color: AppColors.textPrimary),
        ),
      );
    }

    if (mediaHousesState.mediaHouses.isEmpty) {
      return Center(
        child: Text(
          'No media houses available',
          style: AppTexts.bodyMedium(color: AppColors.textPrimary),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: mediaHousesState.mediaHouses.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final mediaHouse = mediaHousesState.mediaHouses[index];
        final location = [
          mediaHouse.city,
          mediaHouse.state,
          mediaHouse.country,
        ].where((e) => e != null).join(', ');

        return MediaHouseCard(
          mediaHouseName:
              mediaHouse.additionalInfo?.businessName ?? mediaHouse.name,
          location: location.isEmpty ? 'Unknown' : location,
          mediaTypes: mediaHouse.additionalInfo?.mediaTypes ?? [],
          rating: mediaHouse.averageRating,
          favorites: mediaHouse.totalLikes,
          yearsActive: mediaHouse.additionalInfo?.yearsOfOperation ?? 0,
          categories: mediaHouse.additionalInfo?.contentFocus ?? [],
          coverageArea: (mediaHouse.additionalInfo?.operatingRegions ?? [])
              .join(', '),
          reach:
              '${(mediaHouse.additionalInfo?.estimatedMonthlyReach ?? 0) / 1000000}M /month',
          onPlatformTap: () {
            // TODO: Navigate to platform page
          },
          onViewAdSlots: () {
            // TODO: Navigate to ad slots page
          },
        );
      },
    );
  }

  Widget _buildDigitalScreensList() {
    return Center(
      child: Text(
        'Coming soon',
        style: AppTexts.bodyMedium(color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildDesignersList() {
    final creativesState = ref.watch(creativesProvider);

    if (creativesState.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      );
    }

    if (creativesState.error != null) {
      return Center(
        child: Text(
          'Error loading creatives: ${creativesState.error}',
          style: AppTexts.bodyMedium(color: AppColors.textPrimary),
        ),
      );
    }

    if (creativesState.creatives.isEmpty) {
      return Center(
        child: Text(
          'No creatives available',
          style: AppTexts.bodyMedium(color: AppColors.textPrimary),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: creativesState.creatives.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final creative = creativesState.creatives[index];
        final location = [
          creative.city,
          creative.state,
          creative.country,
        ].where((e) => e != null).join(', ');

        return DesignerCard(
          profileImage: creative.avatarUrl ?? 'assets/promotions/Davido1.jpg',
          name: creative.additionalInfo?.displayName ?? creative.name,
          location: location.isEmpty ? 'Unknown' : location,
          specialization: creative.additionalInfo?.specialization ?? '',
          yearsExperience: creative.additionalInfo?.yearsOfExperience ?? 0,
          likes: creative.totalLikes,
          followers: creative.additionalInfo?.numberOfProjects ?? 0,
          onViewPortfolio: () {
            // TODO: Navigate to portfolio page
          },
          onViewServices: () {
            // TODO: Navigate to services page
          },
        );
      },
    );
  }

  Widget _buildUgcCreatorsList() {
    final ugcCreatorsState = ref.watch(ugcCreatorsProvider);

    if (ugcCreatorsState.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      );
    }

    if (ugcCreatorsState.error != null) {
      return Center(
        child: Text(
          'Error loading UGC creators: ${ugcCreatorsState.error}',
          style: AppTexts.bodyMedium(color: AppColors.textPrimary),
        ),
      );
    }

    if (ugcCreatorsState.ugcCreators.isEmpty) {
      return Center(
        child: Text(
          'No UGC creators available',
          style: AppTexts.bodyMedium(color: AppColors.textPrimary),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: ugcCreatorsState.ugcCreators.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final creator = ugcCreatorsState.ugcCreators[index];
        final location = [
          creator.city,
          creator.state,
          creator.country,
        ].where((e) => e != null).join(', ');

        return UgcCreatorCard(
          profileImage: creator.avatarUrl ?? 'assets/promotions/Davido1.jpg',
          name: creator.additionalInfo?.displayName ?? creator.name,
          location: location.isEmpty ? 'Unknown' : location,
          workType:
              creator.additionalInfo?.availabilityType ?? 'Campaign Based',
          categories: creator.additionalInfo?.niches ?? [],
          skills: creator.additionalInfo?.contentStyle ?? [],
          contentType: (creator.additionalInfo?.contentFormats ?? []).join(
            ', ',
          ),
          rating: creator.averageRating,
          likes: creator.totalLikes,
          onViewServices: () {
            // TODO: Handle view services
          },
        );
      },
    );
  }

  Widget _buildFilmProducersList() {
    final producersState = ref.watch(producersProvider);

    if (producersState.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      );
    }

    if (producersState.error != null) {
      return Center(
        child: Text(
          'Error loading producers: ${producersState.error}',
          style: AppTexts.bodyMedium(color: AppColors.textPrimary),
        ),
      );
    }

    if (producersState.producers.isEmpty) {
      return Center(
        child: Text(
          'No producers available',
          style: AppTexts.bodyMedium(color: AppColors.textPrimary),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: producersState.producers.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final producer = producersState.producers[index];
        final location = [
          producer.city,
          producer.state,
          producer.country,
        ].where((e) => e != null).join(', ');

        return ProducerCard(
          avatarUrl: producer.avatarUrl ?? 'assets/promotions/Davido1.jpg',
          name: producer.additionalInfo?.businessName ?? producer.name,
          location: location.isEmpty ? 'Unknown' : location,
          rating: producer.averageRating,
          likes: producer.totalLikes ?? 0,
          productions: producer.additionalInfo?.numberOfProductions ?? 0,
          onViewAdSlotsTap: () {
            // TODO: Navigate to ad slots page
          },
        );
      },
    );
  }
}
