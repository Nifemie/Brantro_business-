import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../widgets/billboard_order_card.dart';

class BillboardOrdersScreen extends ConsumerWidget {
  final String billboardId;

  const BillboardOrdersScreen({
    super.key,
    required this.billboardId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    // TODO: Fetch orders from provider filtered by billboardId
    final orders = _getMockOrders();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const DashboardAppBar(title: 'BILLBOARD ORDERS'),
            
            Expanded(
              child: orders.isEmpty
                  ? const EmptyState(
                      icon: Icons.shopping_bag_outlined,
                      title: 'No Orders Yet',
                      message: 'Orders for this billboard will appear here',
                      showIconBackground: false,
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(16.w),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return BillboardOrderCard(
                          orderId: order['orderId']!,
                          customerName: order['customerName']!,
                          amount: order['amount']!,
                          status: order['status']!,
                          startDate: order['startDate']!,
                          endDate: order['endDate']!,
                          onTap: () {
                            // TODO: Navigate to order details
                            print('View order ${order['orderId']}');
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _getMockOrders() {
    return [
      {
        'orderId': 'ORD-001',
        'customerName': 'Acme Corporation',
        'amount': '₦500,000',
        'status': 'active',
        'startDate': '2024-03-01',
        'endDate': '2024-03-31',
      },
      {
        'orderId': 'ORD-002',
        'customerName': 'Tech Solutions Ltd',
        'amount': '₦500,000',
        'status': 'pending',
        'startDate': '2024-04-01',
        'endDate': '2024-04-30',
      },
    ];
  }
}
