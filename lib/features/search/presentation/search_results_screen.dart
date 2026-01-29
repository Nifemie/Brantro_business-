import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../controllers/re_useable/app_texts.dart';
import '../../../controllers/re_useable/filter_bottom_sheet.dart';
import '../../../core/widgets/skeleton_loading.dart';
import '../../home/presentation/widgets/ad_slot_card.dart';
import '../../home/presentation/widgets/artist_profile_card.dart';
import '../../ad_slot/logic/ad_slot_notifier.dart';
import '../../artist/logic/artists_notifier.dart';

class SearchResultsScreen extends ConsumerStatefulWidget {
  final String searchQuery;

  const SearchResultsScreen({super.key, required this.searchQuery});

  @override
  ConsumerState<SearchResultsScreen> createState() =>
      _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _searchController;
  late TabController _tabController;

  Map<String, dynamic> _filters = {};

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
    _tabController = TabController(length: 2, vsync: this);
    
    // Trigger search with the query for both ad slots and users
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performSearch(widget.searchQuery);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      // Search ad slots
      ref.read(adSlotProvider.notifier).searchAdSlots(query: query);
      
      // Search users (applying role filter if selected)
      ref.read(artistsProvider.notifier).searchUsers(
        query: query,
        role: _filters['role'],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final adSlotState = ref.watch(adSlotProvider);
    final usersState = ref.watch(artistsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: _buildSearchBar(),
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.tune, 
              color: _filters.isNotEmpty && (_filters['role'] != null || _filters['category'] != null)
                  ? AppColors.primaryColor 
                  : AppColors.textPrimary,
            ),
            onPressed: () {
              _showFilterModal(context);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryColor,
          unselectedLabelColor: AppColors.grey600,
          indicatorColor: AppColors.primaryColor,
          tabs: const [
            Tab(text: 'Ad Slots'),
            Tab(text: 'Users'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Ad Slots Tab
          _buildAdSlotsTab(adSlotState),
          // Users Tab
          _buildUsersTab(usersState),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 45.h,
      margin: EdgeInsets.only(right: 16.w),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextField(
        controller: _searchController,
        style: AppTexts.bodyMedium(color: AppColors.textPrimary),
        textAlignVertical: TextAlignVertical.center,
        onSubmitted: (value) {
          _performSearch(value);
        },
        decoration: InputDecoration(
          hintText: 'Search ad slots & users',
          hintStyle: AppTexts.bodyMedium(color: AppColors.grey400),
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: AppColors.grey400),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 12.h,
          ),
        ),
      ),
    );
  }

  Widget _buildAdSlotsTab(adSlotState) {
    if (adSlotState.isInitialLoading) {
      return SizedBox(
        height: 480.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(16.w),
          itemCount: 3,
          itemBuilder: (context, index) => SkeletonCampaignCard(
            width: 320.w,
            height: 480.h,
          ),
        ),
      );
    }

    if (adSlotState.message != null && !adSlotState.isDataAvailable) {
      return _buildErrorState('Error loading ad slots');
    }

    final adSlots = adSlotState.data ?? [];
    
    // Client-side filtering for ad slots by category if selected
    final filteredSlots = _filters['category'] != null
        ? adSlots.where((slot) => slot.partnerType.toUpperCase() == _filters['category']).toList()
        : adSlots;

    if (filteredSlots.isEmpty) {
      return _buildEmptyState('No ad slots found');
    }

    return _buildAdSlotsList(filteredSlots);
  }

  Widget _buildUsersTab(usersState) {
    if (usersState.isInitialLoading) {
      return ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: 3,
        itemBuilder: (context, index) => SkeletonListItem(),
      );
    }

    if (usersState.message != null && !usersState.isDataAvailable) {
      return _buildErrorState('Error loading users');
    }

    final users = usersState.data ?? [];
    if (users.isEmpty) {
      return _buildEmptyState('No users found');
    }

    return _buildUsersList(users);
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
          SizedBox(height: 16.h),
          Text(message, style: AppTexts.h4()),
          SizedBox(height: 8.h),
          Text(
            'Please try again',
            style: AppTexts.bodySmall(color: AppColors.grey600),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 48.sp, color: AppColors.grey400),
          SizedBox(height: 16.h),
          Text(message, style: AppTexts.h4()),
          SizedBox(height: 8.h),
          Text(
            'Try searching with different keywords',
            style: AppTexts.bodySmall(color: AppColors.grey600),
          ),
        ],
      ),
    );
  }

  Widget _buildAdSlotsList(List adSlots) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Results for "${_searchController.text}"', style: AppTexts.h4()),
          SizedBox(height: 16.h),
          SizedBox(
            height: 480.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: adSlots.length,
              itemBuilder: (context, index) {
                final adSlot = adSlots[index];
                return AdSlotCard(
                  sellerName: adSlot.sellerName,
                  sellerType: adSlot.partnerType,
                  campaignTitle: adSlot.title,
                  category: adSlot.primaryPlatform?.name ?? adSlot.partnerType,
                  subcategory: adSlot.primaryPlatform?.handle ?? '',
                  features: adSlot.features,
                  location: adSlot.location,
                  reach: adSlot.audienceSize,
                  price: adSlot.formattedPrice,
                  sellerImage: adSlot.sellerAvatar,
                  adSlotId: adSlot.id.toString(),
                  onViewSlot: () {
                    context.push('/ad-slot-details/${adSlot.id}', extra: adSlot);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList(List users) {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final artist = users[index];
        final locationList = [
          artist.city,
          artist.state,
        ].where((e) => e != null && e.toString().isNotEmpty).toList();
        final location = locationList.isEmpty ? (artist.country ?? 'Unknown') : locationList.join(', ');

        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: ArtistProfileCard(
            userId: artist.id,
            profileImage: artist.avatarUrl ?? '',
            name: artist.additionalInfo?.stageName ?? artist.name,
            location: location,
            tags: artist.additionalInfo?.genres ?? [],
            rating: artist.averageRating,
            likes: artist.totalLikes ?? 0,
            works: artist.additionalInfo?.numberOfProductions ?? 0,
            onFavoriteTap: () {
              // TODO: Handle favorite
            },
            onViewSlotsTap: () {
              // Handled internally by the card
            },
          ),
        );
      },
    );
  }



  void _showFilterModal(BuildContext context) {
    FilterBottomSheet.show(
      context,
      onApplyFilters: (filters) {
        setState(() {
          _filters = filters;
        });
        _performSearch(_searchController.text);
      },
    );
  }
}
