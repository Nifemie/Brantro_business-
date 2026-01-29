import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
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
                    item.type == 'creative' ? 'Creative Added' : 'Add to Your Campaign',
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
                        context.pop();
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
                      onPressed: () {
                        ref.read(cartProvider.notifier).addItem(item);
                        context.pop();
                        
                        // Navigate based on item type
                        if (item.type == 'service') {
                          context.push('/service-setup');
                        } else {
                          String checkoutType = 'campaign';
                          if (item.type == 'template') checkoutType = 'template';
                          else if (item.type == 'creative') checkoutType = 'creative';
                          
                          context.push('/checkout?type=$checkoutType');
                        }
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
}
