import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/kyc_constants.dart';

class KycStatusBadge extends StatelessWidget {
  final KycVerificationStatus status;
  final bool showDescription;

  const KycStatusBadge({
    super.key,
    required this.status,
    this.showDescription = false,
  });

  Color _getStatusColor() {
    switch (status) {
      case KycVerificationStatus.notStarted:
        return Colors.grey;
      case KycVerificationStatus.pending:
      case KycVerificationStatus.inReview:
        return Colors.orange;
      case KycVerificationStatus.approved:
        return Colors.green;
      case KycVerificationStatus.rejected:
        return Colors.red;
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case KycVerificationStatus.notStarted:
        return Icons.info_outline;
      case KycVerificationStatus.pending:
      case KycVerificationStatus.inReview:
        return Icons.pending_outlined;
      case KycVerificationStatus.approved:
        return Icons.check_circle_outline;
      case KycVerificationStatus.rejected:
        return Icons.cancel_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();

    if (showDescription) {
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(_getStatusIcon(), color: color, size: 32.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status.displayName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    status.description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Simple badge version
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getStatusIcon(), color: color, size: 16.sp),
          SizedBox(width: 6.w),
          Text(
            status.displayName,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
