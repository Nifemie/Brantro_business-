import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../features/dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../widgets/search_filter_card.dart';
import '../widgets/ad_campaign_card.dart';
import '../widgets/empty_state.dart';

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
    
    // TODO: Fetch campaigns from provider
    final campaigns = _getMockCampaigns();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            DashboardAppBar(title: _screenTitle),
            
            Expanded(
              child: campaigns.isEmpty
                  ? const EmptyState(
                      icon: Icons.campaign_outlined,
                      title: 'No Campaigns Yet',
                      message: 'Ad campaigns will appear here',
                      showIconBackground: false,
                    )
                  : CustomScrollView(
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
                        
                        // Campaign List
                        SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final campaign = campaigns[index];
                                return AdCampaignCard(
                                  orderRef: campaign['orderRef'] as String,
                                  status: campaign['status'] as String,
                                  adSlots: campaign['adSlots'] as int,
                                  paymentMethod: campaign['paymentMethod'] as String,
                                  orderId: campaign['orderId'] as String,
                                  advertiserName: campaign['advertiserName'] as String,
                                  likes: campaign['likes'] as int,
                                  dislikes: campaign['dislikes'] as int,
                                  date: campaign['date'] as String,
                                  budget: campaign['budget'] as double,
                                  onMenuTap: () {
                                    _showCampaignMenu(context, campaign);
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
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getMockCampaigns() {
    return [
      {
        'orderRef': 'ORD-CMP-20260227171807-9',
        'status': 'pending',
        'adSlots': 0,
        'paymentMethod': 'PAYSTACK',
        'orderId': 'ORD-CMP-20260227171807-9',
        'advertiserName': 'Olowu Tosin Samuel',
        'likes': 0,
        'dislikes': 0,
        'date': 'Feb 27, 2026',
        'budget': 281250.0,
      },
      {
        'orderRef': 'ORD-CMP-20260227110308-4',
        'status': 'cancelled',
        'adSlots': 0,
        'paymentMethod': 'PAYSTACK',
        'orderId': 'ORD-CMP-20260227110308-4',
        'advertiserName': 'Olowu Tosin Samuel',
        'likes': 0,
        'dislikes': 0,
        'date': 'Feb 27, 2026',
        'budget': 281250.0,
      },
    ];
  }

  void _showCampaignMenu(BuildContext context, Map<String, dynamic> campaign) {
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
                  'View Details',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDark ? Colors.white : Colors.grey[900],
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to campaign details
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.share_outlined,
                  color: isDark ? Colors.white70 : Colors.grey[700],
                ),
                title: Text(
                  'Share',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDark ? Colors.white : Colors.grey[900],
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Share campaign
                },
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCampaignAction(BuildContext context, Map<String, dynamic> campaign) {
    final status = campaign['status'] as String;
    
    if (status.toLowerCase() == 'pending') {
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
    }
  }

  void _cancelCampaign(BuildContext context, Map<String, dynamic> campaign) {
    // TODO: Implement cancel campaign
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Campaign ${campaign['orderRef']} cancelled'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _approveCampaign(BuildContext context, Map<String, dynamic> campaign) {
    // TODO: Implement approve campaign
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Campaign ${campaign['orderRef']} approved'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
