import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../controllers/re_useable/app_texts.dart';
import '../../../core/service/session_service.dart';
import '../../../features/auth/data/models/user_model.dart';
import 'widgets/campaign_status_tabs.dart';
import 'widgets/campaign_card.dart';
import 'widgets/campaign_tab_view.dart';

class CampaignsScreen extends StatefulWidget {
  const CampaignsScreen({super.key});

  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSeller = false;
  bool _isLoading = true;
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    try {
      final userJson = await SessionService.getUser();
      final isLoggedIn = await SessionService.isLoggedIn();
      
      // Check if user is a guest (not logged in)
      if (!isLoggedIn || userJson == null) {
        // Guest user - show login prompt
        _tabController = TabController(
          length: 1, // Only one tab for guests
          vsync: this,
        );
        
        setState(() {
          _isLoading = false;
          _currentUser = null;
          _isSeller = false;
        });
        return;
      }
      
      _currentUser = UserModel.fromJson(userJson);
      
      final userRole = _currentUser!.role.toUpperCase();
      
      // Determine tab count based on role
      // SUPER_ADMIN gets all tabs (buyer + seller combined)
      // ADVERTISER gets buyer tabs (5 tabs)
      // All other roles get seller tabs (4 tabs)
      int tabCount;
      if (userRole == 'SUPER_ADMIN') {
        tabCount = 9; // All buyer tabs + all seller tabs
        _isSeller = false; // Treat as buyer for primary view
      } else if (userRole == 'ADVERTISER') {
        tabCount = 5; // Buyer tabs
        _isSeller = false;
      } else {
        tabCount = 4; // Seller tabs
        _isSeller = true;
      }
      
      // Initialize tab controller after determining role
      _tabController = TabController(
        length: tabCount,
        vsync: this,
      );
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      // Default to buyer view if error
      _tabController = TabController(
        length: 5,
        vsync: this,
      );
      
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.backgroundSecondary,
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          ),
        ),
      );
    }

    // Guest user view
    if (_currentUser == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundSecondary,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _buildGuestView(),
              ),
            ],
          ),
        ),
      );
    }

    // Logged in user view
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Tab Bar
            CampaignStatusTabs(
              tabController: _tabController,
              isSeller: _isSeller,
              isSuperAdmin: _currentUser?.role.toUpperCase() == 'SUPER_ADMIN',
            ),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _currentUser?.role.toUpperCase() == 'SUPER_ADMIN'
                    ? _buildSuperAdminTabs()
                    : _isSeller
                        ? _buildSellerTabs()
                        : _buildBuyerTabs(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      color: Colors.white,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _currentUser == null
                    ? 'Campaigns'
                    : _isSeller
                        ? 'Campaign Inbox'
                        : 'My Campaigns',
                style: AppTexts.h2(),
              ),
              if (_currentUser != null) ...[
                SizedBox(height: 4.h),
                Text(
                  _currentUser!.name,
                  style: AppTexts.bodySmall(color: AppColors.grey600),
                ),
              ],
            ],
          ),
          const Spacer(),
          // Filter icon (only show for logged in users)
          if (_currentUser != null)
            IconButton(
              onPressed: () {
                // TODO: Implement filter
              },
              icon: Icon(
                Icons.filter_list,
                color: AppColors.iconLight,
                size: 24.sp,
              ),
            ),
        ],
      ),
    );
  }

  // Buyer tabs: All, Requested, Accepted, In Progress, Completed
  List<Widget> _buildBuyerTabs() {
    return [
      CampaignTabView(
        status: 'all',
        isSeller: false,
        campaigns: _getMockCampaigns('all'),
        onRefresh: _refreshCampaigns,
      ),
      CampaignTabView(
        status: 'requested',
        isSeller: false,
        campaigns: _getMockCampaigns('requested'),
        onRefresh: _refreshCampaigns,
      ),
      CampaignTabView(
        status: 'accepted',
        isSeller: false,
        campaigns: _getMockCampaigns('accepted'),
        onRefresh: _refreshCampaigns,
      ),
      CampaignTabView(
        status: 'in_progress',
        isSeller: false,
        campaigns: _getMockCampaigns('in_progress'),
        onRefresh: _refreshCampaigns,
      ),
      CampaignTabView(
        status: 'completed',
        isSeller: false,
        campaigns: _getMockCampaigns('completed'),
        onRefresh: _refreshCampaigns,
      ),
    ];
  }

  // Seller tabs: Requests, Accepted, In Progress, Completed
  List<Widget> _buildSellerTabs() {
    return [
      CampaignTabView(
        status: 'requests',
        isSeller: true,
        campaigns: _getMockCampaigns('requests'),
        onRefresh: _refreshCampaigns,
      ),
      CampaignTabView(
        status: 'accepted',
        isSeller: true,
        campaigns: _getMockCampaigns('accepted'),
        onRefresh: _refreshCampaigns,
      ),
      CampaignTabView(
        status: 'in_progress',
        isSeller: true,
        campaigns: _getMockCampaigns('in_progress'),
        onRefresh: _refreshCampaigns,
      ),
      CampaignTabView(
        status: 'completed',
        isSeller: true,
        campaigns: _getMockCampaigns('completed'),
        onRefresh: _refreshCampaigns,
      ),
    ];
  }

  // Super Admin tabs: All buyer tabs + all seller tabs
  List<Widget> _buildSuperAdminTabs() {
    return [
      // Buyer tabs
      ..._buildBuyerTabs(),
      // Seller tabs
      ..._buildSellerTabs(),
    ];
  }

  void _refreshCampaigns() {
    // TODO: Implement refresh logic
    setState(() {});
  }

  Widget _buildGuestView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 80.sp,
              color: AppColors.grey400,
            ),
            SizedBox(height: 24.h),
            Text(
              'Sign in to view campaigns',
              style: AppTexts.h3(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              'Create an account or sign in to book ad slots, track campaigns, and manage your advertising.',
              style: AppTexts.bodyMedium(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            
            // Sign In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.go('/signin');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Sign In',
                  style: AppTexts.buttonMedium(),
                ),
              ),
            ),
            
            SizedBox(height: 12.h),
            
            // Sign Up Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  context.go('/signup');
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primaryColor, width: 1.5),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Create Account',
                  style: AppTexts.buttonMedium(color: AppColors.primaryColor),
                ),
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Browse as guest
            TextButton(
              onPressed: () async {
                // Clear session data before browsing as guest
                await SessionService.clearSession();
                if (mounted) {
                  context.go('/explore');
                }
              },
              child: Text(
                'Continue browsing as guest',
                style: AppTexts.bodySmall(color: AppColors.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Mock data - TODO: Replace with actual API data
  List<Map<String, dynamic>> _getMockCampaigns(String status) {
    // Return empty for now - will be populated with real data
    return [];
  }
}
