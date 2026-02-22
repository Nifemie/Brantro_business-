import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../../../home/presentation/widgets/search_bar_widget.dart';
import '../../logic/purchased_services_notifier.dart';
import '../widgets/purchased_service_card.dart';
import '../widgets/edit_service_details_sheet.dart';

class MyServicesScreen extends ConsumerStatefulWidget {
  const MyServicesScreen({super.key});

  @override
  ConsumerState<MyServicesScreen> createState() => _MyServicesScreenState();
}

class _MyServicesScreenState extends ConsumerState<MyServicesScreen> {
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
      ref.read(purchasedServicesProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final servicesState = ref.watch(purchasedServicesProvider);

    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false, // Disable automatic back button
        leading: Navigator.of(context).canPop() 
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.pop(),
              )
            : null,
        title: Text(
          'My Services',
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
              ref.read(purchasedServicesProvider.notifier).refresh();
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
              hintText: 'Search services...',
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
      body: servicesState.when(
        data: (payload) {
          if (payload == null || payload.page.isEmpty) {
            return _buildEmptyState();
          }

          // Filter services based on search query
          final filteredOrders = _searchQuery.isEmpty
              ? payload.page
              : payload.page.where((order) {
                  return order.items.any((item) =>
                      item.service != null &&
                      (item.service!.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                       item.service!.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                       item.service!.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()))));
                }).toList();

          return Column(
            children: [
              // Services List
              Expanded(
                child: filteredOrders.isEmpty
                    ? _buildNoResultsState()
                    : RefreshIndicator(
                        onRefresh: () async {
                          await ref.read(purchasedServicesProvider.notifier).refresh();
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
                                ...order.items.map((serviceItem) {
                                  // Filter individual services within order
                                  if (_searchQuery.isNotEmpty &&
                                      serviceItem.service != null &&
                                      !serviceItem.service!.title.toLowerCase().contains(_searchQuery.toLowerCase()) &&
                                      !serviceItem.service!.description.toLowerCase().contains(_searchQuery.toLowerCase()) &&
                                      !serviceItem.service!.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()))) {
                                    return SizedBox.shrink();
                                  }
                                  
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 16.h),
                                    child: PurchasedServiceCard(
                                      serviceItem: serviceItem,
                                      orderStatus: order.status,
                                      purchaseDate: order.createdAt,
                                      onViewDetails: () => _handleViewDetails(serviceItem),
                                      onContactProvider: () => _handleContactProvider(serviceItem),
                                      onEditDetails: () => _handleEditDetails(serviceItem),
                                      onCancelOrder: () => _handleCancelOrder(order, serviceItem),
                                      onViewDeliveries: () => _handleViewDeliveries(serviceItem),
                                      onProvideRequirements: () => _handleProvideRequirements(serviceItem),
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
              Expanded(
                child: Text(
                  'Order #${order.paymentRef}',
                  style: AppTexts.labelMedium(color: AppColors.textPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
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
                'Total: ${order.formattedTotalPayable}',
                style: AppTexts.bodyMedium(color: AppColors.grey700),
              ),
              Text(
                '${order.items.length} service(s)',
                style: AppTexts.bodySmall(color: AppColors.grey600),
              ),
            ],
          ),
          if (order.creator != null) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.store, size: 14.sp, color: AppColors.grey600),
                SizedBox(width: 4.w),
                Text(
                  'Provider: ${order.creator!.name}',
                  style: AppTexts.bodySmall(color: AppColors.grey600),
                ),
              ],
            ),
          ],
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
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
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
            'No Services Yet',
            style: AppTexts.h3(color: AppColors.textPrimary),
          ),
          SizedBox(height: 8.h),
          Text(
            'Your purchased services will appear here',
            style: AppTexts.bodyMedium(color: AppColors.grey600),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              context.push('/services');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text('Browse Services'),
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
            // Service Card Skeleton
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
                          SkeletonBox(width: 100.w, height: 20.h, borderRadius: BorderRadius.circular(4.r)),
                          SizedBox(height: 16.h),
                          SkeletonLine(width: double.infinity, height: 40.h),
                          SizedBox(height: 16.h),
                          SkeletonLine(width: 150.w, height: 12.h),
                          SizedBox(height: 8.h),
                          SkeletonLine(width: 120.w, height: 12.h),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              Expanded(
                                child: SkeletonBox(height: 40.h, borderRadius: BorderRadius.circular(8.r)),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: SkeletonBox(height: 40.h, borderRadius: BorderRadius.circular(8.r)),
                              ),
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
            isNetworkError ? 'No Internet Connection' : 'Error Loading Services',
            style: AppTexts.h3(color: AppColors.textPrimary),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              isNetworkError
                  ? 'Please check your network connection'
                  : error,
              style: AppTexts.bodyMedium(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Pull down to refresh',
            style: AppTexts.bodySmall(color: AppColors.grey400),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              ref.read(purchasedServicesProvider.notifier).refresh();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
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

  void _handleViewDetails(serviceItem) {
    final service = serviceItem.service;
    if (service != null) {
      context.push(
        '/service-details/${service.id}',
        extra: {
          'initialData': service,
          'isPurchased': true,
        },
      );
    }
  }

  void _handleContactProvider(serviceItem) {
    // TODO: Open chat or contact dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Contact provider feature coming soon')),
    );
  }

  void _handleEditDetails(serviceItem) async {
    final service = serviceItem.service;
    if (service == null) return;

    // Extract existing project details if any
    final existingDetails = serviceItem.projectDetails;
    
    EditServiceDetailsSheet.show(
      context,
      serviceName: service.title,
      initialDescription: existingDetails?['description'],
      initialLinks: existingDetails?['referenceLinks'] != null
          ? List<String>.from(existingDetails!['referenceLinks'])
          : null,
      initialFiles: existingDetails?['attachedFiles'] != null
          ? List<Map<String, dynamic>>.from(existingDetails!['attachedFiles'])
          : null,
      onSave: (projectDetails) async {
        // Show loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Text('Updating project details...'),
              ],
            ),
            duration: Duration(seconds: 30),
          ),
        );

        try {
          // Call API to update service requirements
          final success = await ref.read(purchasedServicesProvider.notifier).updateServiceRequirements(
            itemId: serviceItem.id,
            description: projectDetails['description'] ?? '',
            links: projectDetails['referenceLinks'] != null
                ? List<String>.from(projectDetails['referenceLinks'])
                : null,
            files: projectDetails['attachedFiles'] != null
                ? List<Map<String, dynamic>>.from(projectDetails['attachedFiles'])
                : null,
          );

          // Hide loading indicator
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 12),
                    Text('Project details updated successfully'),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.error, color: Colors.white),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Backend endpoint not available yet. Feature coming soon!',
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.orange,
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 4),
              ),
            );
          }
        } catch (e) {
          // Hide loading indicator
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          
          // Check if it's a 404 error (endpoint not implemented)
          final is404 = e.toString().contains('404');
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    is404 ? Icons.info : Icons.error,
                    color: Colors.white,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      is404
                          ? 'This feature is not yet available on the backend. Coming soon!'
                          : 'Error: ${e.toString()}',
                    ),
                  ),
                ],
              ),
              backgroundColor: is404 ? Colors.orange : Colors.red,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 5),
            ),
          );
        }
      },
    );
  }

  void _handleCancelOrder(order, serviceItem) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel Order'),
        content: Text(
          'Are you sure you want to cancel this service order? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No, Keep It'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 12),
            Text('Cancelling order...'),
          ],
        ),
        duration: Duration(seconds: 30),
      ),
    );

    try {
      final success = await ref.read(purchasedServicesProvider.notifier).cancelServiceOrder(
        itemId: serviceItem.id,
      );

      // Hide loading indicator
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Order cancelled successfully'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text('Failed to cancel order. Please try again.'),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      // Hide loading indicator
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text('Error: ${e.toString()}'),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  void _handleViewDeliveries(serviceItem) {
    // TODO: Navigate to deliveries screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View deliveries for ${serviceItem.service?.title}')),
    );
  }

  void _handleProvideRequirements(serviceItem) {
    // TODO: Navigate to requirements form
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Provide requirements for ${serviceItem.service?.title}')),
    );
  }
}
