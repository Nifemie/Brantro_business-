import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../../../core/service/session_service.dart';
import '../../../../core/service/notification_service.dart';
import '../../data/models/cart_item_model.dart';
import '../../logic/cart_notifier.dart';

class AddToCampaignSheet extends ConsumerWidget {
  final CartItem item;

  const AddToCampaignSheet({
    super.key,
    required this.item,
  });

  static void show(BuildContext context, CartItem item) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddToCampaignSheet(item: item),
    );
  }

  Future<void> _handleCheckout(BuildContext context, WidgetRef ref, String route) async {
    final isLoggedIn = await SessionService.isLoggedIn();
    
    if (!isLoggedIn) {
      if (context.mounted) {
        context.pop(); // Close bottom sheet
        _showLoginDialog(context);
      }
      return;
    }
    
    // User is logged in, proceed with checkout
    if (context.mounted) {
      ref.read(cartProvider.notifier).addItem(item);
      
      // Show notification
      NotificationService.showCartNotification(
        context,
        itemName: item.title,
        itemType: item.type,
        onViewCart: () {
          context.push('/cart');
        },
      );
      
      context.pop();
      context.push(route);
    }
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_outline,
                  size: 48.sp,
                  color: AppColors.primaryColor,
                ),
              ),
              
              SizedBox(height: 20.h),
              
              // Title
              Text(
                'Login Required',
                style: AppTexts.h3(),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 12.h),
              
              // Message
              Text(
                'Please login to continue with your purchase. Create an account or sign in to access all features.',
                style: AppTexts.bodyMedium(color: AppColors.grey600),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 24.h),
              
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.grey300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppTexts.buttonSmall(color: AppColors.grey700),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.push('/signin');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        elevation: 0,
                      ),
                      child: Text(
                        'Login',
                        style: AppTexts.buttonSmall(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getHeaderText() {
    switch (item.type) {
      case 'creative':
        return 'Creative Added';
      case 'service':
        return 'Add to Service';
      case 'template':
        return 'Template Added';
      case 'adslot':
      case 'campaign':
      default:
        return 'Add to Your Campaign';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 40.h), // Increased bottom padding
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getHeaderText(),
                    style: AppTexts.h3(),
                  ),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Icon(
                      Icons.close,
                      size: 24.sp,
                      color: AppColors.grey600,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // Image Section
              Container(
                height: 200.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                      ? (item.imageUrl!.startsWith('http')
                          ? Image.network(
                              item.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                            )
                          : Image.asset(
                              item.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                            ))
                      : _buildPlaceholder(),
                ),
              ),

              SizedBox(height: 24.h),

              // Details Section
              Text(
                item.title,
                style: AppTexts.h3(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              if (item.sellerName != null) ...[
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.grey100,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        item.sellerType?.toUpperCase() ?? 'SELLER',
                        style: AppTexts.labelSmall(color: AppColors.grey700),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    if (item.duration != null || item.reach != null)
                      Text(
                        item.duration ?? item.reach ?? '',
                        style: AppTexts.bodyMedium(color: AppColors.grey600),
                      ),
                  ],
                ),
              ],
              
              if (item.description != null && item.description!.isNotEmpty) ...[
                 SizedBox(height: 12.h),
                 Text(
                   item.description!,
                   style: AppTexts.bodySmall(color: AppColors.grey600),
                   maxLines: 2,
                   overflow: TextOverflow.ellipsis,
                 ),
              ],

              SizedBox(height: 16.h),

              // Price
              Text(
                item.price,
                style: AppTexts.h2(color: AppColors.primaryColor),
              ),

              SizedBox(height: 32.h),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ref.read(cartProvider.notifier).addItem(item);
                        
                        // Show notification
                        NotificationService.showCartNotification(
                          context,
                          itemName: item.title,
                          itemType: item.type,
                        );
                        
                        context.pop();
                        
                        // Navigate to respective listing screen
                        _navigateToListingScreen(context, item.type);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.secondaryColor, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                      ),
                      child: Text(
                        item.type == 'creative' ? 'Get More Creatives' : 'Add & Explore',
                        style: AppTexts.buttonSmall(color: AppColors.secondaryColor),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        // Determine the route based on item type
                        String route;
                        if (item.type == 'service') {
                          route = '/service-setup';
                        } else if (item.type == 'adslot' || item.type == 'campaign') {
                          route = '/campaign-setup';
                        } else {
                          String checkoutType = item.type == 'creative' ? 'creative' : 'template';
                          route = '/checkout?type=$checkoutType';
                        }
                        
                        await _handleCheckout(context, ref, route);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                      ),
                      child: Text(
                        item.type == 'creative' ? 'Continue to Checkout' : 'Checkout Now',
                        style: AppTexts.buttonSmall(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        Icons.image_outlined,
        size: 48.sp,
        color: AppColors.grey400,
      ),
    );
  }

  void _navigateToListingScreen(BuildContext context, String itemType) {
    switch (itemType) {
      case 'service':
        context.push('/services');
        break;
      case 'creative':
        context.push('/creatives');
        break;
      case 'template':
        context.push('/templates');
        break;
      case 'adslot':
      case 'campaign':
        context.push('/explore?category=Ad Slots');
        break;
      default:
        context.push('/home');
    }
  }
}
