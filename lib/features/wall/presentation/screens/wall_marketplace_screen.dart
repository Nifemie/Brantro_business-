import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/search_filter_card.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/filter_sheet.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../../../../core/widgets/delete_location_dialog.dart';
import '../../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../../../dashboard/presentation/widgets/sidebar_menu.dart';
import '../widgets/wall_card.dart';
import '../widgets/wall_menu_sheet.dart';
import '../../logic/wall_provider.dart';

class WallMarketplaceScreen extends ConsumerStatefulWidget {
  const WallMarketplaceScreen({super.key});

  @override
  ConsumerState<WallMarketplaceScreen> createState() => _WallMarketplaceScreenState();
}

class _WallMarketplaceScreenState extends ConsumerState<WallMarketplaceScreen> {
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
    final wallState = ref.watch(wallProvider);
    
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
              const DashboardAppBar(title: 'WALLS'),
              
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(wallProvider.notifier).refreshWalls();
                  },
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: SearchFilterCard(
                          title: 'All Walls',
                          searchController: _searchController,
                          searchHint: 'Search walls...',
                          onFilterTap: _showFilters,
                          onActionButtonTap: _uploadWall,
                          actionButtonLabel: 'Upload Wall',
                          actionButtonIcon: Icons.upload,
                          selectedFilters: ref.read(wallProvider.notifier).selectedFilters,
                          onRemoveFilter: (key) => ref.read(wallProvider.notifier).removeFilter(key),
                          onClearFilters: () => ref.read(wallProvider.notifier).clearFilters(),
                          onChanged: (query) => ref.read(wallProvider.notifier).updateSearch(query),
                        ),
                      ),
                      
                      wallState.isInitialLoading
                          ? SliverPadding(
                              padding: EdgeInsets.all(16.w),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) => const SkeletonCampaignCard(),
                                  childCount: 3,
                                ),
                              ),
                            )
                          : wallState.message != null
                              ? SliverFillRemaining(
                                  child: EmptyState(
                                    icon: Icons.wifi_off_outlined,
                                    title: 'Connection Error',
                                    message: wallState.message!.contains('SocketException') || wallState.message!.contains('Failed host lookup')
                                        ? 'Failed to load walls. Please check your internet connection and try again.'
                                        : wallState.message!,
                                    showIconBackground: true,
                                  ),
                                )
                              : (wallState.data ?? []).isEmpty
                                  ? const SliverFillRemaining(
                                      child: EmptyState(
                                        icon: Icons.wallpaper_outlined,
                                        title: 'No Walls Yet',
                                        message: 'Start by uploading your first wall',
                                        showIconBackground: false,
                                      ),
                                    )
                                  : SliverPadding(
                                      padding: EdgeInsets.all(16.w),
                                      sliver: SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                            final sortedData = List.of(wallState.data ?? [])..sort((a, b) => b.createdAt.compareTo(a.createdAt));
                                            final wall = sortedData[index];
                                            return WallCard(
                                              wall: wall,
                                              onViewSlots: () {
                                                context.push('/ad-slots', extra: {
                                                  'parentId': wall.id,
                                                  'parentType': 'wall',
                                                  'parentName': wall.name,
                                                });
                                              },
                                              onMenuTap: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  backgroundColor: Colors.transparent,
                                                  builder: (context) => WallMenuSheet(
                                                    wallName: wall.name,
                                                    onEdit: () {
                                                      Navigator.pop(context);
                                                      context.push('/upload-wall', extra: {
                                                        'isUpdate': true,
                                                        'wall': wall,
                                                      });
                                                    },
                                                    onDelete: () async {
                                                      Navigator.pop(context);
                                                      final confirm = await _showDeleteConfirmation(context, wall.name);
                                                      if (confirm == true) {
                                                        try {
                                                          await ref.read(wallProvider.notifier).deleteWall(wall.id);
                                                          if (context.mounted) {
                                                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                              const SnackBar(
                                                                content: Text('Wall deleted successfully'),
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
                                                      context.push('/wall-details', extra: {'wall': wall});
                                                    },
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          childCount: wallState.data?.length ?? 0,
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
    final currentFilters = ref.read(wallProvider.notifier).selectedFilters;

    await showModalBottomSheet<Map<String, String?>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => FilterSheet(
          title: 'Wall Filters',
          sections: [
            FilterSection(
              title: 'Location',
              options: ['All', 'Abuja', 'Lagos', 'Port Harcourt', 'Kano', 'Ibadan'],
              selectedValue: currentFilters['Location'],
            ),
            FilterSection(
              title: 'Size',
              options: ['All', '30ft x 15ft', '25ft x 12ft', '20ft x 10ft', '15ft x 8ft'],
              selectedValue: currentFilters['Size'],
            ),
            FilterSection(
              title: 'Status',
              options: ['All', 'Active', 'Inactive', 'Maintenance'],
              selectedValue: currentFilters['Status'],
            ),
            FilterSection(
              title: 'Price Range',
              options: ['All', 'Under ₦200k', '₦200k - ₦400k', '₦400k - ₦600k', 'Above ₦600k'],
              selectedValue: currentFilters['Price Range'],
            ),
          ],
          onApply: (selectedFilters) {
            ref.read(wallProvider.notifier).updateFilters(selectedFilters);
          },
        ),
      ),
    );
  }

  void _uploadWall() {
    context.push('/upload-wall');
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context, String wallName) {
    return DeleteLocationDialog.show(context);
  }
}
