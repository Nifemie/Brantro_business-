import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/network/api_client.dart';
import '../../../data/models/order_model.dart';

class OrderCardHeader extends StatelessWidget {
  final OrderModel order;
  final bool isDark;

  const OrderCardHeader({
    super.key,
    required this.order,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
          child: Image.network(
            order.imageUrl != null 
              ? '${ApiClient.fileBaseUrl}/${order.imageUrl}'
              : 'https://picsum.photos/seed/${order.id}/600/200', // Mock Image fallback
            height: 120.h,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 120.h,
                width: double.infinity,
                color: Colors.grey[300],
                child: Icon(Icons.image, color: Colors.grey[500], size: 40.sp),
              );
            },
          ),
        ),
        Positioned(
          bottom: 12.h,
          right: 12.w,
          child: _buildStatusBadge(),
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    final statusConfig = _getStatusConfig(order.effectiveStatus);
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: statusConfig['color'],
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        statusConfig['label'],
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Map<String, dynamic> _getStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return {
          'label': 'Pending',
          'color': const Color(0xFFF59E0B),
        };
      case 'in_progress':
      case 'inprogress':
      case 'accepted':
        return {
          'label': 'InProgress',
          'color': const Color(0xFFF76301), // Orange
        };
      case 'delivered':
        return {
          'label': 'Delivered',
          'color': const Color(0xFF8B5CF6), // Purple
        };
      case 'active':
        return {
          'label': 'Active',
          'color': const Color(0xFF10B981),
        };
      case 'completed':
      case 'approved':
      case 'success':
        return {
          'label': 'Completed',
          'color': const Color(0xFF3B82F6),
        };
      case 'cancelled':
        return {
          'label': 'Cancelled',
          'color': const Color(0xFFEF4444),
        };
      case 'rejected':
        return {
          'label': 'Rejected',
          'color': const Color(0xFFEF4444),
        };
      case 'failed':
        return {
          'label': 'Failed',
          'color': const Color(0xFFEF4444),
        };
      default:
        final cleanLabel = status.replaceAll('_', ' ');
        return {
          'label': cleanLabel.isEmpty
              ? 'Unknown'
              : cleanLabel[0].toUpperCase() + cleanLabel.substring(1).toLowerCase(),
          'color': Colors.grey,
        };
    }
  }
}
