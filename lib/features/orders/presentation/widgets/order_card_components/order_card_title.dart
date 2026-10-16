import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../data/models/order_model.dart';

class OrderCardTitle extends StatelessWidget {
  final OrderModel order;
  final bool isDark;
  final Color titleColor;
  final Color labelColor;

  const OrderCardTitle({
    super.key,
    required this.order,
    required this.isDark,
    required this.titleColor,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.serviceName,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: titleColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  order.serviceType.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Total Amount',
              style: TextStyle(
                fontSize: 11.sp,
                color: labelColor,
              ),
            ),
            SizedBox(height: 4.h),
            RichText(
              text: TextSpan(
                text: 'NGN ',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: labelColor,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  TextSpan(
                    text: '₦${NumberFormat('#,##0').format(order.amount)}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: titleColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
