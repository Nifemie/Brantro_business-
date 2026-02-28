import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/widgets/search_filter_card.dart';
import '../../../../../core/widgets/empty_state.dart';
import '../../../../../core/widgets/filter_sheet.dart';
import '../../../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../../../../dashboard/presentation/widgets/sidebar_menu.dart';
import 'widgets/creative_list.dart';

class CreativeMarketplaceScreen extends ConsumerStatefulWidget {
  const CreativeMarketplaceScreen({super.key});

  @override
  ConsumerState<CreativeMarketplaceScreen> createState() => _CreativeMarketplaceScreenState();
}

class _CreativeMarketplaceScreenState extends ConsumerState<CreativeMarketplaceScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // TODO: Replace with actual data from API/Provider
  final bool _hasCreatives = true; // Change to true when you have data
  
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
              
              // Search Filter Card - Reusable Widget
              SearchFilterCard(
                title: 'All Creatives',
                searchController: _searchController,
                searchHint: 'Search creatives...',
                onFilterTap: _showFilters,
                onActionButtonTap: _uploadCreative,
                actionButtonLabel: 'Upload Creative',
                actionButtonIcon: Icons.upload,
              ),
              
              // Content - Empty State or Creative List
              Expanded(
                child: _hasCreatives 
                    ? const CreativeList() 
                    : const EmptyState(
                        icon: Icons.people_outline,
                        title: 'No Creatives Yet',
                        message: 'Start by uploading your first creative',
                        showIconBackground: false,
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
            ),
            FilterSection(
              title: 'Experience Level',
              options: ['Beginner', 'Intermediate', 'Expert'],
            ),
            FilterSection(
              title: 'Availability',
              options: ['Available', 'Busy', 'Not Available'],
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
  }

  void _uploadCreative() {
    context.push('/upload-creative');
  }
}
