import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../../../../dashboard/presentation/widgets/sidebar_menu.dart';
import '../../../../../core/widgets/search_filter_card.dart';
import '../../../../../core/widgets/filter_sheet.dart';
import '../../../../../core/widgets/empty_state.dart';
import 'widgets/service_list.dart';

class ServiceMarketplaceScreen extends ConsumerStatefulWidget {
  const ServiceMarketplaceScreen({super.key});

  @override
  ConsumerState<ServiceMarketplaceScreen> createState() =>
      _ServiceMarketplaceScreenState();
}

class _ServiceMarketplaceScreenState
    extends ConsumerState<ServiceMarketplaceScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // TODO: Replace with actual data from API/Provider
  final bool _hasServices = true; // Change to false when no data

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
              const DashboardAppBar(title: 'SERVICES'),
              
              // Content with collapsible search card
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    // Search Filter Card as Sliver
                    SliverToBoxAdapter(
                      child: SearchFilterCard(
                        title: 'All Services',
                        searchController: _searchController,
                        searchHint: 'Search services...',
                        onFilterTap: _showFilters,
                        onActionButtonTap: _addService,
                        actionButtonLabel: 'Add Service',
                        actionButtonIcon: Icons.add_business,
                      ),
                    ),
                    
                    // Content - Empty State or Service List
                    _hasServices
                        ? SliverFillRemaining(
                            child: const ServiceList(),
                          )
                        : SliverFillRemaining(
                            child: const EmptyState(
                              icon: Icons.business_center_outlined,
                              title: 'No Services Yet',
                              message: 'Start by adding your first service',
                              showIconBackground: false,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showFilters() async {
    final filters = await showModalBottomSheet<Map<String, String?>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => FilterSheet(
          title: 'Service Filters',
          sections: [
            FilterSection(
              title: 'Category',
              options: [
                'All',
                'Graphic Design',
                'Video Production',
                'Content Writing',
                'Photography',
                'Marketing',
                'Consulting',
                'Other',
              ],
            ),
            FilterSection(
              title: 'Price Range',
              options: ['Under ₦10,000', '₦10,000 - ₦50,000', '₦50,000 - ₦100,000', 'Above ₦100,000'],
            ),
            FilterSection(
              title: 'Status',
              options: ['Active', 'Inactive', 'Pending'],
            ),
            FilterSection(
              title: 'Rating',
              options: [
                '1 ⭐ & Above',
                '2 ⭐ & Above',
                '3 ⭐ & Above',
                '4 ⭐ & Above',
                '5 ⭐',
              ],
            ),
          ],
          onApply: (selectedFilters) {
            // TODO: Apply filters
            print('Selected filters: $selectedFilters');
          },
        ),
      ),
    );
  }

  void _addService() {
    // TODO: Navigate to add service screen
    // context.push('/add-service');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Add Service feature coming soon'),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}
