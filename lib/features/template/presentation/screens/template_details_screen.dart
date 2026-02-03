import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../logic/template_details_notifier.dart';
import '../../data/models/template_model.dart';
import '../widgets/template_added_sheet.dart';

class TemplateDetailsScreen extends ConsumerStatefulWidget {
  final String templateId;
  final TemplateModel? initialData;
  final bool isPurchased;

  const TemplateDetailsScreen({
    super.key,
    required this.templateId,
    this.initialData,
    this.isPurchased = false,
  });

  @override
  ConsumerState<TemplateDetailsScreen> createState() => _TemplateDetailsScreenState();
}

class _TemplateDetailsScreenState extends ConsumerState<TemplateDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Fetch data when screen initializes
    Future.microtask(() {
      ref.read(templateDetailsProvider(widget.templateId).notifier)
         .fetchTemplateDetails(widget.templateId, initialData: widget.initialData);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(templateDetailsProvider(widget.templateId));
    final template = state.singleData;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: state.isInitialLoading && template == null
          ? _buildLoadingState()
          : state.message != null && template == null
              ? _buildErrorState(state.message!)
              : template != null
                  ? _buildContent(template)
                  : _buildLoadingState(), // Fallback to loading if template is null
    );
  }

  Widget _buildLoadingState() {
     return Scaffold(
        appBar: AppBar(backgroundColor: AppColors.primaryColor),
        body: Center(child: CircularProgressIndicator()),
     );
  }

  Widget _buildErrorState(String message) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.primaryColor),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
            SizedBox(height: 16.h),
            Text(message, style: AppTexts.h4(), textAlign: TextAlign.center),
            SizedBox(height: 16.h),
             ElevatedButton(
              onPressed: () {
                 ref.read(templateDetailsProvider(widget.templateId).notifier)
                    .fetchTemplateDetails(widget.templateId);
              },
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(TemplateModel template) {
    return CustomScrollView(
        slivers: [
          // Cover Image & Header
          SliverAppBar(
            expandedHeight: 250.h,
            pinned: true,
            backgroundColor: AppColors.primaryColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.bookmark_border, color: Colors.white),
                onPressed: () {
                  // TODO: Save template
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Template Image
                  (template.thumbnail.isNotEmpty && template.thumbnail.startsWith('http'))
                      ? Image.network(
                          template.thumbnail,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.grey300,
                            );
                          },
                        )
                      : Container(
                          color: AppColors.grey300,
                        ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  // Badge
                  Positioned(
                    top: 60.h,
                    left: 16.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        template.type.toUpperCase(),
                        style: AppTexts.labelSmall(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Template Content
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),

                  // Title & Rating
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          template.title,
                          style: AppTexts.h2(),
                        ),
                        SizedBox(height: 8.h),
                        _buildRating(template),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Price & Downloads
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            Icons.payments_outlined,
                            'Price',
                            template.formattedPrice,
                            AppColors.success,
                            discount: template.formattedDiscount,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildInfoCard(
                            Icons.download_outlined,
                            'Downloads',
                            '${template.downloads}',
                            AppColors.info,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Category Info (instead of provider)
                  _buildCategorySection(template),

                  SizedBox(height: 20.h),

                  // Tags
                  if (template.tags.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tags', style: AppTexts.h4()),
                          SizedBox(height: 8.h),
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: template.tagsList
                                .map((tag) => _buildTagChip(tag))
                                .toList(),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),

                  // Action Buttons
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        if (!template.isFree && !widget.isPurchased) ...[
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // TODO: Add to favorites
                              },
                              icon: Icon(Icons.favorite_border, size: 18.sp),
                              label: Text('Save'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primaryColor,
                                side: BorderSide(color: AppColors.primaryColor),
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                        ],
                        Expanded(
                          flex: (template.isFree || widget.isPurchased) ? 1 : 2,
                          child: ElevatedButton.icon(
                            onPressed: () => _handleAction(template),
                            icon: Icon(
                              (template.isFree || widget.isPurchased) 
                                  ? Icons.download 
                                  : Icons.shopping_cart_outlined,
                              size: 18.sp,
                            ),
                            label: Text(
                              (template.isFree || widget.isPurchased) 
                                  ? 'Download Template' 
                                  : 'Buy Now'
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.isPurchased 
                                  ? Colors.green 
                                  : AppColors.primaryColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Tabs
                  Container(
                    color: Colors.white,
                    child: TabBar(
                      controller: _tabController,
                      labelColor: AppColors.primaryColor,
                      unselectedLabelColor: AppColors.grey600,
                      indicatorColor: AppColors.primaryColor,
                      tabs: [
                        Tab(text: 'Details'),
                        Tab(text: 'Info'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tab Content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDetailsTab(template),
                _buildInfoTab(template),
              ],
            ),
          ),
        ],
      );
  }

  Widget _buildRating(TemplateModel template) {
    return Row(
      children: [
        Icon(Icons.star, color: AppColors.warning, size: 20.sp),
        SizedBox(width: 4.w),
        Text(
          template.averageRating.toStringAsFixed(1),
          style: AppTexts.h4(),
        ),
        SizedBox(width: 4.w),
        Text(
          '(${template.totalLikes} likes)',
          style: AppTexts.bodySmall(color: AppColors.grey600),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
      IconData icon, String label, String value, Color color, {String? discount}) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.sp, color: color),
          SizedBox(height: 8.h),
          Text(label, style: AppTexts.bodySmall(color: AppColors.grey600)),
          SizedBox(height: 2.h),
          Text(value, style: AppTexts.h4()),
          if (discount != null) ...[
            SizedBox(height: 2.h),
            Text(discount, style: AppTexts.bodySmall(color: AppColors.success)),
          ],
        ],
      ),
    );
  }

  Widget _buildCategorySection(TemplateModel template) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Category', style: AppTexts.h4()),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.grey200),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.category_outlined,
                    color: AppColors.primaryColor,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Template Category',
                        style: AppTexts.bodyMedium(
                          color: AppColors.textPrimary,
                        ).copyWith(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        template.type,
                        style: AppTexts.bodySmall(color: AppColors.grey600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagChip(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Text(
        tag,
        style: AppTexts.bodySmall(color: AppColors.grey700),
      ),
    );
  }

  Widget _buildDetailsTab(TemplateModel template) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description', style: AppTexts.h4()),
            SizedBox(height: 12.h),
            Text(
              template.description,
              style: AppTexts.bodyMedium(color: AppColors.grey700),
            ),
            SizedBox(height: 24.h),
            Text('File Information', style: AppTexts.h4()),
            SizedBox(height: 12.h),
            _buildFileInfoItem('File Type', template.type),
            if (template.fileUrl != null && template.fileUrl!.isNotEmpty)
              _buildFileInfoItem('File Available', 'Yes'),
            if (template.designUrl != null && template.designUrl!.isNotEmpty)
              _buildFileInfoItem('Design Link', 'Available'),
            _buildFileInfoItem('Status', template.status),
          ],
        ),
      ),
    );
  }

  Widget _buildFileInfoItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTexts.bodyMedium(color: AppColors.grey600),
          ),
          Text(
            value,
            style: AppTexts.bodyMedium(color: AppColors.textPrimary)
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTab(TemplateModel template) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Statistics', style: AppTexts.h4()),
            SizedBox(height: 16.h),
            _buildStatCard(
              Icons.download_outlined,
              'Total Downloads',
              '${template.downloads}',
              AppColors.info,
            ),
            SizedBox(height: 12.h),
            _buildStatCard(
              Icons.star_outline,
              'Average Rating',
              template.averageRating.toStringAsFixed(1),
              AppColors.warning,
            ),
            SizedBox(height: 12.h),
            _buildStatCard(
              Icons.favorite_outline,
              'Total Likes',
              '${template.totalLikes}',
              Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTexts.bodySmall(color: AppColors.grey600)),
                SizedBox(height: 4.h),
                Text(value, style: AppTexts.h3()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleAction(TemplateModel template) async {
    if (template.isFree || widget.isPurchased) {
      await _downloadTemplate(template);
    } else {
      if (mounted) {
        TemplateAddedSheet.show(context, template);
      }
    }
  }

  Future<void> _downloadTemplate(TemplateModel template) async {
    final url = template.designUrl ?? template.fileUrl;
    
    if (url != null && url.isNotEmpty) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not open template link'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Template download link not available'),
            backgroundColor: AppColors.grey600,
          ),
        );
      }
    }
  }
}
