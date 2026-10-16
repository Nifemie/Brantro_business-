import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/order_model.dart';
import '../../logic/orders_provider.dart';
import 'order_decision_dialog.dart';
import 'order_progress_dialog.dart';
import 'order_delivery_dialog.dart';

class OrderActionButtons extends ConsumerWidget {
  final OrderModel order;
  final bool isDark;

  const OrderActionButtons({
    super.key,
    required this.order,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemStatusLower = (order.itemStatus ?? '').toLowerCase();
    final isRejected = itemStatusLower == 'rejected' ||
        itemStatusLower == 'cancelled' ||
        itemStatusLower == 'failed';
    final isAcceptedOrInProgress = itemStatusLower == 'accepted' ||
        itemStatusLower == 'inprogress' ||
        itemStatusLower == 'in_progress' ||
        itemStatusLower == 'active';

    final items = order.metadata?['items'] as List<dynamic>? ?? [];
    final hasPendingItems = !isAcceptedOrInProgress &&
        !isRejected &&
        items.any((item) => item['status']?.toString().toLowerCase() == 'pending');

    final isPending = !isAcceptedOrInProgress &&
        !isRejected &&
        (order.status.toLowerCase() == 'pending' || hasPendingItems);
    final isPaid = order.status.toLowerCase() == 'paid';

    final isRevisionRequested = itemStatusLower == 'revision_requested' ||
        order.status.toLowerCase() == 'revision_requested' ||
        items.any((item) => item['status']?.toString().toLowerCase() == 'revision_requested');

    final hasInProgressItems = isAcceptedOrInProgress ||
        items.any((item) =>
            item['status']?.toString().toLowerCase() == 'inprogress' ||
            item['status']?.toString().toLowerCase() == 'in_progress' ||
            item['status']?.toString().toLowerCase() == 'active' ||
            item['status']?.toString().toLowerCase() == 'accepted');

    return Column(
      children: [
        if (isRevisionRequested) ...[
          _buildResubmitWorkButton(context, ref),
          SizedBox(height: 12.h),
        ],
        if ((isPending || (isPaid && hasPendingItems)) && !isAcceptedOrInProgress && !isRejected && !isRevisionRequested) ...[
          _buildAcceptButton(context, ref),
          SizedBox(height: 12.h),
          _buildDeclineButton(context, ref),
        ],
        if (hasInProgressItems && !isRejected && !isRevisionRequested) ...[
          _buildUpdateProgressButton(context, ref),
          SizedBox(height: 12.h),
          _buildDeliverButton(context, ref),
          SizedBox(height: 12.h),
        ],
        if (order.status.toLowerCase() == 'active') ...[
          _buildCompleteButton(context, ref),
        ],
      ],
    );
  }

  Widget _buildUpdateProgressButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _handleUpdateProgress(context, ref),
        icon: Icon(Icons.update, size: 20.sp),
        label: Text('Update Progress', style: TextStyle(fontSize: 16.sp)),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFF76301),
          side: const BorderSide(color: Color(0xFFF76301)),
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }

  Widget _buildResubmitWorkButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _handleDeliverWork(context, ref),
        icon: Icon(Icons.replay_rounded, size: 20.sp),
        label: Text('Re-submit Revised Work', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF76301),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildDeliverButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _handleDeliverWork(context, ref),
        icon: Icon(Icons.send_rounded, size: 20.sp),
        label: Text('Submit Final Work', style: TextStyle(fontSize: 16.sp)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3B82F6),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildAcceptButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _handleAcceptOrder(context, ref),
        icon: Icon(Icons.check_circle_outline, size: 20.sp),
        label: Text('Accept Order', style: TextStyle(fontSize: 16.sp)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF10B981),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildDeclineButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _handleDeclineOrder(context, ref),
        icon: Icon(Icons.cancel_outlined, size: 20.sp),
        label: Text('Decline Order', style: TextStyle(fontSize: 16.sp)),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }

  Widget _buildCompleteButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _handleCompleteOrder(context, ref),
        icon: Icon(Icons.done_all, size: 20.sp),
        label: Text('Mark as Completed', style: TextStyle(fontSize: 16.sp)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3B82F6),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 0,
        ),
      ),
    );
  }
  void _handleAcceptOrder(BuildContext context, WidgetRef ref) {
    _showDecisionDialog(context, ref, true);
  }

  void _handleDeclineOrder(BuildContext context, WidgetRef ref) {
    _showDecisionDialog(context, ref, false);
  }

  void _handleUpdateProgress(BuildContext context, WidgetRef ref) {
    if (order.serviceType.toLowerCase() != 'service') {
      return;
    }

    final items = order.metadata?['items'] as List<dynamic>? ?? [];
    if (items.isEmpty) return;

    final itemId = items[0]['id'];
    final numericId = order.metadata?['id']?.toString() ?? order.id;
    final detailKey = (id: numericId, type: order.serviceType.toLowerCase());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OrderProgressDialog(
        itemId: itemId,
        onSuccess: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Progress Updated Successfully'),
              backgroundColor: Colors.green,
            ),
          );
          ref.invalidate(orderDetailProvider(detailKey));
          ref.read(ordersProvider(null).notifier).refreshOrders();
        },
      ),
    );
  }

  void _handleDeliverWork(BuildContext context, WidgetRef ref) {
    if (order.serviceType.toLowerCase() != 'service') return;

    final items = order.metadata?['items'] as List<dynamic>? ?? [];
    if (items.isEmpty) return;

    final itemId = items[0]['id'];
    final numericId = order.metadata?['id']?.toString() ?? order.id;
    final detailKey = (id: numericId, type: order.serviceType.toLowerCase());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OrderDeliveryDialog(
        itemId: itemId,
        onSuccess: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Work Delivered Successfully'),
              backgroundColor: Colors.green,
            ),
          );
          ref.read(ordersProvider(null).notifier).updateOrderStatus(
            order.id,
            'delivered',
            itemStatus: 'DELIVERED',
          );
          ref.invalidate(orderDetailProvider(detailKey));
          ref.read(ordersProvider(null).notifier).refreshOrders();
        },
      ),
    );
  }

  void _showDecisionDialog(BuildContext context, WidgetRef ref, bool isAccept) {
    if (order.serviceType.toLowerCase() != 'service') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Decisions can only be made on service orders.')),
      );
      return;
    }

    final items = order.metadata?['items'] as List<dynamic>? ?? [];
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No item found in this order.')),
      );
      return;
    }

    final itemId = items[0]['id'];
    final numericId = order.metadata?['id']?.toString() ?? order.id;
    final detailKey = (id: numericId, type: order.serviceType.toLowerCase());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OrderDecisionDialog(
        itemId: itemId,
        isAccept: isAccept,
        onSuccess: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isAccept ? 'Order Accepted Successfully' : 'Order Rejected Successfully'),
              backgroundColor: isAccept ? Colors.green : Colors.red,
            ),
          );
          // 1. Instantly update local state so UI buttons swap immediately
          ref.read(ordersProvider(null).notifier).updateOrderStatus(
            order.id,
            isAccept ? 'in_progress' : 'failed',
            itemStatus: isAccept ? 'ACCEPTED' : 'REJECTED',
          );
          // 2. Invalidate order detail provider to refetch server data in background
          ref.invalidate(orderDetailProvider(detailKey));
          // 3. Refresh orders list provider
          ref.read(ordersProvider(null).notifier).refreshOrders();
        },
      ),
    );
  }

  Future<void> _handleCompleteOrder(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Order'),
        content: const Text('Mark this order as completed?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Complete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(ordersProvider(null).notifier).updateOrderStatus(order.id, 'completed');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order marked as completed'),
            backgroundColor: Color(0xFF3B82F6),
          ),
        );
        Navigator.pop(context);
      }
    }
  }
}
