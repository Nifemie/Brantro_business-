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
import '../../billboard/logic/billboards_notifier.dart';
import '../../digital_screen/logic/digital_screens_notifier.dart';
import '../../ad_slot/logic/ad_slot_notifier.dart';
import 'widgets/available_campaigns_section.dart';
import 'widgets/top_profiles_section.dart';
import '../logic/explore_controller.dart';
import '../../home/presentation/widgets/search_bar_widget.dart';
import '../../home/presentation/widgets/sections/digital_services_section.dart';
import '../../home/presentation/widgets/sections/vetting_services_section.dart';
import '../../home/presentation/widgets/sections/template_section.dart';
import '../../home/presentation/widgets/sections/creatives_section.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  final String? category;

  const ExploreScreen({super.key, this.category});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  // Methods to interact with the controller
  ExploreController _controller(String category) =>
      ref.read(exploreControllerProvider(category).notifier);

  ExploreState _state(String category) =>
      ref.watch(exploreControllerProvider(category));

  @override
  void initState() {
    super.initState();
    final category = widget.category?.toLowerCase() ?? '';
    // Initialize the controller with the category and fetch data
    Future.microtask(() {
      _controller(category).initialize(category);
    });
  }

  Future<void> _onRefresh() async {
    final category = widget.category?.toLowerCase() ?? '';
    await Future.wait<void>([
      ref.read(adSlotProvider.notifier).loadAdSlots(refresh: true),
      if (category.contains('artist'))
        ref.read(artistsProvider.notifier).fetchArtists(page: 1, limit: 10)
      else if (category.contains('influencer'))
        ref
            .read(influencersProvider.notifier)
            .fetchInfluencers(page: 0, limit: 10)
      else if (category.contains('radio'))
        ref.read(radioStationsProvider.notifier).fetchRadioStations(0, 10)
      else if (category.contains('tv'))
        ref.read(tvStationsProvider.notifier).fetchTvStations(0, 10)
      else if (category.contains('media'))
        ref.read(mediaHousesProvider.notifier).fetchMediaHouses(0, 10)
      else if (category.contains('designer') || category.contains('creative'))
        ref.read(creativesProvider.notifier).fetchCreatives(page: 0, limit: 10)
      else if (category.contains('ugc'))
        ref
            .read(ugcCreatorsProvider.notifier)
            .fetchUgcCreators(page: 0, limit: 10)
      else if (category.contains('film') || category.contains('producer'))
        ref.read(producersProvider.notifier).fetchProducers(page: 1, limit: 10)
      else if (category.contains('billboard'))
        ref.read(billboardsProvider.notifier).fetchBillboards(page: 0, size: 15)
      else if (category.contains('digital') || category.contains('screen'))
        ref
            .read(digitalScreensProvider.notifier)
            .fetchDigitalScreens(page: 0, size: 15),
    ]);
  }

  @override
  void dispose() {
    // No need to dispose _searchController as it's now managed by the controller
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
    final category = widget.category?.toLowerCase() ?? '';
    final exploreState = _state(category);

    // Watch providers for error state
    final adSlotState = ref.watch(adSlotProvider);

    // Check for network error based on category - only check for actual async errors
    bool categoryHasError = false;

    if (category.contains('artist')) {
      final s = ref.watch(artistsProvider);
      categoryHasError = s.hasError;
    } else if (category.contains('influencer')) {
      final s = ref.watch(influencersProvider);
      categoryHasError = s.hasError;
    } else if (category.contains('ugc')) {
      final s = ref.watch(ugcCreatorsProvider);
      categoryHasError = s.hasError;
    } else if (category.contains('tv') || category.contains('television')) {
      final s = ref.watch(tvStationsProvider);
      categoryHasError = s.hasError;
    } else if (category.contains('radio')) {
      final s = ref.watch(radioStationsProvider);
      categoryHasError = s.hasError;
    } else if (category.contains('designer') || category.contains('creative')) {
      final s = ref.watch(creativesProvider);
      categoryHasError = s.hasError;
    }

    // Only hide content if there's an actual network error
    final bool hideContent = categoryHasError;

    return Material(
      type: MaterialType.transparency,
      child: Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
        body: Column(
          children: [
            // Blue Header with Search Bar
            Container(
              color: AppColors.primaryColor,
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // Search bar
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      child: _buildSearchBar(category),
                    ),
                    
                    // Filter & Sort row
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
                      child: _buildFilterSortRow(category),
                    ),
                  ],
                ),
              ),
            ),

            // Scrollable content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: hideContent
                    ? _buildNetworkErrorPlaceholder()
                    : _getContentWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkErrorPlaceholder() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: 500.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, size: 64.sp, color: Colors.grey[400]),
              SizedBox(height: 16.h),
              Text(
                'No internet connection',
                style: AppTexts.h3(color: AppColors.textSecondary),
              ),
              SizedBox(height: 8.h),
              Text(
                'Pull down to try again',
                style: AppTexts.bodyMedium(color: AppColors.grey500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getContentWidget() {
    final category = widget.category?.toLowerCase() ?? '';

    // Build the dual-section layout with campaigns and profiles
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Available Campaigns Section - only show when no category is selected
          if (widget.category == null || widget.category!.isEmpty) ...[
            AvailableCampaignsSection(
              initialCategory: category,
              onSeeAll: () {
                // TODO: Navigate to all campaigns
              },
            ),
            SizedBox(height: 32.h),
          ],

          // Digital Services Section (only show when no category selected)
          if (widget.category == null || widget.category!.isEmpty) ...[
            DigitalServicesSection(initialCategory: category),
            SizedBox(height: 32.h),

            // Vetting Services Section
            const VettingServicesSection(),
            SizedBox(height: 32.h),

            // Template Section
            const TemplateSection(),
            SizedBox(height: 32.h),

            // Creatives Section
            const CreativesSection(),
            SizedBox(height: 32.h),
          ],

          // Top Profiles Section
          TopProfilesSection(
            initialCategory: category,
            showSeeAll: widget.category == null || widget.category!.isEmpty, // Hide See All when category is selected
            onSeeAll: () {
              // TODO: Navigate to all profiles
            },
            fallbackWidget: _buildListingsGrid(),
          ),

          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildSearchBar(String category) {
    // Get the display name for the category
    String searchPlaceholder = 'Search campaigns';
    if (widget.category != null && widget.category!.isNotEmpty) {
      final categoryName = _getCategoryDisplayName(category);
      searchPlaceholder = 'Search $categoryName';
    }

    return GestureDetector(
      onTap: () {
        // Navigate to search results when user taps search
        if (_state(category).searchController.text.isNotEmpty) {
          context.push(
            '/search-results?query=${_state(category).searchController.text}',
          );
        } else {
          context.push('/search');
        }
      },
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Icon(
                Icons.search,
                color: AppColors.grey600,
                size: 20.sp,
              ),
            ),
            Expanded(
              child: Text(
                searchPlaceholder,
                style: TextStyle(
                  color: AppColors.grey600,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSortRow(String category) {
    final exploreState = _state(category);
    final hasFilters =
        exploreState.filters.isNotEmpty &&
        (exploreState.filters['role'] != null ||
            exploreState.filters['category'] != null);

    return Row(
      children: [
        // Filter button
        Expanded(
          child: GestureDetector(
            onTap: () {
              FilterBottomSheet.show(
                context,
                onApplyFilters: (filters) {
                  _controller(category).updateFilters(filters);
                },
              );
            },
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.tune,
                    color: hasFilters
                        ? AppColors.primaryColor
                        : AppColors.textPrimary,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Filter',
                    style: AppTexts.bodyMedium(
                      color: hasFilters
                          ? AppColors.primaryColor
                          : AppColors.textPrimary,
                    ),
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
            initialValue: exploreState.selectedSort,
            onSelected: (value) {
              _controller(category).updateSort(value);
            },
            offset: Offset(0, 50.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            itemBuilder: (context) => [
              _buildSortMenuItem('Recommended', category),
              _buildSortMenuItem('Price: Low to High', category),
              _buildSortMenuItem('Price: High to Low', category),
              _buildSortMenuItem('Most Booked', category),
              _buildSortMenuItem('Rating', category),
            ],
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sort, color: AppColors.textPrimary, size: 20.sp),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: Text(
                      exploreState.selectedSort,
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

  PopupMenuItem<String> _buildSortMenuItem(String value, String category) {
    return PopupMenuItem<String>(
      value: value,
      child: Text(
        value,
        style: AppTexts.bodyMedium(
          color: _state(category).selectedSort == value
              ? AppColors.primaryColor
              : AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildListingsGrid() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: Column(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 48.sp,
              color: AppColors.grey400,
            ),
            SizedBox(height: 16.h),
            Text('Coming soon', style: AppTexts.h4(color: AppColors.grey500)),
          ],
        ),
      ),
    );
  }

  String _getCategoryDisplayName(String category) {
    if (category.contains('influencer')) return 'Influencer';
    if (category.contains('artist')) return 'Artist';
    if (category.contains('radio')) return 'Radio Station';
    if (category.contains('tv')) return 'TV Station';
    if (category.contains('media')) return 'Media House';
    if (category.contains('billboard')) return 'Billboard';
    if (category.contains('digital') || category.contains('screen'))
      return 'Digital Screen';
    if (category.contains('designer') || category.contains('creative'))
      return 'Designer';
    if (category.contains('ugc')) return 'UGC Creator';
    if (category.contains('film') || category.contains('producer'))
      return 'Producer';
    return 'Seller';
  }
}
