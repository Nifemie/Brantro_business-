import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';

class CampaignCard extends StatelessWidget {
  final Map<String, dynamic> campaign;
  final bool isSeller;
  final VoidCallback onTap;

  const CampaignCard({
    super.key,
    required this.campaign,
    required this.isSeller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final status = campaign['status'] ?? 'REQUESTED';
    final statusColor = _getStatusColor(status);
    final statusText = _getStatusText(status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status badge
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  // Profile image
                  CircleAvatar(
                    radius: 24.r,
                    backgroundImage: campaign['profileImage'] != null
                        ? NetworkImage(campaign['profileImage'])
                        : null,
                    backgroundColor: AppColors.grey200,
                    child: campaign['profileImage'] == null
                        ? Icon(
                            Icons.person,
                            color: AppColors.grey600,
                            size: 24.sp,
                          )
                        : null,
                  ),
                  SizedBox(width: 12.w),

                  // Name and role
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          campaign['name'] ?? 'Unknown',
                          style: AppTexts.h4(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          isSeller
                              ? campaign['buyerType'] ?? 'Advertiser'
                              : campaign['sellerRole'] ?? 'Influencer',
                          style: AppTexts.bodySmall(color: AppColors.grey600),
                        ),
                      ],
                    ),
                  ),

                  // Status badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      statusText,
                      style: AppTexts.labelSmall(color: statusColor),
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Divider(height: 1, color: AppColors.grey200),

            // Campaign details
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Campaign title
                  Text(
                    campaign['title'] ?? 'Campaign Title',
                    style: AppTexts.h4(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12.h),

                  // Details row
                  Row(
                    children: [
                      // Date
                      _buildDetailItem(
                        Icons.calendar_today_outlined,
                        campaign['date'] ?? 'Jan 9, 2026',
                      ),
                      SizedBox(width: 16.w),

                      // Amount
                      _buildDetailItem(
                        Icons.payments_outlined,
                        campaign['amount'] ?? '₦250,000',
                      ),
                    ],
                  ),

                  // Platform/Type
                  if (campaign['platform'] != null) ...[
                    SizedBox(height: 8.h),
                    _buildDetailItem(
                      Icons.devices_outlined,
                      campaign['platform'],
                    ),
                  ],
                ],
              ),
            ),

            // Action buttons (for sellers on REQUESTED status)
            if (isSeller && status == 'REQUESTED') ...[
              Divider(height: 1, color: AppColors.grey200),
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        'Reject',
                        AppColors.error,
                        () {
                          // TODO: Implement reject
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildActionButton(
                        'Accept',
                        AppColors.success,
                        () {
                          // TODO: Implement accept
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: AppColors.grey600,
        ),
        SizedBox(width: 4.w),
        Text(
          text,
          style: AppTexts.bodySmall(color: AppColors.grey700),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 10.h),
      ),
      child: Text(
        label,
        style: AppTexts.buttonSmall(color: color),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'REQUESTED':
        return AppColors.warning;
      case 'ACCEPTED':
        return AppColors.info;
      case 'IN_PROGRESS':
        return AppColors.primaryColor;
      case 'PROOF_SUBMITTED':
        return const Color(0xFF9C27B0); // Purple
      case 'COMPLETED':
        return AppColors.success;
      case 'REJECTED':
      case 'CANCELLED':
        return AppColors.error;
      default:
        return AppColors.grey600;
    }
  }

  String _getStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'REQUESTED':
        return 'Pending';
      case 'ACCEPTED':
        return 'Accepted';
      case 'IN_PROGRESS':
        return 'In Progress';
      case 'PROOF_SUBMITTED':
        return 'Proof Submitted';
      case 'COMPLETED':
        return 'Completed';
      case 'REJECTED':
        return 'Rejected';
      case 'CANCELLED':
        return 'Cancelled';
      default:
        return status;
    }
  }
}
