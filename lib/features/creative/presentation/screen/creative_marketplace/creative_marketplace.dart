import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/widgets/search_filter_card.dart';
import '../../../../../core/widgets/empty_state.dart';
import '../../../../../core/widgets/filter_sheet.dart';
import '../../../../../core/widgets/skeleton_loading.dart';
import '../../../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../../../../dashboard/presentation/widgets/sidebar_menu.dart';
import 'widgets/creative_card.dart';
import 'widgets/creative_menu_sheet.dart';
import 'package:brantro_business/features/creative/logic/creative_provider.dart';

class CreativeMarketplaceScreen extends ConsumerStatefulWidget {
  const CreativeMarketplaceScreen({super.key});

  @override
  ConsumerState<CreativeMarketplaceScreen> createState() => _CreativeMarketplaceScreenState();
}

class _CreativeMarketplaceScreenState extends ConsumerState<CreativeMarketplaceScreen> {
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
    final creativeState = ref.watch(creativeProvider);
    final hasCreatives = creativeState.data?.isNotEmpty ?? false;
    
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
              const DashboardAppBar(title: 'CREATIVES'),
              
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(creativeProvider.notifier).refreshCreatives();
                  },
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      // Search Filter Card as Sliver
                      SliverToBoxAdapter(
                        child: SearchFilterCard(
                          title: 'All Creatives',
                          searchController: _searchController,
                          searchHint: 'Search creatives...',
                          onFilterTap: _showFilters,
                          onActionButtonTap: _uploadCreative,
                          actionButtonLabel: 'Upload Creative',
                          actionButtonIcon: Icons.upload,
                          selectedFilters: ref.read(creativeProvider.notifier).selectedFilters,
                          onRemoveFilter: (key) => ref.read(creativeProvider.notifier).removeFilter(key),
                          onClearFilters: () => ref.read(creativeProvider.notifier).clearFilters(),
                          onChanged: (query) => ref.read(creativeProvider.notifier).updateSearch(query),
                        ),
                      ),
                      
                      // Content - Loading, Error, Empty or Creative List
                      if (creativeState.isInitialLoading)
                        SliverPadding(
                          padding: EdgeInsets.all(16.w),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => const SkeletonCampaignCard(),
                              childCount: 3,
                            ),
                          ),
                        )
                      else if (creativeState.message != null)
                        SliverFillRemaining(
                          child: EmptyState(
                            icon: Icons.wifi_off_outlined,
                            title: 'Connection Error',
                            message: creativeState.message!.contains('SocketException') || creativeState.message!.contains('Failed host lookup')
                                ? 'Failed to load creatives. Please check your internet connection and try again.'
                                : creativeState.message!,
                            showIconBackground: true,
                          ),
                        )
                      else if (!hasCreatives)
                        const SliverFillRemaining(
                          child: EmptyState(
                            icon: Icons.image_not_supported_outlined,
                            title: 'No Creatives Yet',
                            message: 'Start by uploading your first creative asset',
                            showIconBackground: false,
                          ),
                        )
                      else
                        SliverPadding(
                          padding: EdgeInsets.all(16.w),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final creative = creativeState.data![index];
                                return CreativeCard(
                                  bannerImage: creative.image,
                                  title: creative.name,
                                  rating: creative.rating,
                                  favorites: creative.favorites,
                                  price: creative.price,
                                  discount: creative.discount,
                                  ordersCount: creative.ordersCount,
                                  onViewDetails: () {
                                    context.push('/creative-details', extra: {'creative': creative});
                                  },
                                  onViewOrders: () {
                                    context.push('/orders', extra: {'creativeId': creative.id});
                                  },
                                  onMenuTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => CreativeMenuSheet(
                                        creativeName: creative.name,
                                        onEdit: () {
                                          Navigator.pop(context);
                                          print('Edit ${creative.name}');
                                        },
                                        onDelete: () async {
                                          Navigator.pop(context);
                                          final confirm = await _showDeleteConfirmation(context, creative.name);
                                          if (confirm == true) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Creative deleted successfully'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          }
                                        },
                                        onViewDetails: () {
                                          Navigator.pop(context);
                                          context.push('/creative-details', extra: {'creative': creative});
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                              childCount: creativeState.data?.length ?? 0,
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
    final currentFilters = ref.read(creativeProvider.notifier).selectedFilters;

    await showModalBottomSheet<Map<String, String?>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => FilterSheet(
          title: 'Creative Filters',
          sections: [
            FilterSection(
              title: 'Specialization',
              options: [
                'All',
                'Graphic Designer',
                'Video Editor',
                'Copywriter',
                'Photographer',
                'Animator',
                'Voice Over Artist',
                'Content Creator',
              ],
              selectedValue: currentFilters['Specialization'],
            ),
            FilterSection(
              title: 'Experience Level',
              options: ['All', 'Beginner', 'Intermediate', 'Expert'],
              selectedValue: currentFilters['Experience Level'],
            ),
            FilterSection(
              title: 'Availability',
              options: ['All', 'Available', 'Busy', 'Not Available'],
              selectedValue: currentFilters['Availability'],
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
            ref.read(creativeProvider.notifier).updateFilters(selectedFilters);
          },
        ),
      ),
    );
  }

  void _uploadCreative() {
    context.push('/upload-creative');
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context, String creativeName) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Creative'),
        content: Text('Are you sure you want to delete "$creativeName"?'),
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
