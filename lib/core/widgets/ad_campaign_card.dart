import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../controllers/re_useable/app_color.dart';

class AdCampaignCard extends StatelessWidget {
  final String orderRef;
  final String status;
  final int adSlots;
  final String paymentMethod;
  final String orderId;
  final String advertiserName;
  final int likes;
  final int dislikes;
  final String date;
  final double budget;
  final VoidCallback? onMenuTap;
  final VoidCallback? onActionTap;

  const AdCampaignCard({
    super.key,
    required this.orderRef,
    required this.status,
    required this.adSlots,
    required this.paymentMethod,
    required this.orderId,
    required this.advertiserName,
    required this.likes,
    required this.dislikes,
    required this.date,
    required this.budget,
    this.onMenuTap,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Icon + Ref + Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        size: 24.sp,
                        color: isDark ? Colors.white70 : Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ref: $orderRef',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : const Color(0xFF1A2B4B),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.h),
                          Icon(
                            Icons.copy,
                            size: 14.sp,
                            color: isDark ? Colors.grey[500] : Colors.grey[400],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              _buildStatusBadge(status, isDark),
            ],
          ),

          SizedBox(height: 16.h),

          // Ad Slots Count
          Text(
            '$adSlots Ad Slots',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF1A2B4B),
            ),
          ),

          SizedBox(height: 12.h),

          // Payment Method
          Row(
            children: [
              Icon(
                Icons.credit_card,
                size: 16.sp,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  'Payment',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  paymentMethod,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF1A2B4B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Remark/Order ID
          Row(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 16.sp,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              SizedBox(width: 6.w),
              Text(
                'Remark',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'Order ID: $orderId',
            style: TextStyle(
              fontSize: 13.sp,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),

          SizedBox(height: 16.h),

          // Advertiser Section
          Text(
            'Advertiser',
            style: TextStyle(
              fontSize: 12.sp,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_outline,
                  size: 20.sp,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  advertiserName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF1A2B4B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              // Likes/Dislikes
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.thumb_up, size: 16.sp, color: Colors.orange),
                    SizedBox(width: 4.w),
                    Text(
                      '$likes',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: isDark ? Colors.white70 : Colors.grey[700],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(Icons.favorite, size: 16.sp, color: Colors.red),
                    SizedBox(width: 4.w),
                    Text(
                      '$dislikes',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: isDark ? Colors.white70 : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Date
          Text(
            date,
            style: TextStyle(
              fontSize: 13.sp,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),

          SizedBox(height: 16.h),

          // Budget
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Budget',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              Text(
                'NGN ₦${budget.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF1A2B4B),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Action Buttons
          Row(
            children: [
              // Menu Button
              Container(
                width: 56.w,
                height: 56.h,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850] : const Color(0xFFFFF5F5),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isDark ? Colors.grey[700]! : const Color(0xFFFFE5E5),
                  ),
                ),
                child: IconButton(
                  onPressed: onMenuTap,
                  icon: Icon(
                    Icons.more_horiz,
                    color: isDark ? Colors.white70 : const Color(0xFFFF6B6B),
                    size: 24.sp,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),

              SizedBox(width: 12.w),

              // Action Button (Cancel/Approve/Cancelled)
              Expanded(
                child: _buildActionButton(status, isDark),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status, bool isDark) {
    Color badgeColor;
    String badgeText;

    switch (status.toLowerCase()) {
      case 'pending':
        badgeColor = Colors.orange;
        badgeText = 'Pending';
        break;
      case 'cancelled':
        badgeColor = Colors.red;
        badgeText = 'Cancelled';
        break;
      case 'approved':
        badgeColor = Colors.green;
        badgeText = 'Approved';
        break;
      case 'completed':
        badgeColor = Colors.blue;
        badgeText = 'Completed';
        break;
      default:
        badgeColor = Colors.grey;
        badgeText = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        badgeText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionButton(String status, bool isDark) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onActionTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? Colors.white70 : Colors.grey[700],
                  side: BorderSide(
                    color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.close, size: 18.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ElevatedButton(
                onPressed: onActionTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003D82),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline, size: 18.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'Approve',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      case 'cancelled':
        return ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.withOpacity(0.3),
            foregroundColor: Colors.red,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cancel_outlined, size: 18.sp),
              SizedBox(width: 8.w),
              Text(
                'Cancelled',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      default:
        return ElevatedButton(
          onPressed: onActionTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF003D82),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            elevation: 0,
          ),
          child: Text(
            'View Details',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
    }
  }
}
