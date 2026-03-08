import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_texts.dart';

enum TransactionType {
  deposit,
  withdrawal,
  transferIn,
  transferOut,
  request,
  refund,
}

enum TransactionStatus { pending, completed, failed, cancelled }

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final isCredit =
        type == TransactionType.deposit ||
        type == TransactionType.transferIn ||
        type == TransactionType.refund;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2F36) : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : const Color(0xFF000000).withOpacity(0.06),
              blurRadius: 15,
              spreadRadius: 0,
              offset: const Offset(0, 8),
            ),
          ],
          border: isDark
              ? Border.all(color: Colors.white.withOpacity(0.05), width: 1)
              : Border.all(color: const Color(0xFFF0F0F0), width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Transaction type icon with premium backdrop
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: _getIconBackgroundColor().withOpacity(
                  isDark ? 0.15 : 0.1,
                ),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Center(
                child: Icon(
                  _getTransactionIcon(),
                  color: _getIconBackgroundColor(),
                  size: 24.sp,
                ),
              ),
            ),

            SizedBox(width: 16.w),

            // Transaction details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    description.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: isDark ? Colors.white : const Color(0xFF1A1C1E),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: isDark ? Colors.grey[400] : Colors.grey[500],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (reference != null) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          child: Text(
                            '•',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: isDark
                                  ? Colors.grey[600]
                                  : Colors.grey[300],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            reference!.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: isDark
                                  ? Colors.grey[500]
                                  : Colors.grey[400],
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (status != TransactionStatus.completed) ...[
                    SizedBox(height: 8.h),
                    _buildStatusBadge(),
                  ],
                ],
              ),
            ),

            SizedBox(width: 12.w),

            // Amount with refined styling
            Text(
              '${isCredit ? '+' : '-'}$amount',
              style: TextStyle(
                fontSize: 16.sp,
                letterSpacing: -0.5,
                fontWeight: FontWeight.w900,
                color: isCredit
                    ? const Color(
                        0xFF2E7D32,
                      ) // Deeper green for premium contrast
                    : const Color(
                        0xFFD32F2F,
                      ), // Deeper red for premium contrast
              ),
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
    final isCredit =
        type == TransactionType.deposit ||
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
        style: AppTexts.bodySmall(color: badgeColor).copyWith(fontSize: 10.sp),
      ),
    );
  }
}
