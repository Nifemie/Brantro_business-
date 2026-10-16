import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/search_filter_card.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/filter_sheet.dart';
import '../../../../core/widgets/delete_location_dialog.dart';
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
    final hasScreens = screenState.data?.isNotEmpty ?? false;
    
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
                        selectedFilters: ref.read(screenProvider.notifier).selectedFilters,
                        onRemoveFilter: (key) => ref.read(screenProvider.notifier).removeFilter(key),
                        onClearFilters: () => ref.read(screenProvider.notifier).clearFilters(),
                        onChanged: (query) => ref.read(screenProvider.notifier).updateSearch(query),
                      ),
                    ),
                    hasScreens
                        ? SliverPadding(
                            padding: EdgeInsets.all(16.w),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final sortedData = List.of(screenState.data ?? [])..sort((a, b) => b.createdAt.compareTo(a.createdAt));
                                  final screen = sortedData[index];
                                  return ScreenCard(
                                    screen: screen,
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
                                            context.push('/upload-screen', extra: {
                                              'isUpdate': true,
                                              'screen': screen,
                                            });
                                          },
                                          onDelete: () async {
                                            Navigator.pop(context);
                                            final confirm = await _showDeleteConfirmation(context, screen.name);
                                            if (confirm == true) {
                                              try {
                                                await ref.read(screenProvider.notifier).deleteScreen(screen.id);
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Screen deleted successfully'), backgroundColor: Colors.green, duration: Duration(seconds: 3)),
                                                  );
                                                }
                                              } catch (e) {
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                     SnackBar(content: Text('Delete failed: ${e.toString().replaceAll('Exception: ', '')}'), backgroundColor: Colors.red, duration: const Duration(seconds: 3)),
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
                                childCount: screenState.data?.length ?? 0,
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
    final currentFilters = ref.read(screenProvider.notifier).selectedFilters;

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
            FilterSection(
              title: 'Location',
              options: ['All', 'Abuja', 'Lagos', 'Port Harcourt', 'Kano', 'Ibadan'],
              selectedValue: currentFilters['Location'],
            ),
            FilterSection(
              title: 'Size',
              options: ['All', '75 inch', '65 inch', '55 inch', '50 inch'],
              selectedValue: currentFilters['Size'],
            ),
            FilterSection(
              title: 'Status',
              options: ['All', 'Active', 'Inactive', 'Maintenance'],
              selectedValue: currentFilters['Status'],
            ),
            FilterSection(
              title: 'Price Range',
              options: ['All', 'Under ₦300k', '₦300k - ₦500k', '₦500k - ₦700k', 'Above ₦700k'],
              selectedValue: currentFilters['Price Range'],
            ),
          ],
          onApply: (selectedFilters) {
            ref.read(screenProvider.notifier).updateFilters(selectedFilters);
          },
        ),
      ),
    );
  }

  void _uploadScreen() => context.push('/upload-screen');

  Future<bool?> _showDeleteConfirmation(BuildContext context, String screenName) {
    return DeleteLocationDialog.show(context);
  }
}
