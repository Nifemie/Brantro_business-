import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/filter_tab_bar.dart';
import '../../data/models/order_model.dart';
import '../../logic/orders_provider.dart';
import '../widgets/order_card.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/dashboard_app_bar.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  final Map<String, String>? filters;
  final bool showBackButton;
  const OrdersScreen({
    super.key,
    this.filters,
    this.showBackButton = false,
  });

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  int _selectedFilterIndex = 0;
  int _selectedCategoryIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final ordersState = ref.watch(ordersProvider(widget.filters));

    final filterTabs = const [
      {'label': 'All', 'value': 'all'},
      {'label': 'Pending', 'value': 'pending'},
      {'label': 'In Progress', 'value': 'in_progress'},
      {'label': 'Delivered', 'value': 'delivered'},
      {'label': 'Completed', 'value': 'completed'},
      {'label': 'Failed', 'value': 'failed'},
    ];

    /*
    final categoryTabs = const [
      {'label': 'All', 'value': 'all'},
      {'label': 'Services', 'value': 'service'},
      {'label': 'Templates', 'value': 'template'},
      {'label': 'Creatives', 'value': 'creative'},
      {'label': 'Ad Slots', 'value': 'ad_slot'},
      {'label': 'Others', 'value': 'others'},
    ];
    */

    final safeFilterIndex = _selectedFilterIndex >= filterTabs.length ? 0 : _selectedFilterIndex;
    final selectedFilter = filterTabs[safeFilterIndex]['value']!;
    
    /*
    final safeCategoryIndex = _selectedCategoryIndex >= categoryTabs.length ? 0 : _selectedCategoryIndex;
    final selectedCategory = categoryTabs[safeCategoryIndex]['value']!;
    */

    // Filter orders based on selected status filter and search query
    final List<OrderModel> currentOrders = ordersState.data ?? [];
    final filteredOrders = currentOrders.where((order) {
      // 1. Filter by search query
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesSearch = order.id.toLowerCase().contains(query) ||
            order.serviceName.toLowerCase().contains(query) ||
            order.customerName.toLowerCase().contains(query);
        if (!matchesSearch) return false;
      }

      // 2. Filter by status
      if (selectedFilter == 'all') return true;

      final orderStatus = order.effectiveStatus.toLowerCase();
      if (selectedFilter == 'pending') {
        return orderStatus == 'pending';
      } else if (selectedFilter == 'failed') {
        return orderStatus == 'failed' || orderStatus == 'cancelled';
      } else if (selectedFilter == 'in_progress') {
        return orderStatus == 'in_progress' || orderStatus == 'inprogress';
      } else if (selectedFilter == 'delivered') {
        return orderStatus == 'delivered';
      } else if (selectedFilter == 'completed') {
        return orderStatus == 'success' || orderStatus == 'completed' || orderStatus == 'approved';
      }
      return false;
    }).toList();

    Widget content = Column(
      children: [
        DashboardAppBar(title: 'ORDERS', showBackButton: widget.showBackButton),
        // Search Bar
        Padding(
          padding: EdgeInsets.all(16.w),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search orders by ID, Service, or Customer...',
              hintStyle: TextStyle(
                color: isDark ? Colors.white38 : Colors.grey[400],
                fontSize: 14.sp,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: isDark ? Colors.white38 : Colors.grey[400],
              ),
              suffixIcon: _searchQuery.isNotEmpty 
                ? IconButton(
                    icon: Icon(Icons.clear, color: isDark ? Colors.white54 : Colors.grey[600], size: 20.sp),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  ) 
                : null,
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
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),

        /*
        // Category Chips
        SizedBox(
          height: 40.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: categoryTabs.length,
            itemBuilder: (context, index) {
              final tab = categoryTabs[index];
              final isSelected = _selectedCategoryIndex == index;
              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: ChoiceChip(
                  label: Text(
                    tab['label']!,
                    style: TextStyle(
                      color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 13.sp,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: theme.primaryColor,
                  backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    side: BorderSide(
                      color: isSelected ? theme.primaryColor : Colors.transparent,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        */

        SizedBox(height: 16.h),

        // Filter Tabs
        FilterTabBar(
          tabs: filterTabs.map((tab) => tab['label']!).toList(),
          selectedIndex: safeFilterIndex,
          onTabSelected: (index) {
            setState(() {
              _selectedFilterIndex = index;
            });
          },
        ),

        SizedBox(height: 16.h),

        // Orders List
        Expanded(
          child: ordersState.isInitialLoading && filteredOrders.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : filteredOrders.isEmpty
                  ? const EmptyState(
                      icon: Icons.receipt_long_outlined,
                      title: 'No Orders Yet',
                      message: 'No orders match this filter',
                      showIconBackground: false,
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await ref.read(ordersProvider(widget.filters).notifier).refreshOrders();
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

    if (widget.showBackButton) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: content,
        ),
      );
    }

    return content;
  }
}
