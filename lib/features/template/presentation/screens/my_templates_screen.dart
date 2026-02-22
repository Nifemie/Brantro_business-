import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../../../home/presentation/widgets/search_bar_widget.dart';
import '../../logic/purchased_templates_notifier.dart';
import '../widgets/purchased_template_card.dart';

class MyTemplatesScreen extends ConsumerStatefulWidget {
  const MyTemplatesScreen({super.key});

  @override
  ConsumerState<MyTemplatesScreen> createState() => _MyTemplatesScreenState();
}

class _MyTemplatesScreenState extends ConsumerState<MyTemplatesScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      ref.read(purchasedTemplatesProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final templatesState = ref.watch(purchasedTemplatesProvider);

    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'My Templates',
          style: AppTexts.h3(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined, color: Colors.white),
            onPressed: () => context.go('/home'),
            tooltip: 'Go to Home',
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              ref.read(purchasedTemplatesProvider.notifier).refresh();
            },
            tooltip: 'Refresh',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70.h),
          child: Container(
            color: AppColors.primaryColor,
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            child: SearchBarWidget(
              hintText: 'Search templates...',
              controller: _searchController,
              iconColor: AppColors.primaryColor,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
        ),
      ),
      body: templatesState.when(
        data: (payload) {
          if (payload == null || payload.page.isEmpty) {
            return _buildEmptyState();
          }

          // Filter templates based on search query
          final filteredOrders = _searchQuery.isEmpty
              ? payload.page
              : payload.page.where((order) {
                  return order.templates.any((template) =>
                      template.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                      template.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                      template.tags.toLowerCase().contains(_searchQuery.toLowerCase()));
                }).toList();

          return Column(
            children: [
              // Templates List
              Expanded(
                child: filteredOrders.isEmpty
                    ? _buildNoResultsState()
                    : RefreshIndicator(
                        onRefresh: () async {
                          await ref.read(purchasedTemplatesProvider.notifier).refresh();
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
                          itemCount: filteredOrders.length + 1,
                          itemBuilder: (context, index) {
                            if (index == filteredOrders.length) {
                              return _buildLoadMoreIndicator(payload);
                            }

                            final order = filteredOrders[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (index == 0 ||
                                    filteredOrders[index - 1].paymentRef != order.paymentRef) ...[
                                  _buildOrderHeader(order),
                                  SizedBox(height: 12.h),
                                ],
                                ...order.templates.map((template) {
                                  // Filter individual templates within order
                                  if (_searchQuery.isNotEmpty &&
                                      !template.title.toLowerCase().contains(_searchQuery.toLowerCase()) &&
                                      !template.description.toLowerCase().contains(_searchQuery.toLowerCase()) &&
                                      !template.tags.toLowerCase().contains(_searchQuery.toLowerCase())) {
                                    return SizedBox.shrink();
                                  }
                                  
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 16.h),
                                    child: PurchasedTemplateCard(
                                      template: template,
                                      orderStatus: order.status,
                                      purchaseDate: order.createdAt,
                                      onDownload: () => _handleDownload(template),
                                      onViewDetails: () => _handleViewDetails(template),
                                    ),
                                  );
                                }).toList(),
                              ],
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
        loading: () => _buildLoadingState(),
        error: (error, stack) => _buildErrorState(error.toString()),
      ),
    );
  }

  Widget _buildOrderHeader(order) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${order.paymentRef}',
                style: AppTexts.labelMedium(color: AppColors.textPrimary),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: order.isCompleted ? Colors.green.shade50 : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  order.status,
                  style: AppTexts.labelSmall(
                    color: order.isCompleted ? Colors.green : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: ${order.formattedAmount}',
                style: AppTexts.bodyMedium(color: AppColors.grey700),
              ),
              Text(
                '${order.templates.length} template(s)',
                style: AppTexts.bodySmall(color: AppColors.grey600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreIndicator(payload) {
    if (payload.currentPage >= payload.totalPages - 1) {
      return SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF003D82)),
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
            size: 80.sp,
            color: AppColors.grey400,
          ),
          SizedBox(height: 16.h),
          Text(
            'No Templates Yet',
            style: AppTexts.h3(color: AppColors.textPrimary),
          ),
          SizedBox(height: 8.h),
          Text(
            'Your purchased templates will appear here',
            style: AppTexts.bodyMedium(color: AppColors.grey600),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              context.push('/templates');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003D82),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text('Browse Templates'),
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
          Icon(
            Icons.search_off,
            size: 80.sp,
            color: AppColors.grey400,
          ),
          SizedBox(height: 16.h),
          Text(
            'No Results Found',
            style: AppTexts.h3(color: AppColors.textPrimary),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try searching with different keywords',
            style: AppTexts.bodyMedium(color: AppColors.grey600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
      itemCount: 3,
      itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Header Skeleton
                  ShimmerWrapper(
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      margin: EdgeInsets.only(bottom: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: AppColors.grey200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SkeletonLine(width: 150.w, height: 14.h),
                              SkeletonBox(width: 80.w, height: 24.h, borderRadius: BorderRadius.circular(4.r)),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SkeletonLine(width: 100.w, height: 12.h),
                              SkeletonLine(width: 80.w, height: 12.h),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Template Card Skeleton
                  ShimmerWrapper(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 16.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image
                          SkeletonBox(
                            width: double.infinity,
                            height: 180.h,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.r),
                              topRight: Radius.circular(12.r),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SkeletonLine(width: double.infinity, height: 16.h),
                                SizedBox(height: 8.h),
                                SkeletonLine(width: 150.w, height: 12.h),
                                SizedBox(height: 12.h),
                                Row(
                                  children: [
                                    SkeletonBox(width: 60.w, height: 24.h, borderRadius: BorderRadius.circular(4.r)),
                                    SizedBox(width: 8.w),
                                    SkeletonBox(width: 70.w, height: 24.h, borderRadius: BorderRadius.circular(4.r)),
                                  ],
                                ),
                                SizedBox(height: 16.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SkeletonBox(height: 40.h, borderRadius: BorderRadius.circular(8.r)),
                                    ),
                                    SizedBox(width: 12.w),
                                    SkeletonBox(width: 80.w, height: 40.h, borderRadius: BorderRadius.circular(8.r)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
  }

  Widget _buildErrorState(String error) {
    // Check if it's a network error
    final isNetworkError = error.toLowerCase().contains('network') ||
        error.toLowerCase().contains('internet') ||
        error.toLowerCase().contains('connection') ||
        error.toLowerCase().contains('failed host lookup') ||
        error.toLowerCase().contains('socketexception');

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isNetworkError ? Icons.wifi_off : Icons.error_outline,
            size: 80.sp,
            color: AppColors.grey400,
          ),
          SizedBox(height: 16.h),
          Text(
            isNetworkError ? 'No Internet Connection' : 'Error Loading Templates',
            style: AppTexts.h3(color: AppColors.textPrimary),
          ),
          SizedBox(height: 8.h),
          Text(
            isNetworkError
                ? 'Please check your network connection'
                : error,
            style: AppTexts.bodyMedium(color: AppColors.grey600),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            'Pull down to refresh',
            style: AppTexts.bodySmall(color: AppColors.grey400),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              ref.read(purchasedTemplatesProvider.notifier).refresh();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003D82),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _handleDownload(template) async {
    if (template.fileUrl == null || template.fileUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download link not available'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final url = Uri.parse(template.fileUrl);
      
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening ${template.title}...'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not open download link'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error downloading: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleViewDetails(template) {
    context.push(
      '/template-details/${template.id}',
      extra: {
        'initialData': template,
        'isPurchased': true,
      },
    );
  }
}
