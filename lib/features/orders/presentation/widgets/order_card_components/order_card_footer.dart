import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../data/models/order_model.dart';

class OrderCardFooter extends StatelessWidget {
  final OrderModel order;
  final bool isDark;
  final Color titleColor;
  final Color labelColor;
  final VoidCallback onTap;

  const OrderCardFooter({
    super.key,
    required this.order,
    required this.isDark,
    required this.titleColor,
    required this.labelColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('MMM d, yyyy').format(order.createdAt),
              style: TextStyle(
                fontSize: 12.sp,
                color: labelColor,
              ),
            ),
            Row(
              children: [
                Text(
                  'Ref: ${order.id}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: labelColor,
                  ),
                ),
                SizedBox(width: 6.w),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: order.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reference ID copied to clipboard')),
                    );
                  },
                  child: Icon(Icons.copy, size: 14.sp, color: labelColor),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onTap,
            icon: Icon(Icons.remove_red_eye_outlined, size: 18.sp, color: titleColor),
            label: Text(
              'View',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: titleColor,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              side: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
