import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../data/models/campaign_model.dart';
import '../../logic/campaigns_notifier.dart';
import 'package:intl/intl.dart';

class CampaignCard extends ConsumerStatefulWidget {
  final CampaignModel campaign;
  final bool isSeller;
  final VoidCallback onTap;

  const CampaignCard({
    super.key,
    required this.campaign,
    required this.isSeller,
    required this.onTap,
  });

  @override
  ConsumerState<CampaignCard> createState() => _CampaignCardState();
}

class _CampaignCardState extends ConsumerState<CampaignCard> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(widget.campaign.status);
    final placement = widget.campaign.placements.isNotEmpty ? widget.campaign.placements.first : null;
    final creativeCount = placement?.attachments.length ?? 0;

    return GestureDetector(
      onTap: widget.onTap,
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
                  // Campaign icon
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.campaign,
                      color: AppColors.primaryColor,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Reference and date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.campaign.reference,
                          style: AppTexts.h4(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          DateFormat('MMM d, yyyy').format(widget.campaign.createdAt),
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
                      widget.campaign.statusDisplay,
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
                  // Amount
                  Row(
                    children: [
                      Icon(
                        Icons.payments_outlined,
                        size: 18.sp,
                        color: AppColors.grey600,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        widget.campaign.formattedAmount,
                        style: AppTexts.h3(color: AppColors.primaryColor),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 12.h),

                  // Placement details
                  if (placement != null) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 18.sp,
                          color: AppColors.grey600,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'Ad Slot #${placement.adSlotId}',
                            style: AppTexts.bodyMedium(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                  ],

                  // Creatives count
                  Row(
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: 18.sp,
                        color: AppColors.grey600,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '$creativeCount creative${creativeCount != 1 ? 's' : ''}',
                        style: AppTexts.bodyMedium(color: AppColors.grey700),
                      ),
                    ],
                  ),

                  // Payment method
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        widget.campaign.method == 'WALLET' 
                            ? Icons.account_balance_wallet_outlined
                            : Icons.credit_card_outlined,
                        size: 18.sp,
                        color: AppColors.grey600,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        widget.campaign.method,
                        style: AppTexts.bodyMedium(color: AppColors.grey700),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Action buttons
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onTap,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primaryColor),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'View Details',
                        style: AppTexts.buttonSmall(color: AppColors.primaryColor),
                      ),
                    ),
                  ),
                  
                  // Secondary action button based on status
                  if (_getSecondaryAction() != null) ...[
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isProcessing ? null : _handleSecondaryAction,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getSecondaryActionColor(),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: _isProcessing
                            ? SizedBox(
                                height: 20.h,
                                width: 20.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                _getSecondaryAction()!,
                                style: AppTexts.buttonSmall(color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSecondaryAction() async {
    if (!widget.isSeller && widget.campaign.status.toUpperCase() == 'PENDING') {
      // Cancel campaign for buyer
      await _cancelCampaign();
    } else {
      // TODO: Implement other actions (Accept, Start, Complete, etc.)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('This action is not yet implemented'),
          backgroundColor: AppColors.info,
        ),
      );
    }
  }

  Future<void> _cancelCampaign() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel Campaign', style: AppTexts.h4()),
        content: Text(
          'Are you sure you want to cancel this campaign? This action cannot be undone.',
          style: AppTexts.bodyMedium(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('No, Keep It'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isProcessing = true);

    try {
      final result = await ref.read(campaignsProvider.notifier).cancelCampaign(widget.campaign.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Campaign cancelled successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  String? _getSecondaryAction() {
    if (widget.isSeller) {
      switch (widget.campaign.status.toUpperCase()) {
        case 'PENDING':
          return 'Accept';
        case 'ACCEPTED':
          return 'Start';
        case 'IN_PROGRESS':
        case 'ACTIVE':
          return 'Complete';
        default:
          return null;
      }
    } else {
      // Buyer actions
      switch (widget.campaign.status.toUpperCase()) {
        case 'PENDING':
          return 'Cancel Request';
        case 'ACCEPTED':
          return 'Contact';
        case 'IN_PROGRESS':
        case 'ACTIVE':
          return 'Track';
        case 'PAUSED':
          return 'Resume';
        default:
          return null;
      }
    }
  }

  Color _getSecondaryActionColor() {
    if (widget.isSeller) {
      switch (widget.campaign.status.toUpperCase()) {
        case 'PENDING':
          return AppColors.success;
        case 'ACCEPTED':
        case 'IN_PROGRESS':
        case 'ACTIVE':
          return AppColors.primaryColor;
        default:
          return AppColors.primaryColor;
      }
    } else {
      switch (widget.campaign.status.toUpperCase()) {
        case 'PENDING':
          return AppColors.error;
        case 'ACCEPTED':
        case 'IN_PROGRESS':
        case 'ACTIVE':
          return AppColors.primaryColor;
        case 'PAUSED':
          return AppColors.success;
        default:
          return AppColors.primaryColor;
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return AppColors.warning;
      case 'ACCEPTED':
        return AppColors.info;
      case 'IN_PROGRESS':
      case 'ACTIVE':
        return AppColors.success;
      case 'COMPLETED':
        return AppColors.primaryColor;
      case 'CANCELLED':
        return AppColors.error;
      case 'PAUSED':
        return AppColors.grey600;
      default:
        return AppColors.grey600;
    }
  }
}
