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
  final VoidCallback onMenuTap;
  final VoidCallback onActionTap;
  final VoidCallback? onCancelTap;

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
    required this.onMenuTap,
    required this.onActionTap,
    this.onCancelTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
          // Banner Area
          Container(
            height: 120.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[850] : const Color(0xFFF3F6F9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.movie_creation_outlined, // Clapperboard icon
                    size: 48.sp,
                    color: isDark ? Colors.white54 : const Color(0xFF7A8D9C),
                  ),
                ),
                Positioned(
                  top: 16.h,
                  right: 16.w,
                  child: _buildStatusBadge(status, isDark),
                ),
              ],
            ),
          ),

          // Content Area
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Ref & Budget
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          SizedBox(height: 12.h),
                          Icon(
                            Icons.copy,
                            size: 16.sp,
                            color: isDark ? Colors.grey[500] : const Color(0xFF7A8D9C),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Budget',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isDark ? Colors.grey[400] : const Color(0xFF7A8D9C),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 2.h, right: 4.w),
                              child: Text(
                                'NGN',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: isDark ? Colors.grey[400] : const Color(0xFF7A8D9C),
                                ),
                              ),
                            ),
                            Text(
                              '₦${budget.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF1A2B4B),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                Text(
                  '$adSlots Ad Slots',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDark ? Colors.grey[400] : const Color(0xFF7A8D9C),
                  ),
                ),

                SizedBox(height: 16.h),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      size: 16.sp,
                      color: isDark ? Colors.grey[400] : const Color(0xFF4A6583),
                    ),
                    SizedBox(width: 8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isDark ? Colors.grey[400] : const Color(0xFF4A6583),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          paymentMethod.toUpperCase(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDark ? Colors.white : const Color(0xFF1A2B4B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.play_circle_fill,
                      size: 16.sp,
                      color: isDark ? Colors.grey[400] : const Color(0xFF4A6583),
                    ),
                    SizedBox(width: 8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Remark',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isDark ? Colors.grey[400] : const Color(0xFF4A6583),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Campaign order', // Currently hardcoded in the original design
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDark ? Colors.white : const Color(0xFF1A2B4B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                Text(
                  'Advertiser',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark ? Colors.grey[400] : const Color(0xFF7A8D9C),
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12.r,
                      backgroundColor: isDark ? Colors.grey[800] : const Color(0xFFE2E8F0),
                      child: Icon(
                        Icons.person,
                        size: 16.sp,
                        color: isDark ? Colors.white70 : const Color(0xFF7A8D9C),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          advertiserName,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : const Color(0xFF1A2B4B),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(Icons.star, size: 12.sp, color: Colors.amber),
                            SizedBox(width: 4.w),
                            Text(
                              '$likes',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: isDark ? Colors.grey[400] : const Color(0xFF7A8D9C),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Icon(Icons.favorite, size: 12.sp, color: Colors.red),
                            SizedBox(width: 4.w),
                            Text(
                              '$dislikes',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: isDark ? Colors.grey[400] : const Color(0xFF7A8D9C),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 16.h),
                Divider(color: isDark ? Colors.grey[800] : Colors.grey[200]),
                SizedBox(height: 16.h),

                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark ? Colors.grey[400] : const Color(0xFF4A6583),
                  ),
                ),

                SizedBox(height: 20.h),

                // Action Buttons
                Row(
                  children: [
                    // Menu Button
                    Container(
                      width: 56.w,
                      height: 48.h,
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
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status, bool isDark) {
    Color badgeColor;
    String badgeText;

    switch (status.trim().toLowerCase()) {
      case 'pending':
      case 'requested':
        badgeColor = const Color(0xFFFF7A45); // Matching screenshot orange
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
        debugPrint('AdCampaignCard received unknown status: "$status"');
        badgeColor = Colors.grey;
        badgeText = status.isNotEmpty 
            ? status[0].toUpperCase() + status.substring(1).toLowerCase() 
            : 'Unknown';
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
    switch (status.trim().toLowerCase()) {
      case 'pending':
      case 'requested':
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onCancelTap ?? onActionTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? Colors.white70 : Colors.grey[700],
                  side: BorderSide(
                    color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cancel_outlined, size: 16.sp),
                    SizedBox(width: 6.w),
                    Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
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
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline, size: 16.sp),
                    SizedBox(width: 6.w),
                    Text(
                      'Approve',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
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
            padding: EdgeInsets.symmetric(vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cancel_outlined, size: 16.sp),
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
            padding: EdgeInsets.symmetric(vertical: 12.h),
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
