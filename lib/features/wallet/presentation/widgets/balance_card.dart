import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';

class BalanceCard extends StatefulWidget {
  final String balance;
  final String pendingBalance;
  final String currency;
  final String status;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.pendingBalance,
    this.currency = 'NGN',
    this.status = 'ACTIVE',
  });

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _isBalanceVisible = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with status and visibility toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Status badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: widget.status == 'ACTIVE'
                      ? Colors.green.withOpacity(0.2)
                      : Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: widget.status == 'ACTIVE'
                        ? Colors.green
                        : Colors.orange,
                    width: 1,
                  ),
                ),
                child: Text(
                  widget.status,
                  style: AppTexts.bodySmall(
                    color: widget.status == 'ACTIVE'
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
              ),
              // Eye icon to toggle balance visibility
              IconButton(
                onPressed: () {
                  setState(() {
                    _isBalanceVisible = !_isBalanceVisible;
                  });
                },
                icon: Icon(
                  _isBalanceVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Wallet Balance label
          Text(
            'Wallet Balance',
            style: AppTexts.bodyMedium(color: Colors.white70),
          ),

          SizedBox(height: 8.h),

          // Main balance
          Text(
            _isBalanceVisible
                ? '${widget.currency} ${_formatAmount(widget.balance)}'
                : '${widget.currency} ••••••',
            style: AppTexts.h1(color: Colors.white).copyWith(
              fontSize: 36.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 12.h),

          // Pending balance
          if (double.tryParse(widget.pendingBalance) != null &&
              double.parse(widget.pendingBalance) > 0)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.schedule,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Pending: ${widget.currency} ${_formatAmount(widget.pendingBalance)}',
                    style: AppTexts.bodySmall(color: Colors.white),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _formatAmount(String amount) {
    final value = double.tryParse(amount) ?? 0.0;
    return value.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}
