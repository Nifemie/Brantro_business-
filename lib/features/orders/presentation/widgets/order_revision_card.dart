import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/order_model.dart';

class OrderRevisionCard extends StatelessWidget {
  final OrderModel order;
  final bool isDark;

  const OrderRevisionCard({
    super.key,
    required this.order,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final itemStatusUpper = (order.itemStatus ?? '').toUpperCase();
    final isRevisionRequested = itemStatusUpper == 'REVISION_REQUESTED' ||
        order.effectiveStatus.toLowerCase() == 'revision_requested';

    if (!isRevisionRequested) {
      return const SizedBox.shrink();
    }

    final items = order.metadata?['items'] as List<dynamic>? ?? [];
    final firstItem = items.isNotEmpty ? (items.first as Map<String, dynamic>?) : null;

    final feedback = order.itemStatusReason?['reason']?.toString() ??
        order.itemStatusReason?['remark']?.toString() ??
        order.itemStatusReason?['description']?.toString() ??
        firstItem?['remark']?.toString() ??
        order.description ??
        'The customer requested revisions to your delivered work. Please review their instructions and re-submit your updated files below.';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2310) : const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? const Color(0xFF78350F) : const Color(0xFFFCD34D),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.replay_rounded,
                color: const Color(0xFFD97706),
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Revision Requested',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            feedback,
            style: TextStyle(
              fontSize: 14.sp,
              color: isDark ? const Color(0xFFFEF3C7) : const Color(0xFF78350F),
              height: 1.4,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Use the "Re-submit Revised Work" button below once you have updated the deliverables.',
            style: TextStyle(
              fontSize: 12.sp,
              fontStyle: FontStyle.italic,
              color: isDark ? Colors.amber[200] : const Color(0xFFB45309),
            ),
          ),
        ],
      ),
    );
  }
}
