import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/filter_tab_bar.dart';
import '../../logic/orders_provider.dart';
import '../widgets/order_card.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  int _selectedFilterIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _filterTabs = [
    {'label': 'All', 'value': 'all'},
    {'label': 'Billboards', 'value': 'billboard'},
    {'label': 'Screens', 'value': 'screen'},
    {'label': 'Walls', 'value': 'wall'},
    {'label': 'Templates', 'value': 'template'},
    {'label': 'Creatives', 'value': 'creative'},
    {'label': 'Services', 'value': 'service'},
    {'label': 'Vettings', 'value': 'vetting'},
  ];

  String get _selectedFilter => _filterTabs[_selectedFilterIndex]['value']!;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final ordersState = ref.watch(ordersProvider);

    // Filter orders based on selected filter
    final filteredOrders = _selectedFilter == 'all'
        ? ordersState.orders
        : ordersState.orders.where((order) => order.serviceType == _selectedFilter).toList();

    return Column(
      children: [
        // Search Bar
        Padding(
          padding: EdgeInsets.all(16.w),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search orders...',
              hintStyle: TextStyle(
                color: isDark ? Colors.white38 : Colors.grey[400],
                fontSize: 14.sp,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: isDark ? Colors.white38 : Colors.grey[400],
              ),
              filled: true,
              fillColor: isDark ? Colors.grey[850] : Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: theme.primaryColor,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
            onChanged: (value) {
              // TODO: Implement search functionality
            },
          ),
        ),

        // Filter Tabs
        FilterTabBar(
          tabs: _filterTabs.map((tab) => tab['label']!).toList(),
          selectedIndex: _selectedFilterIndex,
          onTabSelected: (index) {
            setState(() {
              _selectedFilterIndex = index;
            });
          },
        ),

        SizedBox(height: 16.h),

        // Orders List
        Expanded(
          child: filteredOrders.isEmpty
              ? EmptyState(
                  icon: Icons.receipt_long_outlined,
                  title: 'No Orders Yet',
                  message: _selectedFilter == 'all'
                      ? 'Orders from customers will appear here'
                      : 'No ${_filterTabs.firstWhere((tab) => tab['value'] == _selectedFilter)['label']} orders yet',
                  showIconBackground: false,
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(ordersProvider.notifier).refreshOrders();
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return OrderCard(
                        order: order,
                        onTap: () {
                          context.push('/order-details', extra: {'order': order});
                        },
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
