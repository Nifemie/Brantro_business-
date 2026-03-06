import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/search_filter_card.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/filter_sheet.dart';
import '../../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../../../dashboard/presentation/widgets/sidebar_menu.dart';
import '../widgets/screen_card.dart';
import '../widgets/screen_menu_sheet.dart';
import '../../logic/screen_provider.dart';

class ScreenMarketplaceScreen extends ConsumerStatefulWidget {
  const ScreenMarketplaceScreen({super.key});

  @override
  ConsumerState<ScreenMarketplaceScreen> createState() => _ScreenMarketplaceScreenState();
}

class _ScreenMarketplaceScreenState extends ConsumerState<ScreenMarketplaceScreen> {
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
    final screenState = ref.watch(screenProvider);
    final hasScreens = screenState.screens.isNotEmpty;
    
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
              const DashboardAppBar(title: 'DIGITAL SCREENS'),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: SearchFilterCard(
                        title: 'All Screens',
                        searchController: _searchController,
                        searchHint: 'Search screens...',
                        onFilterTap: _showFilters,
                        onActionButtonTap: _uploadScreen,
                        actionButtonLabel: 'Upload Screen',
                        actionButtonIcon: Icons.upload,
                      ),
                    ),
                    hasScreens
                        ? SliverPadding(
                            padding: EdgeInsets.all(16.w),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final screen = screenState.screens[index];
                                  return ScreenCard(
                                    image: screen.images.isNotEmpty ? screen.images.first : '',
                                    name: screen.name,
                                    location: screen.address,
                                    size: screen.size,
                                    price: '₦${screen.price.toStringAsFixed(0)}/month',
                                    isActive: screen.isActive,
                                    onViewSlots: () {
                                      context.push('/ad-slots', extra: {
                                        'parentId': screen.id,
                                        'parentType': 'screen',
                                        'parentName': screen.name,
                                      });
                                    },
                                    onMenuTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => ScreenMenuSheet(
                                          screenName: screen.name,
                                          onEdit: () {
                                            Navigator.pop(context);
                                            print('Edit ${screen.name}');
                                          },
                                          onDelete: () async {
                                            Navigator.pop(context);
                                            final confirm = await _showDeleteConfirmation(context, screen.name);
                                            if (confirm == true) {
                                              try {
                                                await ref.read(screenProvider.notifier).deleteScreen(screen.id);
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Screen deleted successfully'), backgroundColor: Colors.green),
                                                  );
                                                }
                                              } catch (e) {
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Delete failed: ${e.toString()}'), backgroundColor: Colors.red),
                                                  );
                                                }
                                              }
                                            }
                                          },
                                          onViewDetails: () {
                                            Navigator.pop(context);
                                            context.push('/screen-details', extra: {'screen': screen});
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                                childCount: screenState.screens.length,
                              ),
                            ),
                          )
                        : SliverFillRemaining(
                            child: const EmptyState(
                              icon: Icons.tv_outlined,
                              title: 'No Screens Yet',
                              message: 'Start by uploading your first digital screen',
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
    await showModalBottomSheet<Map<String, String?>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => FilterSheet(
          title: 'Screen Filters',
          sections: [
            FilterSection(title: 'Location', options: ['All', 'Abuja', 'Lagos', 'Port Harcourt', 'Kano', 'Ibadan']),
            FilterSection(title: 'Size', options: ['All', '75 inch', '65 inch', '55 inch', '50 inch']),
            FilterSection(title: 'Status', options: ['All', 'Active', 'Inactive', 'Maintenance']),
            FilterSection(title: 'Price Range', options: ['All', 'Under ₦300k', '₦300k - ₦500k', '₦500k - ₦700k', 'Above ₦700k']),
          ],
          onApply: (selectedFilters) => print('Selected filters: $selectedFilters'),
        ),
      ),
    );
  }

  void _uploadScreen() => context.push('/upload-screen');

  Future<bool?> _showDeleteConfirmation(BuildContext context, String screenName) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Screen'),
        content: Text('Are you sure you want to delete "$screenName"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text('Delete')),
        ],
      ),
    );
  }
}
