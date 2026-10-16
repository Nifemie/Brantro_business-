import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../data/models/order_model.dart';
import '../utils/order_config_helper.dart';

class OrderInfoCard extends StatelessWidget {
  final OrderModel order;
  final bool isDark;

  const OrderInfoCard({super.key, required this.order, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final serviceConfig = OrderConfigHelper.getServiceConfig(order.serviceType);

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
          _buildHeader(serviceConfig),
          SizedBox(height: 20.h),
          _buildInfoRow('Service', order.serviceName),
          SizedBox(height: 16.h),
          if (order.description != null && order.description!.isNotEmpty) ...[
            _buildSectionHeader('Description'),
            SizedBox(height: 8.h),
            Text(
              order.description!,
              style: TextStyle(
                fontSize: 14.sp,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
                height: 1.5,
              ),
            ),
            SizedBox(height: 16.h),
          ],
          _buildAmountSection(),
          _buildSlaCountdownSection(),
          SizedBox(height: 16.h),
          _buildDatesSection(),
        ],
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic> serviceConfig) {
    final displayStatus = order.itemStatus ?? order.status;
    final statusConfig = OrderConfigHelper.getStatusConfig(displayStatus);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: serviceConfig['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  serviceConfig['icon'],
                  size: 24.sp,
                  color: serviceConfig['color'],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.id,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      serviceConfig['label'],
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: serviceConfig['color'],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: statusConfig['color'],
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Text(
            statusConfig['label'],
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Icon(Icons.info_outline, size: 16.sp, color: AppColors.secondaryColor),
        SizedBox(width: 6.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 14.sp,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountSection() {
    final formattedAmount = NumberFormat('#,##0.00').format(order.amount);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Amount',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          Text(
            '₦$formattedAmount',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatesSection() {
    final completedAtStr =
        order.metadata?['completedAt']?.toString() ??
        order.metadata?['paidAt']?.toString();
    final completedAt = completedAtStr != null
        ? DateTime.tryParse(completedAtStr)
        : null;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Created',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                timeago.format(order.createdAt),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        if (completedAt != null)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Completed',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  timeago.format(completedAt),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          )
        else if (order.updatedAt != null)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Last Updated',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  timeago.format(order.updatedAt!),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSlaCountdownSection() {
    final statusLower = (order.itemStatus ?? order.status).toLowerCase();
    final isActive = statusLower == 'accepted' ||
        statusLower == 'inprogress' ||
        statusLower == 'in_progress' ||
        statusLower == 'active' ||
        statusLower == 'revision_requested';

    if (!isActive) return const SizedBox.shrink();

    final deliveryDaysRaw = order.metadata?['deliveryDays'] ??
        order.metadata?['duration'] ??
        order.metadata?['service']?['deliveryDays'] ??
        order.metadata?['item']?['deliveryDays'];
    final deliveryDays = int.tryParse(deliveryDaysRaw?.toString() ?? '3') ?? 3;

    final startedAtStr = order.metadata?['startedAt'] ??
        order.metadata?['acceptedAt'] ??
        order.metadata?['createdAt'];
    final startedAt = (startedAtStr != null ? DateTime.tryParse(startedAtStr.toString()) : null) ?? order.createdAt;

    final deadline = startedAt.add(Duration(days: deliveryDays));
    final now = DateTime.now();
    final remaining = deadline.difference(now);
    final isOverdue = remaining.isNegative;

    String timeText;
    if (isOverdue) {
      final overdueDays = remaining.abs().inDays;
      final overdueHours = remaining.abs().inHours % 24;
      timeText = overdueDays > 0
          ? 'Overdue by $overdueDays d $overdueHours h'
          : 'Overdue by $overdueHours h';
    } else {
      final days = remaining.inDays;
      final hours = remaining.inHours % 24;
      timeText = days > 0 ? '$days d $hours h remaining' : '$hours h remaining';
    }

    final badgeColor = isOverdue
        ? const Color(0xFFEF4444)
        : (remaining.inHours < 24 ? const Color(0xFFF59E0B) : const Color(0xFF10B981));

    return Container(
      margin: EdgeInsets.only(top: 14.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: badgeColor.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          Icon(
            isOverdue ? Icons.warning_amber_rounded : Icons.timer_outlined,
            color: badgeColor,
            size: 18.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Delivery SLA ($deliveryDays Days)',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                Text(
                  timeText,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: badgeColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
