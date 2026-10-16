import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../../data/models/order_model.dart';
import '../widgets/order_info_card.dart';
import '../widgets/order_customer_card.dart';
import '../widgets/order_action_buttons.dart';
import '../widgets/order_charge_breakdown_card.dart';
import '../widgets/order_items_card.dart';
import '../widgets/order_requirements_card.dart';
import '../widgets/order_rejection_card.dart';
import '../../logic/orders_provider.dart';

class OrderDetailsScreen extends ConsumerWidget {
  final OrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Fetch full details in the background using the true numeric ID
    final numericId = order.metadata?['id']?.toString() ?? order.id;
    final detailKey = (id: numericId, type: order.serviceType.toLowerCase());
    final detailState = ref.watch(orderDetailProvider(detailKey));

    // Watch the orders provider to auto-update the UI when an action is performed
    final ordersState = ref.watch(ordersProvider(null));
    final localOrder = ordersState.data?.firstWhere(
          (o) => o.id == order.id,
          orElse: () => order,
        ) ??
        order;

    // Prefer the fully detailed order if loaded, but keep the optimistic status & metadata in sync
    final baseDetailed = detailState.value;
    final currentOrder = baseDetailed != null
        ? baseDetailed.copyWith(
            status: localOrder.status,
            itemStatus: localOrder.itemStatus ?? baseDetailed.itemStatus,
            metadata: localOrder.metadata ?? baseDetailed.metadata,
          )
        : localOrder;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const DashboardAppBar(title: 'ORDER DETAILS'),
            if (detailState.isLoading)
              LinearProgressIndicator(minHeight: 2.h),

            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(orderDetailProvider(detailKey));
                  await ref.read(ordersProvider(null).notifier).refreshOrders();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      OrderInfoCard(order: currentOrder, isDark: isDark),
                      SizedBox(height: 16.h),
                      if (currentOrder.itemStatus?.toUpperCase() == 'REJECTED') ...[
                        OrderRejectionCard(order: currentOrder, isDark: isDark),
                        SizedBox(height: 16.h),
                      ],
                      OrderCustomerCard(order: currentOrder, isDark: isDark),
                      SizedBox(height: 16.h),
                      OrderItemsCard(order: currentOrder, isDark: isDark),
                      SizedBox(height: 16.h),
                      if (currentOrder.serviceType == 'service' ||
                          currentOrder.serviceType == 'template' ||
                          currentOrder.serviceType == 'creative') ...[
                        OrderRequirementsCard(
                          order: currentOrder,
                          isDark: isDark,
                        ),
                        SizedBox(height: 16.h),
                      ],
                      OrderChargeBreakdownCard(
                        order: currentOrder,
                        isDark: isDark,
                      ),
                      SizedBox(height: 16.h),
                      OrderActionButtons(order: currentOrder, isDark: isDark),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
