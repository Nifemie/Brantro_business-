import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import 'campaign_card.dart';

class CampaignTabView extends StatelessWidget {
  final String status;
  final bool isSeller;
  final List<Map<String, dynamic>> campaigns;
  final VoidCallback onRefresh;

  const CampaignTabView({
    super.key,
    required this.status,
    required this.isSeller,
    required this.campaigns,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (campaigns.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: campaigns.length,
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final campaign = campaigns[index];
          return CampaignCard(
            campaign: campaign,
            isSeller: isSeller,
            onTap: () {
              // TODO: Navigate to campaign details
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    String message;
    String subtitle;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'all':
        message = isSeller ? 'No campaigns yet' : 'No campaigns yet';
        subtitle = isSeller
            ? 'Bookings will appear here'
            : 'Browse available ad slots to get started';
        icon = Icons.campaign_outlined;
        break;
      case 'requested':
      case 'requests':
        message = 'No pending requests';
        subtitle = isSeller
            ? 'New booking requests will appear here'
            : 'Your booking requests will appear here';
        icon = Icons.pending_outlined;
        break;
      case 'accepted':
        message = 'No accepted campaigns';
        subtitle = isSeller
            ? 'Accepted bookings will appear here'
            : 'Accepted campaigns will appear here';
        icon = Icons.check_circle_outline;
        break;
      case 'in_progress':
        message = 'No campaigns in progress';
        subtitle = isSeller
            ? 'Active campaigns will appear here'
            : 'Active campaigns will appear here';
        icon = Icons.hourglass_empty;
        break;
      case 'completed':
        message = 'No completed campaigns';
        subtitle = isSeller
            ? 'Completed campaigns will appear here'
            : 'Completed campaigns will appear here';
        icon = Icons.done_all;
        break;
      default:
        message = 'No campaigns found';
        subtitle = 'Check back later';
        icon = Icons.inbox_outlined;
    }

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64.sp,
              color: AppColors.grey400,
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              style: AppTexts.bodyLarge(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              subtitle,
              style: AppTexts.bodySmall(color: AppColors.grey500),
              textAlign: TextAlign.center,
            ),
            
            // Show "Browse Slots" button for buyers on "All" tab
            if (!isSeller && status.toLowerCase() == 'all') ...[
              SizedBox(height: 24.h),
              Builder(
                builder: (context) => ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to explore/marketplace
                    context.go('/explore');
                  },
                  icon: Icon(Icons.explore, size: 20.sp),
                  label: Text('Browse Available Slots'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
