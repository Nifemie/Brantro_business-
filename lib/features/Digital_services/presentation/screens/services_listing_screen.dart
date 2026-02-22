import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../../../controllers/re_useable/filter_bottom_sheet.dart';
import '../../../home/presentation/widgets/search_bar_widget.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../../../../core/data/data_state.dart';
import '../../logic/services_notifier.dart';
import '../../data/models/service_model.dart';
import '../widgets/service_card.dart';

class ServicesListingScreen extends ConsumerStatefulWidget {
  final String? serviceType;

  const ServicesListingScreen({super.key, this.serviceType});

  @override
  ConsumerState<ServicesListingScreen> createState() =>
      _ServicesListingScreenState();
}

class _ServicesListingScreenState extends ConsumerState<ServicesListingScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSort = 'Recommended';
  String? _selectedServiceType;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      ref.read(servicesProvider.notifier).loadMore();
    }
  }

  List<ServiceModel> _getProcessedServices(List<ServiceModel> services) {
    var filtered = List<ServiceModel>.from(services);

    // Apply service type filter (match by title)
    if (_selectedServiceType != null) {
      final filterType = _selectedServiceType!.toLowerCase();
      filtered = filtered.where((s) {
        final title = s.title.toLowerCase();
        return title.contains(filterType) || filterType.contains(title);
      }).toList();
    }

    // Apply sorting
    switch (_selectedSort) {
      case 'Price: Low to High':
        filtered.sort(
          (a, b) => (double.tryParse(a.price) ?? 0).compareTo(
            double.tryParse(b.price) ?? 0,
          ),
        );
        break;
      case 'Price: High to Low':
        filtered.sort(
          (a, b) => (double.tryParse(b.price) ?? 0).compareTo(
            double.tryParse(a.price) ?? 0,
          ),
        );
        break;
      case 'Most Popular':
        filtered.sort((a, b) => b.totalLikes.compareTo(a.totalLikes));
        break;
      case 'Newest':
        filtered.sort((a, b) => b.id.compareTo(a.id));
        break;
      case 'Recommended':
      default:
        // Keep original order
        break;
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final servicesState = ref.watch(servicesProvider);
    final servicesData = servicesState.asData?.value;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Column(
        children: [
          // Header
          _buildHeader(),

          // Search and filters
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              children: [
                _buildSearchBar(),
                SizedBox(height: 16.h),
                _buildFilterSortRow(),
              ],
            ),
          ),

          // Services grid
          Expanded(child: _buildContent(servicesState)),
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
                    Text(
                      'Digital Services',
                      style: AppTexts.h3(color: Colors.white),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Browse all available services',
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
      hintText: 'Search services',
      enableAdSlotSearch: false,
      onSearch: () {
        if (_searchController.text.isNotEmpty) {
          ref
              .read(servicesProvider.notifier)
              .searchServices(query: _searchController.text);
        }
      },
    );
  }

  Widget _buildFilterSortRow() {
    final hasFilters = _selectedServiceType != null;

    return Row(
      children: [
        // Filter button
        Expanded(
          child: GestureDetector(
            onTap: () {
              _showServiceTypeFilter();
            },
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: hasFilters
                      ? AppColors.primaryColor
                      : AppColors.grey300,
                  width: 1,
                ),
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
            initialValue: _selectedSort,
            onSelected: (value) {
              setState(() {
                _selectedSort = value;
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
              _buildSortMenuItem('Most Popular'),
              _buildSortMenuItem('Newest'),
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
                      _selectedSort,
                      style: AppTexts.bodyMedium(),
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

  void _showServiceTypeFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.grey300,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Filter by Service Type', style: AppTexts.h3()),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedServiceType = null;
                        });
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Clear',
                        style: AppTexts.bodyMedium(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 8.h),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Design Services
                      _buildCategorySection('Design Services', [
                        'Logo Design',
                        'Brand Identity Design',
                        'Brand Guidelines',
                        'Banner Design',
                        'Flyer Design',
                        'Poster Design',
                        'UI / UX Design',
                        'Packaging Design',
                        'Print Design',
                      ]),

                      SizedBox(height: 20.h),

                      // Content & Writing
                      _buildCategorySection('Content & Writing', [
                        'Caption Writing',
                      ]),

                      SizedBox(height: 20.h),

                      // Video Services
                      _buildCategorySection('Video Services', [
                        'Video Advertisement',
                        'Video Editing',
                        'Motion Graphics',
                        'Animated Advertisement',
                        'Short-Form Video (Reels / TikTok)',
                        'Long-Form Video',
                        'Explainer Video',
                      ]),

                      SizedBox(height: 20.h),

                      // UGC Content
                      _buildCategorySection('UGC Content', [
                        'UGC Video',
                        'UGC Photo',
                        'Product Review',
                        'Testimonial Video',
                        'Lifestyle Content',
                        'Unboxing Video',
                      ]),

                      SizedBox(height: 20.h),

                      // Audio Services
                      _buildCategorySection('Audio Services', [
                        'Voice-Over Recording',
                        'Audio Advertisement',
                        'Jingle Production',
                        'Sound Design',
                      ]),

                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(String title, List<String> types) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTexts.h4(color: AppColors.textPrimary)),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: types.map((type) {
            final isSelected = _selectedServiceType == type;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedServiceType = isSelected ? null : type;
                });
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryColor : Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.grey300,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  type,
                  style: AppTexts.bodySmall(
                    color: isSelected ? Colors.white : AppColors.grey600,
                  ),
                ),
              ),
            );
          }).toList(),
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

  Widget _buildContent(AsyncValue<DataState<ServiceModel>> servicesState) {
    return servicesState.when(
      loading: _buildLoadingState,
      error: (error, _) => _buildErrorState(error.toString()),
      data: (state) {
        if (state.message != null && !state.isDataAvailable) {
          return _buildErrorState(state.message!);
        }

        if ((state.data ?? []).isEmpty) {
          return _buildEmptyState();
        }

        // Show filtered services if filters/sort applied, otherwise show all
        final servicesToShow = _getProcessedServices(state.data ?? []);

        if (servicesToShow.isEmpty && _selectedServiceType != null) {
          return _buildNoResultsState();
        }

        return _buildServicesGrid(servicesToShow);
      },
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 48.sp, color: AppColors.grey400),
          SizedBox(height: 16.h),
          Text('No services found', style: AppTexts.h4()),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your filters',
            style: AppTexts.bodySmall(color: AppColors.grey600),
          ),
          SizedBox(height: 16.h),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedServiceType = null;
              });
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
            Text('Failed to load services', style: AppTexts.h4()),
            SizedBox(height: 8.h),
            Text(
              error,
              style: AppTexts.bodySmall(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () => ref
                  .read(servicesProvider.notifier)
                  .fetchServices(page: 0, size: 20),
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
            Icons.design_services_outlined,
            size: 48.sp,
            color: AppColors.grey400,
          ),
          SizedBox(height: 16.h),
          Text('No services available', style: AppTexts.h4()),
          SizedBox(height: 8.h),
          Text(
            'Check back later for new services',
            style: AppTexts.bodySmall(color: AppColors.grey600),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 6,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: SkeletonCard(width: double.infinity, height: 350.h),
      ),
    );
  }

  Widget _buildServicesGrid(List services) {
    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.all(16.w),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        final isLastItem = index == services.length - 1;
        
        return Padding(
          padding: EdgeInsets.only(
            bottom: isLastItem ? 80.h : 16.h, // Extra padding for last item
          ),
          child: SizedBox(
            child: ServiceCard(
              service: {
                'id': service.id,
                'imageUrl': service.thumbnailUrl,
                'badge': service.typeBadge,
                'rating': service.averageRating,
                'reviewCount': service.totalLikes,
                'title': service.title,
                'description': service.description.replaceAll(
                  RegExp(r'<[^>]*>'),
                  '',
                ), // Strip HTML tags
                'duration': '${service.deliveryDays} days',
                'tags': service.tags,
                'price': service.formattedPrice,
                'provider': service.createdBy?.name ?? 'Brantro Africa',
              },
              onViewDetails: () {
                // Pass ID and optional initial data for smooth transition
                context.push('/service-details/${service.id}', extra: service);
              },
            ),
          ),
        );
      },
    );
  }
}
