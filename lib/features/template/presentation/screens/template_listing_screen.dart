import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../widgets/template_card.dart';
import '../widgets/template_added_sheet.dart';
import '../../logic/template_notifier.dart';

class TemplateListingScreen extends ConsumerStatefulWidget {
  const TemplateListingScreen({super.key});

  @override
  ConsumerState<TemplateListingScreen> createState() =>
      _TemplateListingScreenState();
}

class _TemplateListingScreenState extends ConsumerState<TemplateListingScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = 'All Types';
  String _selectedPriceFilter = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List _getFilteredTemplates(List templates) {
    var filtered = List.from(templates);

    if (_selectedType != 'All Types') {
      filtered = filtered.where((t) => t.type == _selectedType).toList();
    }

    if (_selectedPriceFilter == 'Free') {
      filtered = filtered.where((t) => t.isFree).toList();
    } else if (_selectedPriceFilter == 'Paid') {
      filtered = filtered.where((t) => !t.isFree).toList();
    }

    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((t) {
        return t.title.toLowerCase().contains(query) ||
            t.description.toLowerCase().contains(query) ||
            t.tags.toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final templateState = ref.watch(templateProvider);
    final dataState = templateState.asData?.value;
    final templates = dataState?.data ?? [];
    final filteredTemplates = _getFilteredTemplates(templates);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Design Templates',
          style: AppTexts.h3(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Filter bar
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search templates...',
                    hintStyle: AppTexts.bodyMedium(color: AppColors.grey400),
                    prefixIcon: Icon(Icons.search, color: AppColors.grey400),
                    filled: true,
                    fillColor: AppColors.grey100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // Type filters
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildTypeFilter('All Types'),
                            SizedBox(width: 8.w),
                            _buildTypeFilter('CANVA'),
                            SizedBox(width: 8.w),
                            _buildTypeFilter('PSD'),
                            SizedBox(width: 8.w),
                            _buildTypeFilter('AI'),
                            SizedBox(width: 8.w),
                            _buildTypeFilter('AE'),
                            SizedBox(width: 8.w),
                            _buildTypeFilter('PDF'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // Price filters and count
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildPriceFilter('All'),
                        SizedBox(width: 8.w),
                        _buildPriceFilter('Free'),
                        SizedBox(width: 8.w),
                        _buildPriceFilter('Paid'),
                      ],
                    ),
                    Text(
                      '${filteredTemplates.length} Templates',
                      style: AppTexts.bodyMedium(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref
                  .read(templateProvider.notifier)
                  .fetchTemplates(page: 0, size: 20),
              child: templateState.when(
                loading: _buildLoadingState,
                error: (error, _) => _buildErrorState(error.toString()),
                data: (state) {
                  if (state.message != null && !state.isDataAvailable) {
                    return _buildErrorState(state.message!);
                  }

                  if (filteredTemplates.isEmpty) {
                    return _buildEmptyState();
                  }

                  return _buildTemplateGrid(filteredTemplates);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeFilter(String type) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.grey300,
          ),
        ),
        child: Text(
          type,
          style: AppTexts.bodyMedium(
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildPriceFilter(String filter) {
    final isSelected = _selectedPriceFilter == filter;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPriceFilter = filter;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.grey300,
          ),
        ),
        child: Text(
          filter,
          style: AppTexts.bodyMedium(
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.75,
      ),
      itemCount: 4,
      itemBuilder: (context, index) =>
          SkeletonCard(width: double.infinity, height: 400.h),
    );
  }

  Widget _buildErrorState(String error) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: 500.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
              SizedBox(height: 16.h),
              Text('Error loading templates', style: AppTexts.h4()),
              SizedBox(height: 8.h),
              Text(error, style: AppTexts.bodySmall(color: AppColors.grey600)),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () => ref
                    .read(templateProvider.notifier)
                    .fetchTemplates(page: 0, size: 20),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: 500.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.design_services_outlined,
                size: 64.sp,
                color: AppColors.grey400,
              ),
              SizedBox(height: 16.h),
              Text('No templates found', style: AppTexts.h4()),
              SizedBox(height: 8.h),
              Text(
                'Try adjusting your filters',
                style: AppTexts.bodySmall(color: AppColors.grey600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateGrid(List templates) {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(
        16.w,
        16.h,
        16.w,
        80.h,
      ), // Added bottom padding
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.75,
      ),
      itemCount: templates.length,
      itemBuilder: (context, index) {
        final template = templates[index];
        return TemplateCard(
          imageUrl: template.thumbnailUrl,
          badge: template.type,
          title: template.title,
          description: template.cleanDescription,
          tags: template.tagsList,
          price: template.formattedPrice,
          originalPrice: template.formattedOriginalPrice,
          discount: template.formattedDiscount,
          buttonText: template.isFree ? 'Use Template' : 'Buy Now',
          isFree: template.isFree,
          onTap: () => _handleTemplateClick(context, template),
        );
      },
    );
  }

  Future<void> _handleTemplateClick(
    BuildContext context,
    dynamic template,
  ) async {
    // Navigate to template details screen
    context.push('/template-details/${template.id}', extra: template);
  }
}
