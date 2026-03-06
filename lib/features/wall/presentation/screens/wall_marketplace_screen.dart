import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/search_filter_card.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/filter_sheet.dart';
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
    final hasWalls = wallState.walls.isNotEmpty;
    
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
              
              // Content with collapsible search card
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    // Search Filter Card as Sliver
                    SliverToBoxAdapter(
                      child: SearchFilterCard(
                        title: 'All Walls',
                        searchController: _searchController,
                        searchHint: 'Search walls...',
                        onFilterTap: _showFilters,
                        onActionButtonTap: _uploadWall,
                        actionButtonLabel: 'Upload Wall',
                        actionButtonIcon: Icons.upload,
                      ),
                    ),
                    
                    // Content - Empty State or Wall List
                    hasWalls
                        ? SliverPadding(
                            padding: EdgeInsets.all(16.w),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final wall = wallState.walls[index];
                                  return WallCard(
                                    image: wall.images.isNotEmpty ? wall.images.first : '',
                                    name: wall.name,
                                    location: wall.address,
                                    size: wall.size,
                                    price: '₦${wall.price.toStringAsFixed(0)}/month',
                                    isActive: wall.isActive,
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
                                            print('Edit ${wall.name}');
                                          },
                                          onDelete: () async {
                                            Navigator.pop(context);
                                            final confirm = await _showDeleteConfirmation(context, wall.name);
                                            if (confirm == true) {
                                              try {
                                                await ref.read(wallProvider.notifier).deleteWall(wall.id);
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      content: Text('Wall deleted successfully'),
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
                                            context.push('/wall-details', extra: {'wall': wall});
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                                childCount: wallState.walls.length,
                              ),
                            ),
                          )
                        : SliverFillRemaining(
                            child: const EmptyState(
                              icon: Icons.wallpaper_outlined,
                              title: 'No Walls Yet',
                              message: 'Start by uploading your first wall',
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
          title: 'Wall Filters',
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
                '30ft x 15ft',
                '25ft x 12ft',
                '20ft x 10ft',
                '15ft x 8ft',
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
                'Under ₦200k',
                '₦200k - ₦400k',
                '₦400k - ₦600k',
                'Above ₦600k',
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

  void _uploadWall() {
    context.push('/upload-wall');
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context, String wallName) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Wall'),
        content: Text('Are you sure you want to delete "$wallName"?'),
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
