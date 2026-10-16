import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../orders/logic/orders_provider.dart';
import '../../../../orders/presentation/widgets/order_card.dart';
import '../../../../../core/widgets/empty_state.dart';
import 'package:brantro_business/features/dashboard/logic/dashboard_navigation_provider.dart';
import 'package:go_router/go_router.dart';

class RecentOrdersSection extends ConsumerWidget {
  const RecentOrdersSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final ordersState = ref.watch(ordersProvider(null));
    final sortedData = List.of(ordersState.data ?? [])..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final recentOrders = sortedData.take(3).toList();

    if (recentOrders.isEmpty) return const SizedBox.shrink();

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
                ref.read(dashboardNavigationProvider.notifier).state = 1;
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
        Column(
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
