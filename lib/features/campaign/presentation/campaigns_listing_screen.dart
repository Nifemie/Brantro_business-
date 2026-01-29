import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../controllers/re_useable/app_texts.dart';
import '../../../core/widgets/skeleton_loading.dart';
import '../../home/presentation/widgets/search_bar_widget.dart';
import '../../ad_slot/logic/ad_slot_notifier.dart';
import '../../home/presentation/widgets/ad_slot_card.dart';

class CampaignsListingScreen extends ConsumerStatefulWidget {
  final String? category;

  const CampaignsListingScreen({super.key, this.category});

  @override
  ConsumerState<CampaignsListingScreen> createState() => _CampaignsListingScreenState();
}

class _CampaignsListingScreenState extends ConsumerState<CampaignsListingScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'all';
  String _selectedSort = 'Recommended';
  final ScrollController _scrollController = ScrollController();
  List _filteredCampaigns = [];

  // Campaign categories for dropdown
  final List<Map<String, String>> _categories = [
    {'title': 'All Campaigns', 'key': 'all'},
    {'title': 'Influencer', 'key': 'influencer'},
    {'title': 'Billboard', 'key': 'billboard'},
    {'title': 'Digital Screen', 'key': 'screen'},
    {'title': 'Radio Station', 'key': 'radio'},
    {'title': 'TV Station', 'key': 'tv'},
    {'title': 'Artist', 'key': 'artist'},
    {'title': 'Producer', 'key': 'producer'},
    {'title': 'Media House', 'key': 'media'},
    {'title': 'Designer', 'key': 'creative'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.category != null && widget.category!.isNotEmpty) {
      _selectedCategory = widget.category!.toLowerCase();
    }
    Future.microtask(() {
      ref.read(adSlotProvider.notifier).loadAdSlots(refresh: true);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _applyFilters(List campaigns) {
    var filtered = List.from(campaigns);

    // Apply category filter
    if (_selectedCategory != 'all') {
      filtered = filtered.where((slot) {
        final type = slot.partnerType.toLowerCase();
        final cat = _selectedCategory.toLowerCase();

        if (cat.contains('radio')) return type.contains('radio');
        if (cat.contains('tv')) return type.contains('tv');
        if (cat.contains('billboard')) return type.contains('billboard');
        if (cat.contains('screen')) return type.contains('screen');
        if (cat.contains('influencer')) return type.contains('influencer');
        if (cat.contains('media')) return type.contains('media');
        if (cat.contains('artist')) return type.contains('artist');
        if (cat.contains('producer')) return type.contains('producer');
        if (cat.contains('creative')) return type.contains('creative');
        return true;
      }).toList();
    }

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((slot) {
        return slot.title.toLowerCase().contains(query) ||
            slot.description.toLowerCase().contains(query) ||
            slot.partnerType.toLowerCase().contains(query);
      }).toList();
    }

    // Apply sorting
    switch (_selectedSort) {
      case 'Price: Low to High':
        filtered.sort((a, b) => (double.tryParse(a.price) ?? 0).compareTo(double.tryParse(b.price) ?? 0));
        break;
      case 'Price: High to Low':
        filtered.sort((a, b) => (double.tryParse(b.price) ?? 0).compareTo(double.tryParse(a.price) ?? 0));
        break;
      case 'Rating':
        filtered.sort((a, b) {
          final ratingA = a.user?['averageRating'] ?? 0.0;
          final ratingB = b.user?['averageRating'] ?? 0.0;
          return (ratingB as num).compareTo(ratingA as num);
        });
        break;
      case 'Recommended':
      default:
        // Keep original order
        break;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _filteredCampaigns = filtered;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final adSlotState = ref.watch(adSlotProvider);

    // Apply filters whenever data changes
    if (adSlotState.data != null && adSlotState.data!.isNotEmpty) {
      _applyFilters(adSlotState.data!);
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Column(
        children: [
          // Header with breadcrumb
          _buildHeader(),

          // Search and filters
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              children: [
                _buildSearchBar(),
                SizedBox(height: 12.h),
                _buildFilters(),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: _buildContent(adSlotState),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColors.primaryColor,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button and title
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    'Available Campaigns',
                    style: AppTexts.h3(color: Colors.white),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // Breadcrumb
              Row(
                children: [
                  Icon(Icons.home, color: Colors.white70, size: 16.sp),
                  SizedBox(width: 6.w),
                  Text(
                    'Home',
                    style: AppTexts.bodySmall(color: Colors.white70),
                  ),
                  SizedBox(width: 6.w),
                  Icon(Icons.chevron_right, color: Colors.white70, size: 16.sp),
                  SizedBox(width: 6.w),
                  Text(
                    'Available Campaigns',
                    style: AppTexts.bodySmall(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SearchBarWidget(
      controller: _searchController,
      hintText: 'Search campaigns...',
      enableAdSlotSearch: false,
      onSearch: () {
        final adSlotState = ref.read(adSlotProvider);
        if (adSlotState.data != null) {
          _applyFilters(adSlotState.data!);
        }
      },
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        // Category dropdown
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.grey300, width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCategory,
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: AppColors.grey600, size: 20.sp),
                style: AppTexts.bodySmall(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue ?? 'all';
                  });
                  final adSlotState = ref.read(adSlotProvider);
                  if (adSlotState.data != null) {
                    _applyFilters(adSlotState.data!);
                  }
                },
                items: _categories.map<DropdownMenuItem<String>>((cat) {
                  return DropdownMenuItem<String>(
                    value: cat['key'],
                    child: Text(cat['title']!),
                  );
                }).toList(),
              ),
            ),
          ),
        ),

        SizedBox(width: 12.w),

        // Sort dropdown
        Expanded(
          child: PopupMenuButton<String>(
            initialValue: _selectedSort,
            onSelected: (value) {
              setState(() {
                _selectedSort = value;
              });
              final adSlotState = ref.read(adSlotProvider);
              if (adSlotState.data != null) {
                _applyFilters(adSlotState.data!);
              }
            },
            offset: Offset(0, 50.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            itemBuilder: (context) => [
              _buildSortMenuItem('Recommended'),
              _buildSortMenuItem('Price: Low to High'),
              _buildSortMenuItem('Price: High to Low'),
              _buildSortMenuItem('Rating'),
            ],
            child: Container(
              height: 44.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.grey300, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sort, color: AppColors.textPrimary, size: 18.sp),
                  SizedBox(width: 6.w),
                  Flexible(
                    child: Text(
                      _selectedSort,
                      style: AppTexts.bodySmall(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: AppColors.grey400, size: 20.sp),
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
          color: _selectedSort == value
              ? AppColors.primaryColor
              : AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildContent(adSlotState) {
    if (adSlotState.isInitialLoading) {
      return _buildLoadingState();
    }

    if (adSlotState.message != null && !adSlotState.isDataAvailable) {
      return _buildErrorState(adSlotState.message!);
    }

    if ((adSlotState.data ?? []).isEmpty) {
      return _buildEmptyState();
    }

    // Show filtered campaigns if filters applied, otherwise show all
    final campaignsToShow = _filteredCampaigns.isEmpty && _selectedCategory == 'all' && _searchController.text.isEmpty && _selectedSort == 'Recommended'
        ? adSlotState.data ?? []
        : _filteredCampaigns;

    if (campaignsToShow.isEmpty && (_selectedCategory != 'all' || _searchController.text.isNotEmpty)) {
      return _buildNoResultsState();
    }

    return _buildCampaignsList(campaignsToShow);
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 3,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: SkeletonCampaignCard(width: double.infinity, height: 420.h),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 48.sp,
            color: AppColors.grey400,
          ),
          SizedBox(height: 16.h),
          Text('No campaigns found', style: AppTexts.h4()),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your filters',
            style: AppTexts.bodySmall(color: AppColors.grey600),
          ),
          SizedBox(height: 16.h),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedCategory = 'all';
                _selectedSort = 'Recommended';
                _searchController.clear();
              });
              final adSlotState = ref.read(adSlotProvider);
              if (adSlotState.data != null) {
                _applyFilters(adSlotState.data!);
              }
            },
            child: Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
            SizedBox(height: 16.h),
            Text('Failed to load campaigns', style: AppTexts.h4()),
            SizedBox(height: 8.h),
            Text(
              error,
              style: AppTexts.bodySmall(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () => ref
                  .read(adSlotProvider.notifier)
                  .loadAdSlots(refresh: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
              ),
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.campaign_outlined,
            size: 48.sp,
            color: AppColors.grey400,
          ),
          SizedBox(height: 16.h),
          Text('No campaigns available', style: AppTexts.h4()),
          SizedBox(height: 8.h),
          Text(
            'Check back later for new campaigns',
            style: AppTexts.bodySmall(color: AppColors.grey600),
          ),
        ],
      ),
    );
  }

  Widget _buildCampaignsList(List campaigns) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 80.h), // Added bottom padding
      itemCount: campaigns.length,
      itemBuilder: (context, index) {
        final adSlot = campaigns[index];
        return Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: AdSlotCard(
              sellerName: adSlot.sellerName,
              sellerType: adSlot.partnerType,
              campaignTitle: adSlot.title,
              category: adSlot.partnerType,
              subcategory: adSlot.contentTypes.isNotEmpty
                  ? adSlot.contentTypes.first
                  : 'General',
              features: adSlot.features,
              location: adSlot.location,
              reach: adSlot.audienceSize,
              price: adSlot.formattedPrice,
              sellerImage: adSlot.sellerAvatar,
              adSlotId: adSlot.id.toString(),
              onViewSlot: () {
                context.push('/ad-slot-details/${adSlot.id}', extra: adSlot);
              },
            ),
          ),
        );
      },
    );
  }
}
