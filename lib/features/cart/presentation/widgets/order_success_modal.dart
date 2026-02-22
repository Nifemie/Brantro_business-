import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';

class OrderSuccessModal extends StatelessWidget {
  final String orderType; // 'campaign', 'service', 'creative', 'template'
  final String? orderId;
  final String? message;

  const OrderSuccessModal({
    super.key,
    required this.orderType,
    this.orderId,
    this.message,
  });

  static void show(
    BuildContext context, {
    required String orderType,
    String? orderId,
    String? message,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => OrderSuccessModal(
        orderType: orderType,
        orderId: orderId,
        message: message,
      ),
    );
  }

  String _getTitle() {
    switch (orderType.toLowerCase()) {
      case 'campaign':
        return 'Campaign Created!';
      case 'service':
        return 'Service Ordered!';
      case 'creative':
        return 'Creative Purchased!';
      case 'template':
        return 'Template Purchased!';
      default:
        return 'Order Placed!';
    }
  }

  String _getMessage() {
    if (message != null) return message!;
    
    switch (orderType.toLowerCase()) {
      case 'campaign':
        return 'Your campaign has been created successfully and is now pending approval.';
      case 'service':
        return 'Your service order has been placed successfully. The provider will contact you soon.';
      case 'creative':
        return 'Your creative has been purchased successfully. You can now download it.';
      case 'template':
        return 'Your template has been purchased successfully. You can now download it.';
      default:
        return 'Your order has been placed successfully!';
    }
  }

  String _getButtonText() {
    switch (orderType.toLowerCase()) {
      case 'campaign':
        return 'View My Campaigns';
      case 'service':
        return 'View My Services';
      case 'creative':
        return 'View My Creatives';
      case 'template':
        return 'View My Templates';
      default:
        return 'Continue';
    }
  }

  String _getRoute() {
    switch (orderType.toLowerCase()) {
      case 'campaign':
        return '/campaigns';
      case 'service':
        return '/my-services';
      case 'creative':
        return '/my-creatives';
      case 'template':
        return '/my-templates';
      default:
        return '/home';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon with Animation
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 40.sp,
                  ),
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // Title
            Text(
              _getTitle(),
              style: AppTexts.h2(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 12.h),

            // Message
            Text(
              _getMessage(),
              style: AppTexts.bodyMedium(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),

            if (orderId != null) ...[
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Order ID: ',
                      style: AppTexts.bodySmall(color: AppColors.grey600),
                    ),
                    Text(
                      orderId!,
                      style: AppTexts.bodySmall(
                        color: AppColors.primaryColor,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: 32.h),

            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  final route = _getRoute();
                  
                  // Use push for navigation to allow back navigation
                  context.push(route);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  _getButtonText(),
                  style: AppTexts.buttonMedium(color: Colors.white),
                ),
              ),
            ),

            SizedBox(height: 12.h),

            // Secondary Button - Go Home
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  context.go('/home'); // Go to home
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                ),
                child: Text(
                  'Go to Home',
                  style: AppTexts.buttonMedium(color: AppColors.grey600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
