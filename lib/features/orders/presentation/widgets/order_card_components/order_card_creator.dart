import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/models/order_model.dart';

class OrderCardCreator extends StatelessWidget {
  final OrderModel order;
  final Color titleColor;
  final Color labelColor;

  const OrderCardCreator({
    super.key,
    required this.order,
    required this.titleColor,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ordered By',
          style: TextStyle(
            fontSize: 11.sp,
            color: labelColor,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Icon(
              Icons.person,
              size: 24.sp,
              color: labelColor,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        order.customerName,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: titleColor,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Icon(Icons.remove_red_eye, size: 14.sp, color: titleColor),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            Icons.star_border,
                            size: 12.sp,
                            color: labelColor,
                          );
                        }),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        order.creatorRating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: labelColor,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Icon(
                        Icons.favorite,
                        size: 12.sp,
                        color: Colors.red[300],
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '0',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: labelColor,
                        ),
                      ),
                    ],
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
