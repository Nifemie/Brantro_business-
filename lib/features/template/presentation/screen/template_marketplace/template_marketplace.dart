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
import 'widgets/template_card.dart';
import 'widgets/template_menu_sheet.dart';
import 'package:brantro_business/features/template/logic/template_provider.dart';

class TemplateMarketplaceScreen extends ConsumerStatefulWidget {
  const TemplateMarketplaceScreen({super.key});

  @override
  ConsumerState<TemplateMarketplaceScreen> createState() => _TemplateMarketplaceScreenState();
}

class _TemplateMarketplaceScreenState extends ConsumerState<TemplateMarketplaceScreen> {
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
    final templateState = ref.watch(templateProvider);
    final hasTemplates = templateState.data?.isNotEmpty ?? false;
    
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
              const DashboardAppBar(title: 'TEMPLATES'),
              
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(templateProvider.notifier).refreshTemplates();
                  },
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      // Search Filter Card as Sliver
                      SliverToBoxAdapter(
                        child: SearchFilterCard(
                          title: 'All Templates',
                          searchController: _searchController,
                          searchHint: 'Search templates...',
                          onFilterTap: _showFilters,
                          onActionButtonTap: () {
                            context.push('/upload-template');
                          },
                          actionButtonLabel: 'Upload Template',
                          actionButtonIcon: Icons.upload,
                          selectedFilters: ref.read(templateProvider.notifier).selectedFilters,
                          onRemoveFilter: (key) => ref.read(templateProvider.notifier).removeFilter(key),
                          onClearFilters: () => ref.read(templateProvider.notifier).clearFilters(),
                          onChanged: (query) => ref.read(templateProvider.notifier).updateSearch(query),
                        ),
                      ),
                      
                      // Content - Loading, Error, Empty or Template List
                      if (templateState.isInitialLoading)
                        SliverPadding(
                          padding: EdgeInsets.all(16.w),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => const SkeletonCampaignCard(),
                              childCount: 3,
                            ),
                          ),
                        )
                      else if (templateState.message != null)
                        SliverFillRemaining(
                          child: EmptyState(
                            icon: Icons.wifi_off_outlined,
                            title: 'Connection Error',
                            message: templateState.message!.contains('SocketException') || templateState.message!.contains('Failed host lookup')
                                ? 'Failed to load templates. Please check your internet connection and try again.'
                                : templateState.message!,
                            showIconBackground: true,
                          ),
                        )
                      else if (!hasTemplates)
                        const SliverFillRemaining(
                          child: EmptyState(
                            icon: Icons.style_outlined,
                            title: 'No Templates Yet',
                            message: 'Start by uploading your first template',
                            showIconBackground: false,
                          ),
                        )
                      else
                        SliverPadding(
                          padding: EdgeInsets.all(16.w),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final template = templateState.data![index];
                                return TemplateCard(
                                  image: template.image,
                                  name: template.name,
                                  rating: template.rating,
                                  favorites: template.favorites,
                                  price: template.price,
                                  discount: template.discount,
                                  ordersCount: template.ordersCount,
                                  onViewDetails: () {
                                    context.push('/template-details', extra: {'template': template});
                                  },
                                  onViewOrders: () {
                                    context.push('/orders', extra: {'templateId': template.id});
                                  },
                                  onMenuTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => TemplateMenuSheet(
                                        templateName: template.name,
                                        onEdit: () {
                                          Navigator.pop(context);
                                          print('Edit ${template.name}');
                                        },
                                        onDelete: () async {
                                          Navigator.pop(context);
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Delete Template'),
                                              content: Text('Are you sure you want to delete "${template.name}"?'),
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
                                          if (confirm == true) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Template deleted successfully'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          }
                                        },
                                        onViewDetails: () {
                                          Navigator.pop(context);
                                          context.push('/template-details', extra: {'template': template});
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                              childCount: templateState.data?.length ?? 0,
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
    final currentFilters = ref.read(templateProvider.notifier).selectedFilters;

    await showModalBottomSheet<Map<String, String?>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => FilterSheet(
          title: 'Template Filters',
          sections: [
            FilterSection(
              title: 'Categories',
              options: [
                'All',
                'Billboard',
                'Wall Location',
                'Digital Screen',
                'Canva Templates',
                'Radio & TV Creatives',
                'Brand Kits',
                'Flyers & Posters',
                'Media Proposals',
                'Pitch Decks',
                'Motion Graphics',
              ],
              selectedValue: currentFilters['Categories'],
            ),
            FilterSection(
              title: 'Cost',
              options: ['All', 'Free', 'Paid', 'Sold'],
              selectedValue: currentFilters['Cost'],
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
            ref.read(templateProvider.notifier).updateFilters(selectedFilters);
          },
        ),
      ),
    );
  }
}
