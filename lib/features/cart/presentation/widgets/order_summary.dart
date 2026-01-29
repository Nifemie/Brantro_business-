import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../../../core/utils/pricing_calculator.dart';

class OrderSummary extends StatelessWidget {
  final PricingBreakdown breakdown;

  const OrderSummary({super.key, required this.breakdown});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary', style: AppTexts.h4()),
          SizedBox(height: 16.h),
          _SummaryRow(label: 'Subtotal', value: breakdown.formattedSubtotal),
          SizedBox(height: 8.h),
          _SummaryRow(label: 'VAT (${breakdown.vatPercentage})', value: breakdown.formattedVAT),
          SizedBox(height: 8.h),
          _SummaryRow(
            label: 'Service Charge (${breakdown.serviceChargePercentage})',
            value: breakdown.formattedServiceCharge,
          ),
          Divider(height: 24.h, color: AppColors.grey200),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: AppTexts.h4()),
              Text(
                breakdown.formattedTotal,
                style: AppTexts.h3(color: AppColors.primaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTexts.bodyMedium(color: AppColors.grey600)),
        Text(value, style: AppTexts.bodyMedium(color: AppColors.grey800)),
      ],
    );
  }
}
