import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';

enum TransactionType {
  deposit,
  withdrawal,
  transferIn,
  transferOut,
  request,
  refund,
}

enum TransactionStatus {
  pending,
  completed,
  failed,
  cancelled,
}

class TransactionCard extends StatelessWidget {
  final TransactionType type;
  final String description;
  final String amount;
  final String date;
  final String? reference;
  final TransactionStatus status;
  final VoidCallback? onTap;

  const TransactionCard({
    super.key,
    required this.type,
    required this.description,
    required this.amount,
    required this.date,
    this.reference,
    this.status = TransactionStatus.completed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCredit = type == TransactionType.deposit ||
        type == TransactionType.transferIn ||
        type == TransactionType.refund;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.grey200, width: 1),
        ),
        child: Row(
          children: [
            // Transaction type icon
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: _getIconBackgroundColor().withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getTransactionIcon(),
                color: _getIconBackgroundColor(),
                size: 24.sp,
              ),
            ),

            SizedBox(width: 12.w),

            // Transaction details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description,
                    style: AppTexts.h4(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          date,
                          style: AppTexts.bodySmall(color: AppColors.grey600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (reference != null) ...[
                        SizedBox(width: 4.w),
                        Text(
                          '•',
                          style: AppTexts.bodySmall(color: AppColors.grey500),
                        ),
                        SizedBox(width: 4.w),
                        Flexible(
                          child: Text(
                            reference!,
                            style: AppTexts.bodySmall(color: AppColors.grey500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (status != TransactionStatus.completed) ...[
                    SizedBox(height: 4.h),
                    _buildStatusBadge(),
                  ],
                ],
              ),
            ),

            SizedBox(width: 12.w),

            // Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isCredit ? '+' : '-'}$amount',
                  style: AppTexts.h3(
                    color: isCredit ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTransactionIcon() {
    switch (type) {
      case TransactionType.deposit:
        return Icons.arrow_downward;
      case TransactionType.withdrawal:
        return Icons.arrow_upward;
      case TransactionType.transferIn:
        return Icons.call_received;
      case TransactionType.transferOut:
        return Icons.call_made;
      case TransactionType.request:
        return Icons.request_page;
      case TransactionType.refund:
        return Icons.replay;
    }
  }

  Color _getIconBackgroundColor() {
    final isCredit = type == TransactionType.deposit ||
        type == TransactionType.transferIn ||
        type == TransactionType.refund;
    return isCredit ? Colors.green : Colors.red;
  }

  Widget _buildStatusBadge() {
    Color badgeColor;
    String statusText;

    switch (status) {
      case TransactionStatus.pending:
        badgeColor = Colors.orange;
        statusText = 'Pending';
        break;
      case TransactionStatus.failed:
        badgeColor = Colors.red;
        statusText = 'Failed';
        break;
      case TransactionStatus.cancelled:
        badgeColor = Colors.grey;
        statusText = 'Cancelled';
        break;
      case TransactionStatus.completed:
        badgeColor = Colors.green;
        statusText = 'Completed';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: badgeColor, width: 1),
      ),
      child: Text(
        statusText,
        style: AppTexts.bodySmall(color: badgeColor).copyWith(
          fontSize: 10.sp,
        ),
      ),
    );
  }
}
