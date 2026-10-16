import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../features/dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../../features/ad_slot/data/models/ad_campaign_model.dart';
import '../widgets/ad_placement_details/ad_placement_details_shared.dart';

class AdCampaignDetailsScreen extends StatelessWidget {
  final AdCampaignModel campaign;

  const AdCampaignDetailsScreen({
    super.key,
    required this.campaign,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const DashboardAppBar(
              title: 'AD CAMPAIGN DETAILS',
              showBackButton: true,
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWideScreen = constraints.maxWidth > 800;

                  if (isWideScreen) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(24.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 6,
                            child: _buildLeftColumn(isDark),
                          ),
                          SizedBox(width: 24.w),
                          Expanded(
                            flex: 4,
                            child: _buildRightColumn(isDark),
                          ),
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      children: [
                        _buildLeftColumn(isDark),
                        SizedBox(height: 16.h),
                        _buildRightColumn(isDark),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftColumn(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCampaignInfoCard(isDark),
        SizedBox(height: 24.h),
        _buildPaymentDetailsCard(isDark),
      ],
    );
  }

  Widget _buildRightColumn(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAdvertiserInfoCard(isDark),
        SizedBox(height: 24.h),
        _buildMetricsCard(isDark),
      ],
    );
  }

  Widget _buildCampaignInfoCard(bool isDark) {
    final amountFormatted = '₦${campaign.amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
    final createdDate = DateFormat('M/d/yyyy, h:mm a').format(campaign.createdAt);
    
    return AdPlacementDetailsShared.buildBaseCard(
      isDark: isDark,
      title: 'Campaign Info',
      titleIcon: Icons.campaign_outlined,
      titleColor: const Color(0xFFFF7A45),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AdPlacementDetailsShared.buildIconLabelRow(Icons.confirmation_number_outlined, 'Reference', campaign.reference, isDark, iconColor: Colors.blue),
                    SizedBox(height: 24.h),
                    AdPlacementDetailsShared.buildIconLabelRow(Icons.calendar_today, 'Created At', createdDate, isDark, iconColor: Colors.orange),
                    SizedBox(height: 24.h),
                    _buildStatusRow(isDark),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AdPlacementDetailsShared.buildIconLabelRow(Icons.attach_money, 'Budget Amount', amountFormatted, isDark, 
                      iconColor: Colors.green, 
                      valueColor: const Color(0xFFFF7A45), 
                      isBold: true
                    ),
                    SizedBox(height: 24.h),
                    AdPlacementDetailsShared.buildIconLabelRow(Icons.format_list_numbered, 'Placements Count', campaign.placementsCount.toString(), isDark, iconColor: Colors.purple),
                    SizedBox(height: 24.h),
                    AdPlacementDetailsShared.buildIconLabelRow(Icons.description_outlined, 'Remark', campaign.remark, isDark, iconColor: Colors.teal),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(bool isDark) {
    Color badgeColor;
    String badgeText = campaign.status;

    switch (campaign.status.trim().toLowerCase()) {
      case 'requested':
      case 'pending':
        badgeColor = const Color(0xFFFF7A45);
        break;
      case 'accepted':
      case 'approved':
        badgeColor = Colors.green;
        break;
      case 'cancelled':
        badgeColor = Colors.red;
        break;
      default:
        badgeColor = Colors.blue;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[100],
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(Icons.info_outline, size: 16.sp, color: Colors.blueGrey),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status',
              style: TextStyle(
                fontSize: 12.sp,
                color: isDark ? Colors.white54 : Colors.grey[600],
              ),
            ),
            SizedBox(height: 4.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                badgeText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentDetailsCard(bool isDark) {
    return AdPlacementDetailsShared.buildBaseCard(
      isDark: isDark,
      title: 'Payment Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdPlacementDetailsShared.buildInfoRow(Icons.account_balance_wallet_outlined, 'Method: ${campaign.method}', isDark),
          SizedBox(height: 16.h),
          AdPlacementDetailsShared.buildInfoRow(Icons.receipt_long_outlined, 'Payment Ref: ${campaign.paymentRef.isNotEmpty ? campaign.paymentRef : 'N/A'}', isDark),
          SizedBox(height: 16.h),
          AdPlacementDetailsShared.buildInfoRow(Icons.payments_outlined, 'Currency: ${campaign.currency}', isDark),
          SizedBox(height: 16.h),
          AdPlacementDetailsShared.buildInfoRow(Icons.verified_outlined, 'Settled: ${campaign.settled ? "Yes" : "No"}', isDark),
        ],
      ),
    );
  }

  Widget _buildAdvertiserInfoCard(bool isDark) {
    return AdPlacementDetailsShared.buildBaseCard(
      isDark: isDark,
      title: 'Advertiser Info',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: isDark ? Colors.grey[700] : Colors.grey[200],
                child: Icon(Icons.person, color: isDark ? Colors.white54 : Colors.grey[500]),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    campaign.advertiserName,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.grey[900],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 24.h),
          AdPlacementDetailsShared.buildInfoRow(Icons.email_outlined, campaign.advertiserEmail.isNotEmpty ? campaign.advertiserEmail : 'No Email', isDark),
          SizedBox(height: 16.h),
          AdPlacementDetailsShared.buildInfoRow(Icons.phone_outlined, campaign.advertiserPhone.isNotEmpty ? campaign.advertiserPhone : 'No Phone', isDark),
        ],
      ),
    );
  }

  Widget _buildMetricsCard(bool isDark) {
    // If the campaign payload had likes/dislikes/reach, we'd put it here.
    // For now, we will just use a placeholder to show the design layout.
    return AdPlacementDetailsShared.buildBaseCard(
      isDark: isDark,
      title: 'Performance Snapshot',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance metrics will be available once the campaign starts and data is collected.',
            style: TextStyle(
              fontSize: 13.sp,
              color: isDark ? Colors.white54 : Colors.grey[600],
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Icon(Icons.query_stats, color: Colors.blueGrey, size: 24.sp),
              SizedBox(width: 8.w),
              Text(
                'Data pending...',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontStyle: FontStyle.italic,
                  color: isDark ? Colors.grey[500] : Colors.grey[400],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
