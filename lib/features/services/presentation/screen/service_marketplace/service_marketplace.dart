import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../../../../dashboard/presentation/widgets/sidebar_menu.dart';
import '../../../../../core/widgets/search_filter_card.dart';
import '../../../../../core/widgets/filter_sheet.dart';
import '../../../../../core/widgets/empty_state.dart';
import '../../../../../core/widgets/skeleton_loading.dart';
import '../../../logic/service_provider.dart';
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
    final serviceState = ref.watch(serviceProvider);

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
              
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(serviceProvider.notifier).refreshServices();
                  },
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
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
                          selectedFilters: ref.read(serviceProvider.notifier).selectedFilters,
                          onRemoveFilter: (key) => ref.read(serviceProvider.notifier).removeFilter(key),
                          onClearFilters: () => ref.read(serviceProvider.notifier).clearFilters(),
                          onChanged: (query) => ref.read(serviceProvider.notifier).updateSearch(query),
                        ),
                      ),
                      
                      // Content - Loading state, Error state, Empty state or Service List
                      if (serviceState.isInitialLoading)
                        SliverPadding(
                          padding: EdgeInsets.all(16.w),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => const SkeletonCampaignCard(),
                              childCount: 3,
                            ),
                          ),
                        )
                      else if (serviceState.message != null)
                        SliverFillRemaining(
                          child: EmptyState(
                            icon: Icons.wifi_off_outlined,
                            title: 'Connection Error',
                            message: serviceState.message!.contains('SocketException') || serviceState.message!.contains('Failed host lookup')
                                ? 'Failed to load services. Please check your internet connection and try again.'
                                : serviceState.message!,
                            showIconBackground: true,
                          ),
                        )
                      else if ((serviceState.data ?? []).isEmpty)
                        const SliverFillRemaining(
                          child: EmptyState(
                            icon: Icons.business_center_outlined,
                            title: 'No Services Yet',
                            message: 'Start by adding your first service',
                            showIconBackground: false,
                          ),
                        )
                      else
                        const SliverToBoxAdapter(
                          child: ServiceList(),
                        ),
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

  Future<void> _showFilters() async {
    final currentFilters = ref.read(serviceProvider.notifier).selectedFilters;

    await showModalBottomSheet<Map<String, String?>>(
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
              selectedValue: currentFilters['Category'],
            ),
            FilterSection(
              title: 'Price Range',
              options: ['All', 'Under ₦10,000', '₦10,000 - ₦50,000', '₦50,000 - ₦100,000', 'Above ₦100,000'],
              selectedValue: currentFilters['Price Range'],
            ),
            FilterSection(
              title: 'Status',
              options: ['All', 'Active', 'Inactive', 'Pending'],
              selectedValue: currentFilters['Status'],
            ),
            FilterSection(
              title: 'Rating',
              options: [
                'All',
                '1 ⭐ & Above',
                '2 ⭐ & Above',
                '3 ⭐ & Above',
                '4 ⭐ & Above',
                '5 ⭐',
              ],
              selectedValue: currentFilters['Rating'],
            ),
          ],
          onApply: (selectedFilters) {
            ref.read(serviceProvider.notifier).updateFilters(selectedFilters);
          },
        ),
      ),
    );
  }

  void _addService() {
    context.push('/upload-service');
  }
}
