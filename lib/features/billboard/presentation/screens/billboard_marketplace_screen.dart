import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/search_filter_card.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/filter_sheet.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../../../../core/widgets/delete_location_dialog.dart';
import '../../../../core/utils/html_helper.dart';
import '../../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../../../dashboard/presentation/widgets/sidebar_menu.dart';
import '../widgets/billboard_card.dart';
import '../widgets/billboard_menu_sheet.dart';
import '../../logic/billboard_provider.dart';

class BillboardMarketplaceScreen extends ConsumerStatefulWidget {
  const BillboardMarketplaceScreen({super.key});

  @override
  ConsumerState<BillboardMarketplaceScreen> createState() => _BillboardMarketplaceScreenState();
}

class _BillboardMarketplaceScreenState extends ConsumerState<BillboardMarketplaceScreen> {
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
    final billboardState = ref.watch(billboardProvider);
    final hasBillboards = billboardState.data?.isNotEmpty ?? false;
    
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
              const DashboardAppBar(title: 'BILLBOARDS'),
              
              // Content with collapsible search card
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(billboardProvider.notifier).refreshBillboards();
                  },
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      // Search Filter Card as Sliver
                      SliverToBoxAdapter(
                        child: SearchFilterCard(
                          title: 'All Billboards',
                          searchController: _searchController,
                          searchHint: 'Search billboards...',
                          onFilterTap: _showFilters,
                          onActionButtonTap: _uploadBillboard,
                          actionButtonLabel: 'Upload Billboard',
                          actionButtonIcon: Icons.upload,
                          selectedFilters: ref.read(billboardProvider.notifier).selectedFilters,
                          onRemoveFilter: (key) => ref.read(billboardProvider.notifier).removeFilter(key),
                          onClearFilters: () => ref.read(billboardProvider.notifier).clearFilters(),
                          onChanged: (query) => ref.read(billboardProvider.notifier).updateSearch(query),
                        ),
                      ),
                      
                      // Content - Loading state, Error state, Empty State or Billboard List
                      billboardState.isInitialLoading
                          ? SliverPadding(
                              padding: EdgeInsets.all(16.w),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) => const SkeletonCampaignCard(),
                                  childCount: 3,
                                ),
                              ),
                            )
                          : billboardState.message != null
                              ? SliverFillRemaining(
                                  child: EmptyState(
                                    icon: Icons.wifi_off_outlined,
                                    title: 'Connection Error',
                                    message: billboardState.message!.contains('SocketException') || billboardState.message!.contains('Failed host lookup')
                                        ? 'Failed to load billboards. Please check your internet connection and try again.'
                                        : billboardState.message!,
                                    showIconBackground: true,
                                  ),
                                )
                              : (billboardState.data ?? []).isEmpty
                                  ? const SliverFillRemaining(
                                      child: EmptyState(
                                        icon: Icons.campaign_outlined,
                                        title: 'No Billboards Yet',
                                        message: 'Start by uploading your first billboard',
                                        showIconBackground: false,
                                      ),
                                    )
                                  : SliverPadding(
                                      padding: EdgeInsets.all(16.w),
                                      sliver: SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                            final sortedData = List.of(billboardState.data ?? [])..sort((a, b) => b.createdAt.compareTo(a.createdAt));
                                            final billboard = sortedData[index];
                                            return BillboardCard(
                                              billboard: billboard,
                                              onViewSlots: () {
                                                context.push('/ad-slots', extra: {
                                                  'parentId': billboard.id,
                                                  'parentType': 'billboard',
                                                  'parentName': billboard.name,
                                                });
                                              },
                                              onMenuTap: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  backgroundColor: Colors.transparent,
                                                  builder: (context) => BillboardMenuSheet(
                                                    billboardName: billboard.name,
                                                    onEdit: () {
                                                      Navigator.pop(context);
                                                      context.push('/upload-billboard', extra: {
                                                        'isUpdate': true,
                                                        'billboard': billboard,
                                                      });
                                                    },
                                                    onDelete: () async {
                                                      Navigator.pop(context);
                                                      final confirm = await _showDeleteConfirmation(context, billboard.name);
                                                      if (confirm == true) {
                                                        try {
                                                          await ref.read(billboardProvider.notifier).deleteBillboard(billboard.id);
                                                          if (context.mounted) {
                                                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                              const SnackBar(
                                                                content: Text('Billboard deleted successfully'),
                                                                backgroundColor: Colors.green,
                                                                duration: Duration(seconds: 3),
                                                              ),
                                                            );
                                                          }
                                                        } catch (e) {
                                                          if (context.mounted) {
                                                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(
                                                                content: Text('Delete failed: ${e.toString().replaceAll('Exception: ', '')}'),
                                                                backgroundColor: Colors.red,
                                                                duration: const Duration(seconds: 3),
                                                              ),
                                                            );
                                                          }
                                                        }
                                                      }
                                                    },
                                                    onViewDetails: () {
                                                      Navigator.pop(context);
                                                      context.push('/billboard-details', extra: {'billboard': billboard});
                                                    },
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          childCount: billboardState.data?.length ?? 0,
                                        ),
                                      ),
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
    final currentFilters = ref.read(billboardProvider.notifier).selectedFilters;

    await showModalBottomSheet<Map<String, String?>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => FilterSheet(
          title: 'Billboard Filters',
          sections: [
            FilterSection(
              title: 'Location',
              options: [
                'All',
                'Abuja',
                'Lagos',
                'Port Harcourt',
                'Kano',
                'Ibadan',
              ],
              selectedValue: currentFilters['Location'],
            ),
            FilterSection(
              title: 'Size',
              options: [
                'All',
                '48ft x 14ft',
                '40ft x 20ft',
                '36ft x 12ft',
                '30ft x 10ft',
              ],
              selectedValue: currentFilters['Size'],
            ),
            FilterSection(
              title: 'Status',
              options: ['All', 'Active', 'Inactive', 'Maintenance'],
              selectedValue: currentFilters['Status'],
            ),
            FilterSection(
              title: 'Price Range',
              options: [
                'All',
                'Under ₦300k',
                '₦300k - ₦500k',
                '₦500k - ₦1M',
                'Above ₦1M',
              ],
              selectedValue: currentFilters['Price Range'],
            ),
          ],
          onApply: (selectedFilters) {
            ref.read(billboardProvider.notifier).updateFilters(selectedFilters);
          },
        ),
      ),
    );
  }

  void _uploadBillboard() {
    context.push('/upload-billboard');
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context, String billboardName) {
    return DeleteLocationDialog.show(context);
  }
}
