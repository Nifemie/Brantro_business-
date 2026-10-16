import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/models/order_model.dart';

class OrderCardDetails extends StatelessWidget {
  final OrderModel order;
  final Color titleColor;
  final Color labelColor;
  final Color valueColor;

  const OrderCardDetails({
    super.key,
    required this.order,
    required this.titleColor,
    required this.labelColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDetailItem(
                icon: Icons.account_balance_wallet,
                label: 'Payment',
                value: 'WALLET',
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: _buildDetailItem(
                  icon: Icons.layers,
                  label: 'Items',
                  value: order.itemsCount.toString(),
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildDetailItem(
          icon: Icons.comment,
          label: 'Note',
          value: order.description ?? 'Purchase of creatives',
        ),
      ],
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: Icon(icon, size: 14.sp, color: valueColor),
        ),
        SizedBox(width: 8.w),
        Flexible(
          child: Column(
            crossAxisAlignment: crossAxisAlignment,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: labelColor,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: valueColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
