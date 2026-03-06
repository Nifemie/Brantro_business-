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
import 'widgets/creative_card.dart';
import 'widgets/creative_menu_sheet.dart';

class CreativeMarketplaceScreen extends ConsumerStatefulWidget {
  const CreativeMarketplaceScreen({super.key});

  @override
  ConsumerState<CreativeMarketplaceScreen> createState() => _CreativeMarketplaceScreenState();
}

class _CreativeMarketplaceScreenState extends ConsumerState<CreativeMarketplaceScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // TODO: Replace with actual data from API/Provider
  final bool _hasCreatives = true; // Change to true when you have data
  
  // Mock data - TODO: Replace with actual data from API/Provider
  final List<Map<String, dynamic>> _mockCreatives = [
    {
      'bannerImage': 'assets/promotions/billboard1.jpg',
      'title': 'Liquid Logo Animation Loop',
      'category': 'VIDEO',
      'type': 'STANDARD',
      'duration': '10s',
      'size': '3.6MB',
      'isActive': true,
    },
    {
      'bannerImage': 'assets/promotions/billboard2.jpg',
      'title': 'Modern Brand Identity Kit',
      'category': 'DESIGN',
      'type': 'PREMIUM',
      'duration': '5 Files',
      'size': '12MB',
      'isActive': true,
    },
    {
      'bannerImage': 'assets/promotions/billboard3.jpg',
      'title': 'Social Media Content Pack',
      'category': 'DESIGN',
      'type': 'STANDARD',
      'duration': '20 Files',
      'size': '8.5MB',
      'isActive': false,
    },
  ];
  
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
              
              // Content with collapsible search card
              Expanded(
                child: CustomScrollView(
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
                      ),
                    ),
                    
                    // Content - Empty State or Creative List
                    _hasCreatives
                        ? SliverPadding(
                            padding: EdgeInsets.all(16.w),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final creative = _mockCreatives[index];
                                  return CreativeCard(
                                    bannerImage: creative['bannerImage'] as String,
                                    title: creative['title'] as String,
                                    category: creative['category'] as String,
                                    type: creative['type'] as String,
                                    duration: creative['duration'] as String,
                                    size: creative['size'] as String,
                                    isActive: creative['isActive'] as bool,
                                    onViewOrders: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('View orders for ${creative['title']}')),
                                      );
                                    },
                                    onMenuTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => CreativeMenuSheet(
                                          creativeName: creative['title'] as String,
                                          onEdit: () {
                                            Navigator.pop(context);
                                            print('Edit ${creative['title']}');
                                          },
                                          onDelete: () async {
                                            Navigator.pop(context);
                                            final confirm = await _showDeleteConfirmation(context, creative['title'] as String);
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
                                            print('View details for ${creative['title']}');
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                                childCount: _mockCreatives.length,
                              ),
                            ),
                          )
                        : SliverFillRemaining(
                            child: const EmptyState(
                              icon: Icons.people_outline,
                              title: 'No Creatives Yet',
                              message: 'Start by uploading your first creative',
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
