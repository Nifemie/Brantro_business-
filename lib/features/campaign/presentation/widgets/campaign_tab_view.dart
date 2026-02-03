import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../../logic/campaigns_notifier.dart';
import 'campaign_card.dart';

class CampaignTabView extends ConsumerStatefulWidget {
  final String status;
  final bool isSeller;

  const CampaignTabView({
    super.key,
    required this.status,
    required this.isSeller,
  });

  @override
  ConsumerState<CampaignTabView> createState() => _CampaignTabViewState();
}

class _CampaignTabViewState extends ConsumerState<CampaignTabView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch campaigns when tab is first loaded
    Future.microtask(() {
      ref.read(campaignsProvider.notifier).refresh(
        status: widget.status == 'all' ? null : widget.status,
      );
    });

    // Setup infinite scroll
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      ref.read(campaignsProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final campaignsState = ref.watch(campaignsProvider);

    if (campaignsState.isLoading && campaignsState.campaigns.isEmpty) {
      return _buildLoadingState();
    }

    if (campaignsState.error != null && campaignsState.campaigns.isEmpty) {
      return _buildErrorState(campaignsState.error!);
    }

    if (campaignsState.campaigns.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(campaignsProvider.notifier).refresh(
          status: widget.status == 'all' ? null : widget.status,
        );
      },
      child: ListView.separated(
        controller: _scrollController,
        padding: EdgeInsets.all(16.w),
        itemCount: campaignsState.campaigns.length + (campaignsState.hasMore ? 1 : 0),
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          if (index >= campaignsState.campaigns.length) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.h),
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              ),
            );
          }

          final campaign = campaignsState.campaigns[index];
          return CampaignCard(
            campaign: campaign,
            isSeller: widget.isSeller,
            onTap: () {
              context.push('/campaign-details/${campaign.id}');
            },
          );
        },
      ),
    );
  }

  Widget _buildErrorState(String error) {
    // Check if it's a network error
    final isNetworkError = error.toLowerCase().contains('network') ||
        error.toLowerCase().contains('internet') ||
        error.toLowerCase().contains('connection') ||
        error.toLowerCase().contains('failed host lookup') ||
        error.toLowerCase().contains('socketexception');

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isNetworkError ? Icons.wifi_off : Icons.error_outline,
              size: 64.sp,
              color: isNetworkError ? AppColors.grey400 : Colors.red,
            ),
            SizedBox(height: 16.h),
            Text(
              isNetworkError ? 'No Internet Connection' : 'Error loading campaigns',
              style: AppTexts.bodyLarge(color: AppColors.grey900),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              isNetworkError
                  ? 'Please check your network connection'
                  : error,
              style: AppTexts.bodySmall(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'Pull down to refresh',
              style: AppTexts.bodySmall(color: AppColors.grey400),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(campaignsProvider.notifier).refresh(
                  status: widget.status == 'all' ? null : widget.status,
                );
              },
              icon: Icon(Icons.refresh, size: 20.sp),
              label: Text('Try Again'),
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
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: 3,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        return SkeletonCampaignCard(
          width: double.infinity,
          height: 420.h,
        );
      },
    );
  }

  Widget _buildEmptyState() {
    String message;
    String subtitle;
    IconData icon;

    switch (widget.status.toLowerCase()) {
      case 'all':
        message = widget.isSeller ? 'No campaigns yet' : 'No campaigns yet';
        subtitle = widget.isSeller
            ? 'Bookings will appear here'
            : 'Browse available ad slots to get started';
        icon = Icons.campaign_outlined;
        break;
      case 'requested':
      case 'requests':
      case 'pending':
        message = 'No pending requests';
        subtitle = widget.isSeller
            ? 'New booking requests will appear here'
            : 'Your booking requests will appear here';
        icon = Icons.pending_outlined;
        break;
      case 'accepted':
        message = 'No accepted campaigns';
        subtitle = widget.isSeller
            ? 'Accepted bookings will appear here'
            : 'Accepted campaigns will appear here';
        icon = Icons.check_circle_outline;
        break;
      case 'in_progress':
        message = 'No campaigns in progress';
        subtitle = widget.isSeller
            ? 'Active campaigns will appear here'
            : 'Active campaigns will appear here';
        icon = Icons.hourglass_empty;
        break;
      case 'completed':
        message = 'No completed campaigns';
        subtitle = widget.isSeller
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
            if (!widget.isSeller && widget.status.toLowerCase() == 'all') ...[
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
