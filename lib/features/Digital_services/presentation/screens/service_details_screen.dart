import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../logic/service_details_notifier.dart';
import '../../data/models/service_model.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../../../cart/logic/cart_notifier.dart';
import '../../../cart/data/models/cart_item_model.dart';

class ServiceDetailsScreen extends ConsumerStatefulWidget {
  final String serviceId;
  final ServiceModel? initialData; // Optional data for optimistic UI

  const ServiceDetailsScreen({
    super.key,
    required this.serviceId,
    this.initialData,
  });

  @override
  ConsumerState<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends ConsumerState<ServiceDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Fetch data when screen initializes
    Future.microtask(() {
      ref.read(serviceDetailsProvider(widget.serviceId).notifier)
         .fetchServiceDetails(widget.serviceId, initialData: widget.initialData);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(serviceDetailsProvider(widget.serviceId));
    final service = state.singleData;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: state.isInitialLoading && service == null
          ? _buildLoadingState() // Show skeleton loader
          : state.message != null && service == null
              ? _buildErrorState(state.message!)
              : _buildContent(service!), // Service data (fresh or optimistic)
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
                 ref.read(serviceDetailsProvider(widget.serviceId).notifier)
                    .fetchServiceDetails(widget.serviceId);
              },
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ServiceModel service) {
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
                  // TODO: Save service
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Service Image
                  service.thumbnailUrl.isNotEmpty
                      ? Image.network(
                          service.thumbnailUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.grey300,
                              child: Icon(
                                Icons.image_outlined,
                                size: 64.sp,
                                color: AppColors.grey500,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: AppColors.grey300,
                          child: Icon(
                            Icons.design_services_outlined,
                            size: 64.sp,
                            color: AppColors.grey500,
                          ),
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
                        service.typeBadge.toUpperCase(),
                        style: AppTexts.labelSmall(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Service Content
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
                          service.title,
                          style: AppTexts.h2(),
                        ),
                        SizedBox(height: 8.h),
                        _buildRating(service),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Price & Delivery
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            Icons.payments_outlined,
                            'Price',
                            service.formattedPrice,
                            AppColors.success,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildInfoCard(
                            Icons.access_time_outlined,
                            'Delivery',
                            '${service.deliveryDays} days',
                            AppColors.info,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Provider Info
                  _buildProviderSection(service),

                  SizedBox(height: 20.h),

                  // Tags
                  if (service.tags.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Categories', style: AppTexts.h4()),
                          SizedBox(height: 8.h),
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: service.tags
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
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // TODO: Contact provider
                            },
                            icon: Icon(Icons.chat_bubble_outline, size: 18.sp),
                            label: Text('Contact'),
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
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Create cart item
                              final cartItem = CartItem.fromService({
                                'id': service.id,
                                'title': service.title,
                                'description': service.description,
                                'price': service.price.toString(),
                                'imageUrl': service.thumbnailUrl,
                                'provider': service.createdBy?.name,
                                'badge': service.typeBadge,
                                'duration': '${service.deliveryDays} days',
                              });

                              // Add to cart
                              ref.read(cartProvider.notifier).addItem(cartItem);

                              // Navigate to checkout
                              context.push('/checkout?type=service');
                            },
                            icon: Icon(Icons.shopping_cart_outlined,
                                size: 18.sp),
                            label: Text('Order Service'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
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
                        Tab(text: 'Reviews'),
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
                _buildDetailsTab(service),
                _buildReviewsTab(),
              ],
            ),
          ),
        ],
      );
  }

  Widget _buildRating(ServiceModel service) {
    return Row(
      children: [
        Icon(Icons.star, color: AppColors.warning, size: 20.sp),
        SizedBox(width: 4.w),
        Text(
          service.averageRating.toStringAsFixed(1),
          style: AppTexts.h4(),
        ),
        SizedBox(width: 4.w),
        Text(
          '(${service.totalLikes} reviews)', // Assuming totalLikes is reviews for now based on previous code
          style: AppTexts.bodySmall(color: AppColors.grey600),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
      IconData icon, String label, String value, Color color) {
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
        ],
      ),
    );
  }

  Widget _buildProviderSection(ServiceModel service) {
    final providerName = service.createdBy?.name ?? 'Brantro Africa';
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Service Provider', style: AppTexts.h4()),
          SizedBox(height: 12.h),
          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: AppColors.grey300,
                child: Icon(Icons.person, color: AppColors.grey600),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      providerName,
                      style: AppTexts.bodyMedium(
                        color: AppColors.textPrimary,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Verified Provider',
                      style: AppTexts.bodySmall(color: AppColors.grey600),
                    ),
                  ],
                ),
              ),
              Icon(Icons.verified, color: AppColors.success, size: 20.sp),
            ],
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
        '#$tag',
        style: AppTexts.bodySmall(color: AppColors.grey700),
      ),
    );
  }

  Widget _buildDetailsTab(ServiceModel service) {
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
              // Simple strip HTML
              service.description.replaceAll(RegExp(r'<[^>]*>'), ''),
              style: AppTexts.bodyMedium(color: AppColors.grey700),
            ),
            SizedBox(height: 24.h),
            if (service.features.isNotEmpty) ...[
                Text('What\'s Included', style: AppTexts.h4()),
                SizedBox(height: 12.h),
                ...service.features.map((f) => _buildFeatureItem(f)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: AppColors.success, size: 16.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              feature,
              style: AppTexts.bodyMedium(color: AppColors.grey700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rate_review_outlined,
                size: 48.sp, color: AppColors.grey400),
            SizedBox(height: 16.h),
            Text('No reviews yet', style: AppTexts.h4()),
            SizedBox(height: 8.h),
            Text(
              'Be the first to review this service',
              style: AppTexts.bodySmall(color: AppColors.grey600),
            ),
          ],
        ),
      ),
    );
  }
}
