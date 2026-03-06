import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../orders/logic/orders_provider.dart';
import '../../../../orders/presentation/widgets/order_card.dart';
import '../../../../../core/widgets/empty_state.dart';

class RecentOrdersSection extends ConsumerWidget {
  const RecentOrdersSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final ordersState = ref.watch(ordersProvider);
    final recentOrders = ordersState.orders.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Orders',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            TextButton(
              onPressed: () {
                context.push('/orders');
              },
              child: Text(
                'View All',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        recentOrders.isEmpty
            ? EmptyState(
                icon: Icons.receipt_long_outlined,
                title: 'No Orders Yet',
                message: 'Orders from customers will appear here',
                showIconBackground: false,
              )
            : Column(
                children: recentOrders.map((order) {
                  return OrderCard(
                    order: order,
                    onTap: () {
                      context.push('/order-details', extra: {'order': order});
                    },
                  );
                }).toList(),
              ),
      ],
    );
  }
}
