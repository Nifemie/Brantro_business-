import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../data/models/order_model.dart';

import 'package:intl/intl.dart';

class OrderChargeBreakdownCard extends StatelessWidget {
  final OrderModel order;
  final bool isDark;

  const OrderChargeBreakdownCard({
    super.key,
    required this.order,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final breakdown = order.metadata?['chargeBreakdown'] as Map<String, dynamic>?;
    if (breakdown == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
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
          Row(
            children: [
              Icon(
                Icons.receipt_long_rounded,
                color: Theme.of(context).primaryColor,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Charge Breakdown',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildBreakdownRow('Subtotal', breakdown['subtotal']),
          _buildBreakdownRow('VAT Amount', breakdown['vatAmount']),
          _buildBreakdownRow('Platform Fee', breakdown['platformFee']),
          _buildBreakdownRow('Service Charge', breakdown['serviceCharge']),
          Divider(color: isDark ? Colors.grey[800] : Colors.grey[200], height: 24.h),
          _buildBreakdownRow('Total Payable', breakdown['totalPayable'], isTotal: true),
          SizedBox(height: 8.h),
          _buildBreakdownRow('Seller Net Amount', breakdown['sellerNetAmount'], isHighlighted: true),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(String label, dynamic amount, {bool isTotal = false, bool isHighlighted = false}) {
    if (amount == null) return const SizedBox.shrink();
    
    final parsedAmount = double.tryParse(amount.toString()) ?? 0.0;
    final formattedAmount = NumberFormat('#,##0.00').format(parsedAmount);
    
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 14.sp : 13.sp,
              fontWeight: isTotal || isHighlighted ? FontWeight.w600 : FontWeight.normal,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          Text(
            'NGN $formattedAmount',
            style: TextStyle(
              fontSize: isTotal ? 16.sp : 14.sp,
              fontWeight: isTotal || isHighlighted ? FontWeight.w700 : FontWeight.w600,
              color: isHighlighted 
                  ? const Color(0xFF10B981) 
                  : (isDark ? Colors.white : AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
