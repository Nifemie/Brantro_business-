import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../../home/presentation/widgets/search_bar_widget.dart';
import '../../../home/presentation/widgets/creative_card.dart';
import '../../../cart/presentation/widgets/add_to_campaign_sheet.dart';
import '../../../cart/data/models/cart_item_model.dart';
import '../../logic/creatives_notifier.dart';
import '../../../../core/widgets/skeleton_loading.dart';

class CreativesListingScreen extends ConsumerStatefulWidget {
  const CreativesListingScreen({super.key});

  @override
  ConsumerState<CreativesListingScreen> createState() => _CreativesListingScreenState();
}

class _CreativesListingScreenState extends ConsumerState<CreativesListingScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCreativeType;
  String? _selectedFormat;
  String _selectedSort = 'Recommended';
  List _filteredCreatives = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(creativesProvider.notifier).fetchCreatives(page: 0, size: 20);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters(List creatives) {
    var filtered = List.from(creatives);

    // Filter by creative type
    if (_selectedCreativeType != null) {
      filtered = filtered.where((c) => c.type == _selectedCreativeType).toList();
    }

    // Filter by format
    if (_selectedFormat != null) {
      filtered = filtered.where((c) => c.format == _selectedFormat).toList();
    }

    // Filter by search
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((c) {
        final title = c.title.toLowerCase();
        final description = c.description.toLowerCase();
        return title.contains(query) || description.contains(query);
      }).toList();
    }

    // Apply sorting
    switch (_selectedSort) {
      case 'Price: Low to High':
        filtered.sort((a, b) {
          final priceA = double.tryParse(a.price) ?? 0;
          final priceB = double.tryParse(b.price) ?? 0;
          return priceA.compareTo(priceB);
        });
        break;
      case 'Price: High to Low':
        filtered.sort((a, b) {
          final priceA = double.tryParse(a.price) ?? 0;
          final priceB = double.tryParse(b.price) ?? 0;
          return priceB.compareTo(priceA);
        });
        break;
      case 'Most Popular':
        filtered.sort((a, b) => b.downloads.compareTo(a.downloads));
        break;
      case 'Highest Rated':
        filtered.sort((a, b) => b.averageRating.compareTo(a.averageRating));
        break;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _filteredCreatives = filtered;
        });
      }
    });
  }

  double _extractPrice(String priceStr) {
    return double.tryParse(priceStr.replaceAll(RegExp(r'[₦,]'), '')) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final creativesState = ref.watch(creativesProvider);

    // Apply filters whenever data changes
    if (creativesState.data != null && creativesState.data!.isNotEmpty) {
      _applyFilters(creativesState.data!);
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Column(
        children: [
          _buildHeader(),
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              children: [
                _buildSearchBar(),
                SizedBox(height: 16.h),
                _buildFilterRow(),
              ],
            ),
          ),
          Expanded(child: _buildContent()),
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
          child: Row(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Creatives', style: AppTexts.h3(color: Colors.white)),
                    SizedBox(height: 4.h),
                    Text(
                      'Browse all creative templates',
                      style: AppTexts.bodySmall(color: Colors.white70),
                    ),
                  ],
                ),
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
      hintText: 'Search creatives',
      enableAdSlotSearch: false,
      onSearch: () {
        final creativesState = ref.read(creativesProvider);
        if (creativesState.data != null) {
          _applyFilters(creativesState.data!);
        }
      },
    );
  }

  Widget _buildFilterRow() {
    return Row(
      children: [
        Expanded(child: _buildCreativeTypeDropdown()),
        SizedBox(width: 12.w),
        Expanded(child: _buildFormatDropdown()),
        SizedBox(width: 12.w),
        Expanded(child: _buildSortDropdown()),
      ],
    );
  }

  Widget _buildCreativeTypeDropdown() {
    return PopupMenuButton<String>(
      initialValue: _selectedCreativeType,
      onSelected: (value) {
        setState(() {
          _selectedCreativeType = value;
        });
        final creativesState = ref.read(creativesProvider);
        if (creativesState.data != null) {
          _applyFilters(creativesState.data!);
        }
      },
      offset: Offset(0, 50.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      itemBuilder: (context) => [
        PopupMenuItem(value: null, child: Text('All Types', style: AppTexts.bodyMedium())),
        ...[
          'Image',
          'Video',
          'Animation',
          'HTML5 Interactive',
          'Text / Copy',
          'Audio',
          'Carousel',
          'Story / Vertical',
        ].map((type) => PopupMenuItem(
              value: type,
              child: Text(type, style: AppTexts.bodyMedium()),
            )),
      ],
      child: Container(
        height: 44.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: _selectedCreativeType != null
                ? AppColors.primaryColor
                : AppColors.grey300,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _selectedCreativeType ?? 'Type',
                style: AppTexts.bodySmall(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.arrow_drop_down, color: AppColors.grey400, size: 20.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatDropdown() {
    return PopupMenuButton<String>(
      initialValue: _selectedFormat,
      onSelected: (value) {
        setState(() {
          _selectedFormat = value;
        });
        final creativesState = ref.read(creativesProvider);
        if (creativesState.data != null) {
          _applyFilters(creativesState.data!);
        }
      },
      offset: Offset(0, 50.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      itemBuilder: (context) => [
        PopupMenuItem(value: null, child: Text('All Formats', style: AppTexts.bodyMedium())),
        ...[
          'Standard',
          'Fullscreen',
          'Portrait (Vertical)',
          'Landscape (Horizontal)',
          'Square',
          'Custom Size',
        ].map((format) => PopupMenuItem(
              value: format,
              child: Text(format, style: AppTexts.bodyMedium()),
            )),
      ],
      child: Container(
        height: 44.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: _selectedFormat != null
                ? AppColors.primaryColor
                : AppColors.grey300,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _selectedFormat ?? 'Format',
                style: AppTexts.bodySmall(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.arrow_drop_down, color: AppColors.grey400, size: 20.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return PopupMenuButton<String>(
      initialValue: _selectedSort,
      onSelected: (value) {
        setState(() {
          _selectedSort = value;
        });
        final creativesState = ref.read(creativesProvider);
        if (creativesState.data != null) {
          _applyFilters(creativesState.data!);
        }
      },
      offset: Offset(0, 50.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      itemBuilder: (context) => [
        'Recommended',
        'Price: Low to High',
        'Price: High to Low',
        'Most Popular',
        'Highest Rated',
      ]
          .map((sort) => PopupMenuItem(
                value: sort,
                child: Text(sort, style: AppTexts.bodyMedium()),
              ))
          .toList(),
      child: Container(
        height: 44.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.grey300),
        ),
        child: Row(
          children: [
            Icon(Icons.sort, color: AppColors.textPrimary, size: 16.sp),
            SizedBox(width: 4.w),
            Expanded(
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
    );
  }

  Widget _buildContent() {
    final creativesState = ref.watch(creativesProvider);

    if (creativesState.isInitialLoading) {
      return _buildLoadingState();
    }

    if (creativesState.message != null && !creativesState.isDataAvailable) {
      return _buildErrorState(creativesState.message!);
    }

    if ((creativesState.data ?? []).isEmpty) {
      return _buildEmptyState();
    }

    final creativesToShow = _filteredCreatives.isEmpty &&
            _selectedCreativeType == null &&
            _selectedFormat == null &&
            _selectedSort == 'Recommended'
        ? creativesState.data ?? []
        : _filteredCreatives;

    if (creativesToShow.isEmpty) {
      return _buildNoResultsState();
    }

    return SingleChildScrollView(
      child: SizedBox(
        height: 520.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(16.w),
          itemCount: creativesToShow.length,
          itemBuilder: (context, index) {
            final creative = creativesToShow[index];
            return Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: SizedBox(
                width: 320.w,
                child: CreativeCard(
                  title: creative.title,
                  description: creative.description,
                  fileSize: creative.fileSizeFormatted,
                  dimensions: creative.dimensionsFormatted,
                  formats: List<String>.from(creative.fileFormat.map((f) => f.toString().toUpperCase())),
                  downloads: creative.downloads,
                  rating: creative.averageRating,
                  price: creative.formattedPrice,
                  imageUrl: creative.thumbnail,
                  tags: <String>[creative.type, creative.format],
                  onViewDetails: () {
                    context.push('/creative-details/${creative.id}');
                  },
                  onBuy: () {
                    final cartItem = CartItem(
                      id: creative.id.toString(),
                      type: 'creative',
                      title: creative.title,
                      description: creative.description,
                      price: creative.formattedPrice,
                      imageUrl: creative.thumbnail,
                      sellerName: creative.owner?.name ?? 'Brantro Africa',
                      sellerType: creative.type,
                      metadata: {
                        'fileSize': creative.fileSizeFormatted,
                        'dimensions': creative.dimensionsFormatted,
                        'formats': creative.fileFormat,
                        'downloads': creative.downloads,
                        'rating': creative.averageRating,
                        'tags': creative.tagsList,
                      },
                    );
                    AddToCampaignSheet.show(context, cartItem);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.all(16.w),
      itemCount: 3,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(right: 16.w),
        child: SkeletonCard(width: 320.w, height: 520.h),
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
            Text('Failed to load creatives', style: AppTexts.h4()),
            SizedBox(height: 8.h),
            Text(
              error,
              style: AppTexts.bodySmall(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () => ref
                  .read(creativesProvider.notifier)
                  .fetchCreatives(page: 0, size: 20),
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
          Icon(Icons.design_services_outlined, size: 48.sp, color: AppColors.grey400),
          SizedBox(height: 16.h),
          Text('No creatives available', style: AppTexts.h4()),
          SizedBox(height: 8.h),
          Text(
            'Check back later for new creatives',
            style: AppTexts.bodySmall(color: AppColors.grey600),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 48.sp, color: AppColors.grey400),
          SizedBox(height: 16.h),
          Text('No creatives found', style: AppTexts.h4()),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your filters',
            style: AppTexts.bodySmall(color: AppColors.grey600),
          ),
          SizedBox(height: 16.h),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedCreativeType = null;
                _selectedFormat = null;
                _searchController.clear();
              });
              final creativesState = ref.read(creativesProvider);
              if (creativesState.data != null) {
                _applyFilters(creativesState.data!);
              }
            },
            child: Text('Clear Filters'),
          ),
        ],
      ),
    );
  }
}
