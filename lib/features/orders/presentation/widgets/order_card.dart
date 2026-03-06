import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../controllers/re_useable/app_color.dart';
import '../../data/models/order_model.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Ref and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ref: ${order.id}',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(isDark),
                ],
              ),

              SizedBox(height: 12.h),

              // Budget/Amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Budget',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  Text(
                    '₦${order.amount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // Ad Slots count
              _buildInfoRow(
                icon: Icons.layers_outlined,
                label: '0 Ad Slots',
                isDark: isDark,
              ),

              SizedBox(height: 8.h),

              // Payment method
              _buildInfoRow(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Payment',
                value: 'WALLET',
                isDark: isDark,
              ),

              SizedBox(height: 8.h),

              // Remark
              _buildInfoRow(
                icon: Icons.comment_outlined,
                label: 'Remark',
                value: order.description ?? 'Campaign order',
                isDark: isDark,
              ),

              SizedBox(height: 12.h),

              Divider(
                color: isDark ? Colors.grey[800] : Colors.grey[200],
                height: 1,
              ),

              SizedBox(height: 12.h),

              // Advertiser section
              Row(
                children: [
                  Text(
                    'Advertiser',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: isDark ? Colors.grey[500] : Colors.grey[500],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8.h),

              Row(
                children: [
                  CircleAvatar(
                    radius: 16.r,
                    backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      size: 18.sp,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.customerName,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 12.sp,
                              color: Colors.amber,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '0',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Icon(
                              Icons.favorite,
                              size: 12.sp,
                              color: Colors.red,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '0',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // Date
              Text(
                timeago.format(order.createdAt),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark ? Colors.grey[500] : Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isDark) {
    final statusConfig = _getStatusConfig(order.status);
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: statusConfig['color'],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        statusConfig['label'],
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    String? value,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: isDark ? Colors.grey[500] : Colors.grey[600],
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            color: isDark ? Colors.grey[400] : Colors.grey[700],
          ),
        ),
        if (value != null) ...[
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }

  Map<String, dynamic> _getStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return {
          'label': 'Pending',
          'color': const Color(0xFFF59E0B),
        };
      case 'active':
        return {
          'label': 'Active',
          'color': const Color(0xFF10B981),
        };
      case 'completed':
        return {
          'label': 'Completed',
          'color': const Color(0xFF3B82F6),
        };
      case 'cancelled':
        return {
          'label': 'Cancelled',
          'color': const Color(0xFFEF4444),
        };
      default:
        return {
          'label': status,
          'color': Colors.grey,
        };
    }
  }
}
