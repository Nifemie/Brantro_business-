import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../../../../dashboard/presentation/widgets/sidebar_menu.dart';
import 'package:brantro_business/core/widgets/marketplace_search_bar.dart';
import 'widgets/service_list.dart';
import 'widgets/simple_search_bar.dart';
import 'widgets/service_filter_panel.dart';
import 'widgets/product_price_filter.dart';

class ServiceMarketplaceScreen extends ConsumerStatefulWidget {
  const ServiceMarketplaceScreen({super.key});

  @override
  ConsumerState<ServiceMarketplaceScreen> createState() =>
      _ServiceMarketplaceScreenState();
}

class _ServiceMarketplaceScreenState
    extends ConsumerState<ServiceMarketplaceScreen> {
  String _selectedStatus = '';

  Future<bool> _onWillPop() async {
    if (mounted) {
      context.go('/dashboard');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          await _onWillPop();
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        drawer: const SidebarMenu(),
        body: SafeArea(
          child: Column(
            children: [
              const DashboardAppBar(title: 'SERVICE GRID'),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: MarketplaceSearchBar(
                  currentStatus: _selectedStatus,
                  onAddServicePressed: () {},
                  onStatusChanged: (status) {
                    setState(() {
                      _selectedStatus = status == 'All' ? '' : status;
                    });
                  },
                  onSearchChanged: (value) {},
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Our 3 Mock Service Cards
                      const ServiceList(),

                      SizedBox(height: 16.h),

                      // The new Simple Search Bar
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: const SimpleSearchBar(),
                      ),

                      SizedBox(height: 24.h),

                      // The new comprehensive Filter Sidebar Panel
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: const ServiceFilterPanel(),
                      ),

                      SizedBox(height: 24.h),

                      // The new Product Price Filter Panel
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: ProductPriceFilter(
                          onPriceChanged: (range) {
                            // TODO: Handle price filtering
                          },
                        ),
                      ),

                      SizedBox(height: 48.h), // Bottom padding
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
