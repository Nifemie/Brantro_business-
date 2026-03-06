import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/search_filter_card.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/filter_sheet.dart';
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
    final hasBillboards = billboardState.billboards.isNotEmpty;
    
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
                child: CustomScrollView(
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
                      ),
                    ),
                    
                    // Content - Empty State or Billboard List
                    hasBillboards
                        ? SliverPadding(
                            padding: EdgeInsets.all(16.w),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final billboard = billboardState.billboards[index];
                                  return BillboardCard(
                                    image: billboard.images.isNotEmpty ? billboard.images.first : '',
                                    name: billboard.name,
                                    location: billboard.address,
                                    size: billboard.size,
                                    price: '₦${billboard.price.toStringAsFixed(0)}/month',
                                    isActive: billboard.isActive,
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
                                            print('Edit ${billboard.name}');
                                          },
                                          onDelete: () async {
                                            Navigator.pop(context);
                                            final confirm = await _showDeleteConfirmation(context, billboard.name);
                                            if (confirm == true) {
                                              try {
                                                await ref.read(billboardProvider.notifier).deleteBillboard(billboard.id);
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      content: Text('Billboard deleted successfully'),
                                                      backgroundColor: Colors.green,
                                                    ),
                                                  );
                                                }
                                              } catch (e) {
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text('Delete failed: ${e.toString()}'),
                                                      backgroundColor: Colors.red,
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
                                childCount: billboardState.billboards.length,
                              ),
                            ),
                          )
                        : SliverFillRemaining(
                            child: const EmptyState(
                              icon: Icons.campaign_outlined,
                              title: 'No Billboards Yet',
                              message: 'Start by uploading your first billboard',
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
            ),
            FilterSection(
              title: 'Status',
              options: ['All', 'Active', 'Inactive', 'Maintenance'],
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

  void _uploadBillboard() {
    context.push('/upload-billboard');
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context, String billboardName) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Billboard'),
        content: Text('Are you sure you want to delete "$billboardName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
