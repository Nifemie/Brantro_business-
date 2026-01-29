import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../../home/presentation/widgets/search_bar_widget.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../../logic/vetting_notifier.dart';
import '../widgets/vetting_card.dart';

class VettingListingScreen extends ConsumerStatefulWidget {
  const VettingListingScreen({super.key});

  @override
  ConsumerState<VettingListingScreen> createState() => _VettingListingScreenState();
}

class _VettingListingScreenState extends ConsumerState<VettingListingScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedVettingType;
  final ScrollController _scrollController = ScrollController();
  List _filteredVettings = [];

  // Vetting types for dropdown
  final List<Map<String, String>> _vettingTypes = [
    {'title': 'All Vetting Options', 'key': 'all'},
    {'title': 'Ultra Priority (≤ 48 Hours)', 'key': 'ultra'},
    {'title': 'Super Express (≤ 72 Hours)', 'key': 'super'},
    {'title': 'Express (≤ 5 Days)', 'key': 'express'},
    {'title': 'Accelerated (≤ 7 Days)', 'key': 'accelerated'},
    {'title': 'Standard (≤ 14 Days)', 'key': 'standard'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedVettingType = 'all';
    Future.microtask(() {
      ref.read(vettingProvider.notifier).fetchVettingOptions(page: 0, size: 20);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _applyFilters(List vettings) {
    var filtered = List.from(vettings);

    // Apply vetting type filter
    if (_selectedVettingType != null && _selectedVettingType != 'all') {
      filtered = filtered.where((v) {
        final title = v.title.toString().toLowerCase();
        final filterType = _selectedVettingType!.toLowerCase();
        return title.contains(filterType);
      }).toList();
    }

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((v) {
        return v.title.toLowerCase().contains(query) ||
            v.description.toLowerCase().contains(query);
      }).toList();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _filteredVettings = filtered;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vettingState = ref.watch(vettingProvider);

    // Apply filters whenever data changes
    if (vettingState.data != null && vettingState.data!.isNotEmpty) {
      _applyFilters(vettingState.data!);
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Column(
        children: [
          // Header with breadcrumb
          _buildHeader(),

          // Search and filter
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              children: [
                _buildSearchBar(),
                SizedBox(height: 12.h),
                _buildFilterDropdown(),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: _buildContent(vettingState),
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
                    'Campaign Vetting',
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
                    'Campaign Vetting',
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
      hintText: 'Searching...',
      enableAdSlotSearch: false,
      onSearch: () {
        final vettingState = ref.read(vettingProvider);
        if (vettingState.data != null) {
          _applyFilters(vettingState.data!);
        }
      },
    );
  }

  Widget _buildFilterDropdown() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.grey300, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedVettingType,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: AppColors.grey600),
          style: AppTexts.bodyMedium(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedVettingType = newValue;
            });
            final vettingState = ref.read(vettingProvider);
            if (vettingState.data != null) {
              _applyFilters(vettingState.data!);
            }
          },
          items: _vettingTypes.map<DropdownMenuItem<String>>((type) {
            return DropdownMenuItem<String>(
              value: type['key'],
              child: Text(type['title']!),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildContent(vettingState) {
    if (vettingState.isInitialLoading) {
      return _buildLoadingState();
    }

    if (vettingState.message != null && !vettingState.isDataAvailable) {
      return _buildErrorState(vettingState.message!);
    }

    if ((vettingState.data ?? []).isEmpty) {
      return _buildEmptyState();
    }

    // Show filtered vettings if filters applied, otherwise show all
    final vettingsToShow = _filteredVettings.isEmpty && _selectedVettingType == 'all' && _searchController.text.isEmpty
        ? vettingState.data ?? []
        : _filteredVettings;

    if (vettingsToShow.isEmpty && (_selectedVettingType != 'all' || _searchController.text.isNotEmpty)) {
      return _buildNoResultsState();
    }

    return _buildVettingsList(vettingsToShow);
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 3,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: SkeletonCard(width: double.infinity, height: 420.h),
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
          Text('No vetting options found', style: AppTexts.h4()),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your filters',
            style: AppTexts.bodySmall(color: AppColors.grey600),
          ),
          SizedBox(height: 16.h),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedVettingType = 'all';
                _searchController.clear();
              });
              final vettingState = ref.read(vettingProvider);
              if (vettingState.data != null) {
                _applyFilters(vettingState.data!);
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
            Text('Failed to load vetting options', style: AppTexts.h4()),
            SizedBox(height: 8.h),
            Text(
              error,
              style: AppTexts.bodySmall(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () => ref
                  .read(vettingProvider.notifier)
                  .fetchVettingOptions(page: 0, size: 20),
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
            Icons.verified_outlined,
            size: 48.sp,
            color: AppColors.grey400,
          ),
          SizedBox(height: 16.h),
          Text('No vetting options available', style: AppTexts.h4()),
          SizedBox(height: 8.h),
          Text(
            'Check back later for vetting services',
            style: AppTexts.bodySmall(color: AppColors.grey600),
          ),
        ],
      ),
    );
  }

  Widget _buildVettingsList(List vettings) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 80.h), // Added bottom padding
      itemCount: vettings.length,
      itemBuilder: (context, index) {
        final option = vettings[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: VettingCard(
            title: option.title,
            description: option.description,
            duration: option.durationDisplay,
            useCase: option.note,
            price: option.formattedPrice,
            status: option.status,
            onSelectTap: () {
              context.pushNamed(
                'vetting-details',
                pathParameters: {'vettingId': option.id.toString()},
                extra: option,
              );
            },
          ),
        );
      },
    );
  }
}
