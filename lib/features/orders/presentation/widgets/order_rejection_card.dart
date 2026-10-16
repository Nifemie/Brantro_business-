import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/order_model.dart';
import '../../../../controllers/re_useable/app_color.dart';

class OrderRejectionCard extends StatelessWidget {
  final OrderModel order;
  final bool isDark;

  const OrderRejectionCard({
    super.key,
    required this.order,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (order.itemStatus?.toUpperCase() != 'REJECTED' || order.itemStatusReason == null) {
      return const SizedBox.shrink();
    }

    final reason = order.itemStatusReason?['reason']?.toString() ?? 'Rejected';
    final description = order.itemStatusReason?['description']?.toString() ?? 'No additional details provided.';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2), // Light red background
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFFCA5A5)), // Red border
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: const Color(0xFFEF4444),
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Work Rejected',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF991B1B), // Dark red text
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            reason,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF991B1B),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            description,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFFB91C1C),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
