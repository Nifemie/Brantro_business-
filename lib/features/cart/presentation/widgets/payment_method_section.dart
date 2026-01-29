import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../../../core/utils/pricing_calculator.dart';

class PaymentMethodSection extends StatelessWidget {
  final String selectedPaymentMethod;
  final double walletBalance;
  final bool isWalletSufficient;
  final Function(String) onPaymentMethodChanged;

  const PaymentMethodSection({
    super.key,
    required this.selectedPaymentMethod,
    required this.walletBalance,
    required this.isWalletSufficient,
    required this.onPaymentMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final formattedBalance = PricingCalculator.formatAmountFull(walletBalance);

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
          Text('Payment Method', style: AppTexts.h4()),
          SizedBox(height: 16.h),

          _buildPaymentOption(
            value: 'wallet',
            label: 'Wallet',
            subtitle: 'Balance: $formattedBalance',
            icon: Icons.account_balance_wallet_outlined,
            isInsufficient: !isWalletSufficient,
          ),

          Divider(height: 24.h, color: AppColors.grey200),

          _buildPaymentOption(
            value: 'paystack',
            label: 'Paystack',
            subtitle: 'Pay with card or bank transfer',
            icon: Icons.credit_card_outlined,
          ),

          SizedBox(height: 16.h),
          Row(
            children: [
              Icon(Icons.lock_outline, size: 14.sp, color: AppColors.grey500),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  'Secure payments. Your purchase will be available immediately.',
                  style: AppTexts.bodySmall(color: AppColors.grey500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String value,
    required String label,
    required String subtitle,
    required IconData icon,
    bool isInsufficient = false,
  }) {
    final isSelected = selectedPaymentMethod == value;
    
    return GestureDetector(
      onTap: () => onPaymentMethodChanged(value),
      child: Container(
        decoration: BoxDecoration(
          color: isInsufficient && isSelected
              ? AppColors.error.withOpacity(0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Radio<String>(
              value: value,
              groupValue: selectedPaymentMethod,
              onChanged: (v) => onPaymentMethodChanged(v!),
              activeColor: isInsufficient ? AppColors.error : const Color(0xFF003D82),
            ),
            SizedBox(width: 8.w),
            Icon(icon, color: isInsufficient ? AppColors.error : AppColors.grey700),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTexts.bodyMedium()),
                  Text(
                    subtitle,
                    style: AppTexts.bodySmall(
                      color: isInsufficient ? AppColors.error : AppColors.grey500,
                    ),
                  ),
                  if (isInsufficient && isSelected) ...[
                    SizedBox(height: 4.h),
                    Text(
                      'Insufficient balance',
                      style: AppTexts.labelSmall(color: AppColors.error),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
