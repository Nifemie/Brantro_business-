import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../data/models/template_model.dart';
import '../../../cart/logic/cart_notifier.dart';
import '../../../cart/data/models/cart_item_model.dart';

class TemplateAddedSheet extends ConsumerWidget {
  final TemplateModel template;

  const TemplateAddedSheet({
    super.key,
    required this.template,
  });

  static void show(BuildContext context, TemplateModel template) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TemplateAddedSheet(template: template),
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
                    'Template Added',
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
                  child: template.thumbnail.startsWith('http')
                      ? Image.network(
                          template.thumbnail,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: AppColors.grey300,
                          ),
                        )
                      : Container(
                          color: AppColors.grey300,
                        ),
                ),
              ),

              SizedBox(height: 24.h),

              // Details Section
              Text(
                template.title,
                style: AppTexts.h3(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              SizedBox(height: 8.h),

              Text(
                template.description,
                style: AppTexts.bodySmall(color: AppColors.grey600),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 12.h),

              // Tags/Type
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      template.type,
                      style: AppTexts.labelSmall(color: AppColors.primaryColor),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // Price
              Text(
                template.formattedPrice,
                style: AppTexts.h2(color: AppColors.primaryColor),
              ),

              SizedBox(height: 32.h),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        context.pop();
                        context.pop(); // Go back one more step (hacky but effectively standard back)
                        context.push('/template'); // Actually usually pop() is enough if on listing.
                        // But context.pop() clears the sheet. Then push moves forward.
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFFFF6B35), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                      ),
                      child: Text(
                        'Get More',
                        style: AppTexts.buttonMedium(color: Color(0xFFFF6B35)),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Add template to cart
                        final cartItem = CartItem.fromTemplate(template.toJson());
                        ref.read(cartProvider.notifier).addItem(cartItem);
                        
                        // Navigate to checkout
                        context.push('/checkout?type=template');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF003D82),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        elevation: 0,
                      ),
                      child: Text(
                        'Checkout',
                        style: AppTexts.buttonMedium(color: Colors.white),
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
