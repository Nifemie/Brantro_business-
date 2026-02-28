import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../controllers/re_useable/app_color.dart';
import '../../../../../core/widgets/search_filter_card.dart';
import '../../../../../core/widgets/empty_state.dart';
import '../../../../../core/widgets/filter_sheet.dart';
import '../../../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../../../../dashboard/presentation/widgets/sidebar_menu.dart';
import 'widgets/template_search_bar.dart';

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
    // Navigate to dashboard instead of going back to splash
    if (mounted) {
      context.go('/dashboard');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
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
              
              // Search Filter Card - Now Reusable!
              SearchFilterCard(
                title: 'All Templates',
                searchController: _searchController,
                searchHint: 'Search templates...',
                onFilterTap: () async {
                  final filters = await showModalBottomSheet<Map<String, String?>>(
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
                        ),
                        FilterSection(
                          title: 'Cost',
                          options: ['Free', 'Paid', 'Sold'],
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
              },
              onActionButtonTap: () {
                context.push('/upload-template');
              },
              actionButtonLabel: 'Upload Template',
              actionButtonIcon: Icons.upload,
            ),
            
            // Empty State - Takes remaining space
            Expanded(
              child: const EmptyState(
                icon: Icons.warning_amber_rounded,
                title: 'Templates',
                message: 'No template found',
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
