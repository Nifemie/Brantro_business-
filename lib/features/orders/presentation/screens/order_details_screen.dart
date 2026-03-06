import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../../data/models/order_model.dart';
import '../widgets/order_info_card.dart';
import '../widgets/order_customer_card.dart';
import '../widgets/order_action_buttons.dart';

class OrderDetailsScreen extends ConsumerWidget {
  final OrderModel order;

  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const DashboardAppBar(title: 'ORDER DETAILS'),
            
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    OrderInfoCard(order: order, isDark: isDark),
                    SizedBox(height: 16.h),
                    OrderCustomerCard(order: order, isDark: isDark),
                    SizedBox(height: 16.h),
                    OrderActionButtons(order: order, isDark: isDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
