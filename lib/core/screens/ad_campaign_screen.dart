import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../features/dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../widgets/search_filter_card.dart';
import '../widgets/ad_campaign_card.dart';
import '../widgets/empty_state.dart';
import '../../features/ad_slot/logic/ad_campaign_notifier.dart';
import '../../features/ad_slot/data/models/ad_campaign_model.dart';
import 'ad_placement_screen.dart';
import 'ad_campaign_details_screen.dart';

class AdCampaignScreen extends ConsumerStatefulWidget {
  final String parentId;
  final String parentType; // 'billboard', 'wall', 'screen'
  final String parentName;

  const AdCampaignScreen({
    super.key,
    required this.parentId,
    required this.parentType,
    required this.parentName,
  });

  @override
  ConsumerState<AdCampaignScreen> createState() => _AdCampaignScreenState();
}

class _AdCampaignScreenState extends ConsumerState<AdCampaignScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = [
    'All',
    'Pending',
    'Accepted',
    'In Progress',
    'Completed',
    'Rejected',
    'Cancelled'
  ];
  String _selectedFilter = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String get _screenTitle {
    switch (widget.parentType.toLowerCase()) {
      case 'billboard':
        return 'BILLBOARD CAMPAIGNS';
      case 'wall':
        return 'WALL CAMPAIGNS';
      case 'screen':
        return 'SCREEN CAMPAIGNS';
      default:
        return 'AD CAMPAIGNS';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final campaignsState = ref.watch(adCampaignProvider(widget.parentId));
    final allCampaigns = campaignsState.data ?? [];

    // Filter campaigns based on selected tab
    final campaigns = allCampaigns.where((c) {
      if (_selectedFilter == 'All') return true;
      
      final statusLower = c.status.trim().toLowerCase();
      switch (_selectedFilter) {
        case 'Pending':
          return statusLower == 'pending' || statusLower == 'requested';
        case 'Accepted':
          return statusLower == 'accepted' || statusLower == 'approved';
        case 'In Progress':
          return statusLower == 'in_progress' || statusLower == 'in progress' || statusLower == 'inprogress';
        case 'Completed':
          return statusLower == 'completed';
        case 'Rejected':
          return statusLower == 'rejected';
        case 'Cancelled':
          return statusLower == 'cancelled';
        default:
          return true;
      }
    }).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            DashboardAppBar(title: _screenTitle),
            
            Expanded(
              child: campaignsState.isInitialLoading
                  ? const Center(child: CircularProgressIndicator())
                  : allCampaigns.isEmpty
                      ? const EmptyState(
                          icon: Icons.campaign_outlined,
                          title: 'No Campaigns Yet',
                          message: 'Ad campaigns will appear here',
                          showIconBackground: false,
                        )
                      : RefreshIndicator(
                          onRefresh: () => ref.read(adCampaignProvider(widget.parentId).notifier).refresh(),
                          child: CustomScrollView(
                            slivers: [
                              // Search Filter Card
                              SliverToBoxAdapter(
                                child: SearchFilterCard(
                                  title: 'All Campaigns',
                                  searchController: _searchController,
                                  searchHint: 'Search campaigns...',
                                  showFilterButton: true,
                                  showActionButton: false,
                                  onFilterTap: () {
                                    // TODO: Show filter sheet
                                  },
                                ),
                              ),
                              // Filter Tabs
                              SliverToBoxAdapter(
                                child: Container(
                                  height: 50.h,
                                  margin: EdgeInsets.only(bottom: 16.h),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                                    itemCount: _filters.length,
                                    itemBuilder: (context, index) {
                                      final filter = _filters[index];
                                      final isSelected = filter == _selectedFilter;
                                      
                                      return Padding(
                                        padding: EdgeInsets.only(right: 8.w),
                                        child: ChoiceChip(
                                          label: Text(
                                            filter,
                                            style: TextStyle(
                                              color: isSelected 
                                                ? Colors.white 
                                                : (isDark ? Colors.grey[300] : Colors.grey[700]),
                                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                              fontSize: 13.sp,
                                            ),
                                          ),
                                          selected: isSelected,
                                          onSelected: (selected) {
                                            if (selected) {
                                              setState(() {
                                                _selectedFilter = filter;
                                              });
                                            }
                                          },
                                          backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                                          selectedColor: const Color(0xFFFF7A45),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.r),
                                            side: BorderSide(
                                              color: isSelected ? Colors.transparent : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              
                              // Campaign List
                              if (campaigns.isEmpty)
                                SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: const EmptyState(
                                    icon: Icons.campaign_outlined,
                                    title: 'No Campaigns',
                                    message: 'No ad campaigns found for this filter.',
                                    showIconBackground: false,
                                  ),
                                )
                              else
                                SliverPadding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                                  sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        final campaign = campaigns[index];
                                        return AdCampaignCard(
                                          orderRef: campaign.reference,
                                          status: campaign.status,
                                          adSlots: campaign.placementsCount,
                                          paymentMethod: campaign.method,
                                          orderId: campaign.id.toString(),
                                          advertiserName: campaign.advertiserName,
                                          likes: 0,
                                          dislikes: 0,
                                          date: DateFormat('MMM dd, yyyy').format(campaign.createdAt),
                                          budget: campaign.amount,
                                          onMenuTap: () {
                                            _showCampaignMenu(context, campaign);
                                          },
                                          onCancelTap: () {
                                            _cancelCampaign(context, campaign);
                                          },
                                          onActionTap: () {
                                            _handleCampaignAction(context, campaign);
                                          },
                                        );
                                      },
                                      childCount: campaigns.length,
                                    ),
                                  ),
                                ),
                              
                              SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCampaignMenu(BuildContext context, AdCampaignModel campaign) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),
              ListTile(
                leading: Icon(
                  Icons.visibility_outlined,
                  color: isDark ? Colors.white70 : Colors.grey[700],
                ),
                title: Text(
                  'View Campaign',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDark ? Colors.white : Colors.grey[900],
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdCampaignDetailsScreen(campaign: campaign),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.movie_creation_outlined,
                  color: isDark ? Colors.white70 : Colors.grey[700],
                ),
                title: Text(
                  'View Placements',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDark ? Colors.white : Colors.grey[900],
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to the new Ad Placement Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdPlacementScreen(campaignId: campaign.id.toString()),
                    ),
                  );
                },
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCampaignAction(BuildContext context, AdCampaignModel campaign) {
    final status = campaign.status.toLowerCase();
    
    if (status == 'pending' || status == 'requested') {
      // Show approve/cancel dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Campaign Action'),
          content: const Text('What would you like to do with this campaign?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _cancelCampaign(context, campaign);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Cancel Campaign'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _approveCampaign(context, campaign);
              },
              child: const Text('Approve Campaign'),
            ),
          ],
        ),
      );
    } else {
      // For any other status, 'View Details' button was clicked
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdCampaignDetailsScreen(campaign: campaign),
        ),
      );
    }
  }

  void _cancelCampaign(BuildContext context, AdCampaignModel campaign) async {
    try {
      await ref.read(adCampaignProvider(widget.parentId).notifier).cancelCampaign(campaign.id.toString());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Campaign ${campaign.reference} cancelled'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to cancel campaign: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _approveCampaign(BuildContext context, AdCampaignModel campaign) {
    // TODO: Implement approve campaign
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Campaign ${campaign.reference} approved'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
