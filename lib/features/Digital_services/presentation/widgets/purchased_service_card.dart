import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../data/models/purchased_service_model.dart';

class PurchasedServiceCard extends StatelessWidget {
  final ServiceItemModel serviceItem;
  final String orderStatus;
  final DateTime purchaseDate;
  final VoidCallback? onViewDetails;
  final VoidCallback? onContactProvider;
  final VoidCallback? onEditDetails;
  final VoidCallback? onCancelOrder;
  final VoidCallback? onViewDeliveries;
  final VoidCallback? onProvideRequirements;

  const PurchasedServiceCard({
    super.key,
    required this.serviceItem,
    required this.orderStatus,
    required this.purchaseDate,
    this.onViewDetails,
    this.onContactProvider,
    this.onEditDetails,
    this.onCancelOrder,
    this.onViewDeliveries,
    this.onProvideRequirements,
  });

  @override
  Widget build(BuildContext context) {
    final service = serviceItem.service;
    if (service == null) return SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with status badge and menu
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
                child: service.thumbnailUrl.isNotEmpty
                    ? Image.network(
                        service.thumbnailUrl,
                        height: 180.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholder();
                        },
                      )
                    : _buildPlaceholder(),
              ),
              // Status Badge
              Positioned(
                top: 12.h,
                left: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(serviceItem.status),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    _getStatusText(serviceItem.status),
                    style: AppTexts.labelSmall(color: Colors.white),
                  ),
                ),
              ),
              // Menu Button
              Positioned(
                top: 8.h,
                right: 8.w,
                child: PopupMenuButton<String>(
                  icon: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.more_vert, color: Colors.white, size: 20.sp),
                  ),
                  onSelected: (value) => _handleMenuAction(context, value),
                  itemBuilder: (context) => _buildMenuItems(),
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  service.title,
                  style: AppTexts.h4(color: AppColors.textPrimary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                
                // Service Type Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    service.typeBadge,
                    style: AppTexts.labelSmall(color: AppColors.grey700),
                  ),
                ),

                SizedBox(height: 16.h),

                // Progress Timeline
                _buildProgressTimeline(),

                SizedBox(height: 16.h),

                // Service Details
                _buildDetailRow(Icons.calendar_today, 'Purchased', _formatDate(purchaseDate)),
                SizedBox(height: 8.h),
                _buildDetailRow(Icons.access_time, 'Delivery', '${service.deliveryDays} days'),
                SizedBox(height: 8.h),
                _buildDetailRow(Icons.refresh, 'Revisions', '${service.revisionCount} included'),

                SizedBox(height: 16.h),

                // Price
                Row(
                  children: [
                    Icon(Icons.payments_outlined, size: 16.sp, color: AppColors.primaryColor),
                    SizedBox(width: 4.w),
                    Text(
                      serviceItem.chargeBreakdown != null
                          ? '₦${serviceItem.chargeBreakdown!.totalPayable.toStringAsFixed(0)}'
                          : service.formattedPrice,
                      style: AppTexts.h4(color: AppColors.primaryColor),
                    ),
                    if (service.discount != null && service.discount!.isNotEmpty) ...[
                      SizedBox(width: 8.w),
                      Text(
                        '₦${double.parse(service.discount!).toStringAsFixed(0)} off',
                        style: AppTexts.bodySmall(color: AppColors.success),
                      ),
                    ],
                  ],
                ),

                SizedBox(height: 16.h),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onViewDetails,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryColor,
                          side: BorderSide(color: AppColors.primaryColor),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text('View Details'),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _getPrimaryAction(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getPrimaryActionColor(),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(_getPrimaryActionText()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 180.h,
      width: double.infinity,
      color: AppColors.grey200,
      child: Center(
        child: Icon(
          Icons.design_services_outlined,
          size: 48.sp,
          color: AppColors.grey400,
        ),
      ),
    );
  }

  Widget _buildProgressTimeline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progress',
          style: AppTexts.labelSmall(color: AppColors.grey600),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            _buildTimelineStep('Pending', serviceItem.isPending, true),
            _buildTimelineLine(serviceItem.isInProgress || serviceItem.isCompleted),
            _buildTimelineStep('In Progress', serviceItem.isInProgress, serviceItem.isInProgress || serviceItem.isCompleted),
            _buildTimelineLine(serviceItem.isCompleted),
            _buildTimelineStep('Completed', serviceItem.isCompleted, serviceItem.isCompleted),
          ],
        ),
      ],
    );
  }

  Widget _buildTimelineStep(String label, bool isActive, bool isCompleted) {
    return Column(
      children: [
        Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? AppColors.primaryColor
                : isCompleted
                    ? AppColors.success
                    : AppColors.grey300,
          ),
          child: Center(
            child: isCompleted && !isActive
                ? Icon(Icons.check, size: 14.sp, color: Colors.white)
                : Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? Colors.white : Colors.transparent,
                    ),
                  ),
          ),
        ),
        SizedBox(height: 4.h),
        SizedBox(
          width: 60.w,
          child: Text(
            label,
            style: AppTexts.labelSmall(
              color: isActive || isCompleted ? AppColors.textPrimary : AppColors.grey500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2.h,
        margin: EdgeInsets.only(bottom: 30.h),
        color: isActive ? AppColors.success : AppColors.grey300,
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: AppColors.grey600),
        SizedBox(width: 8.w),
        Text(
          '$label: ',
          style: AppTexts.bodySmall(color: AppColors.grey600),
        ),
        Text(
          value,
          style: AppTexts.bodySmall(color: AppColors.textPrimary)
              .copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  List<PopupMenuEntry<String>> _buildMenuItems() {
    final items = <PopupMenuEntry<String>>[];

    if (serviceItem.isPending) {
      items.add(
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 18.sp, color: AppColors.grey700),
              SizedBox(width: 12.w),
              Text('Edit Project Details'),
            ],
          ),
        ),
      );
    }

    if (serviceItem.isInProgress || serviceItem.isPending) {
      items.add(
        PopupMenuItem(
          value: 'contact',
          child: Row(
            children: [
              Icon(Icons.chat_bubble_outline, size: 18.sp, color: AppColors.grey700),
              SizedBox(width: 12.w),
              Text('Contact Provider'),
            ],
          ),
        ),
      );
    }

    if (serviceItem.hasDeliveries) {
      items.add(
        PopupMenuItem(
          value: 'deliveries',
          child: Row(
            children: [
              Icon(Icons.download_outlined, size: 18.sp, color: AppColors.success),
              SizedBox(width: 12.w),
              Text('View Deliveries'),
            ],
          ),
        ),
      );
    }

    items.add(
      PopupMenuItem(
        value: 'help',
        child: Row(
          children: [
            Icon(Icons.help_outline, size: 18.sp, color: AppColors.grey700),
            SizedBox(width: 12.w),
            Text('Get Help'),
          ],
        ),
      ),
    );

    return items;
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'edit':
        onEditDetails?.call();
        break;
      case 'contact':
        onContactProvider?.call();
        break;
      case 'deliveries':
        onViewDeliveries?.call();
        break;
      case 'help':
        // TODO: Show help dialog
        break;
    }
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 24.sp),
            SizedBox(width: 8.w),
            Text('Cancel Order?', style: AppTexts.h4()),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to cancel this order? This action cannot be undone.',
              style: AppTexts.bodyMedium(color: AppColors.grey700),
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order: ${serviceItem.service?.title ?? "Service"}',
                    style: AppTexts.bodySmall(color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Amount: ${serviceItem.chargeBreakdown != null ? "₦${serviceItem.chargeBreakdown!.totalPayable.toStringAsFixed(0)}" : "N/A"}',
                    style: AppTexts.bodySmall(color: AppColors.grey700),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Keep Order'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onCancelOrder?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Cancel Order'),
          ),
        ],
      ),
    );
  }

  VoidCallback? _getPrimaryAction(BuildContext context) {
    // Always show cancel for pending or in-progress orders
    if (serviceItem.isPending || serviceItem.isInProgress) {
      return () => _showCancelDialog(context);
    } else if (serviceItem.hasDeliveries) {
      return onViewDeliveries;
    }
    return onViewDetails;
  }

  String _getPrimaryActionText() {
    // Always show "Cancel Order" for pending or in-progress orders
    if (serviceItem.isPending || serviceItem.isInProgress) {
      return 'Cancel Order';
    } else if (serviceItem.hasDeliveries) {
      return 'View Deliveries';
    }
    return 'View Details';
  }

  Color _getPrimaryActionColor() {
    // Red color for cancel button
    if (serviceItem.isPending || serviceItem.isInProgress) {
      return Colors.red;
    }
    return AppColors.primaryColor;
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.orange;
      case 'IN_PROGRESS':
      case 'ACCEPTED':
        return Colors.blue;
      case 'COMPLETED':
        return Colors.green;
      case 'REJECTED':
      case 'CANCELLED':
        return Colors.red;
      default:
        return AppColors.grey500;
    }
  }

  String _getStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'IN_PROGRESS':
        return 'In Progress';
      case 'ACCEPTED':
        return 'Accepted';
      default:
        return status[0].toUpperCase() + status.substring(1).toLowerCase();
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }
}
