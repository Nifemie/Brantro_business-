import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../logic/cart_notifier.dart';

class CartDrawer extends ConsumerWidget {
  const CartDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final items = cartState.items;

    // Count items by type
    final templateCount = items.where((item) => item.type == 'template').length;
    final serviceCount = items.where((item) => item.type == 'service').length;
    final creativeCount = items.where((item) => item.type == 'creative').length;
    final campaignCount = items.where((item) => item.type == 'adslot' || item.type == 'campaign').length;

    final totalCount = items.length;

    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16.h,
                left: 20.w,
                right: 20.w,
                bottom: 20.h,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF003D82),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.r),
                  bottomRight: Radius.circular(20.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My Cart',
                        style: AppTexts.h2(color: Colors.white),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '$totalCount ${totalCount == 1 ? 'item' : 'items'} in cart',
                    style: AppTexts.bodyMedium(color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Cart Categories
            Expanded(
              child: totalCount == 0
                  ? _buildEmptyState(context)
                  : ListView(
                      padding: EdgeInsets.all(16.w),
                      children: [
                        if (templateCount > 0)
                          _buildCartCategoryCard(
                            context,
                            icon: Icons.design_services_outlined,
                            title: 'Templates',
                            count: templateCount,
                            onTap: () {
                              Navigator.pop(context);
                              context.push('/checkout?type=template');
                            },
                          ),
                        if (serviceCount > 0) ...[
                          SizedBox(height: 12.h),
                          _buildCartCategoryCard(
                            context,
                            icon: Icons.miscellaneous_services_outlined,
                            title: 'Services',
                            count: serviceCount,
                            onTap: () {
                              Navigator.pop(context);
                              context.push('/service-setup');
                            },
                          ),
                        ],
                        if (creativeCount > 0) ...[
                          SizedBox(height: 12.h),
                          _buildCartCategoryCard(
                            context,
                            icon: Icons.palette_outlined,
                            title: 'Creatives',
                            count: creativeCount,
                            onTap: () {
                              Navigator.pop(context);
                              context.push('/checkout?type=creative');
                            },
                          ),
                        ],
                        if (campaignCount > 0) ...[
                          SizedBox(height: 12.h),
                          _buildCartCategoryCard(
                            context,
                            icon: Icons.campaign_outlined,
                            title: 'Campaigns',
                            count: campaignCount,
                            onTap: () {
                              Navigator.pop(context);
                              context.push('/checkout?type=campaign');
                            },
                          ),
                        ],
                        SizedBox(height: 24.h),
                        if (totalCount > 0) _buildClearAllButton(context, ref),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartCategoryCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required int count,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.grey200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: AppColors.grey600, size: 28.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTexts.h4(),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '$count ${count == 1 ? 'item' : 'items'}',
                    style: AppTexts.bodySmall(color: AppColors.grey600),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.grey400,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80.sp,
            color: AppColors.grey300,
          ),
          SizedBox(height: 16.h),
          Text(
            'Your cart is empty',
            style: AppTexts.h3(color: AppColors.grey600),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add items to get started',
            style: AppTexts.bodyMedium(color: AppColors.grey500),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.push('/explore');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003D82),
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
            child: Text(
              'Explore',
              style: AppTexts.buttonMedium(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClearAllButton(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Clear Cart'),
            content: const Text('Are you sure you want to remove all items from your cart?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  ref.read(cartProvider.notifier).clearCart();
                  Navigator.pop(context); // Close dialog
                  // Use a small delay to ensure dialog is closed before closing drawer
                  Future.delayed(const Duration(milliseconds: 100), () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context); // Close drawer
                    }
                  });
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Clear All'),
              ),
            ],
          ),
        );
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.red,
        side: const BorderSide(color: Colors.red),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.delete_outline),
          SizedBox(width: 8.w),
          Text(
            'Clear All Items',
            style: AppTexts.buttonMedium(color: Colors.red),
          ),
        ],
      ),
    );
  }
}
