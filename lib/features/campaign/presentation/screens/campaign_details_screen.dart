import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../data/models/campaign_model.dart';
import '../../data/campaign_repository.dart';
import '../../logic/campaigns_notifier.dart';

final campaignDetailsProvider = FutureProvider.family<CampaignModel, int>((ref, campaignId) async {
  final repository = ref.watch(campaignRepositoryProvider);
  return repository.getCampaignDetails(campaignId);
});

class CampaignDetailsScreen extends ConsumerStatefulWidget {
  final int campaignId;

  const CampaignDetailsScreen({
    super.key,
    required this.campaignId,
  });

  @override
  ConsumerState<CampaignDetailsScreen> createState() => _CampaignDetailsScreenState();
}

class _CampaignDetailsScreenState extends ConsumerState<CampaignDetailsScreen> {
  bool _isCancelling = false;

  Future<void> _cancelCampaign(CampaignModel campaign) async {
    // Only allow cancellation for pending campaigns
    if (campaign.status.toUpperCase() != 'PENDING') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Only pending campaigns can be cancelled'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

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

    setState(() => _isCancelling = true);

    try {
      final result = await ref.read(campaignsProvider.notifier).cancelCampaign(widget.campaignId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Campaign cancelled successfully'),
            backgroundColor: AppColors.success,
          ),
        );

        // Force refresh the campaign details by invalidating the provider
        ref.invalidate(campaignDetailsProvider(widget.campaignId));
        
        // Small delay to ensure the API has updated before refetching
        await Future.delayed(Duration(milliseconds: 500));
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
        setState(() => _isCancelling = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final campaignAsync = ref.watch(campaignDetailsProvider(widget.campaignId));

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text('Campaign Details', style: AppTexts.h3(color: Colors.white)),
        actions: [
          if (campaignAsync.hasValue && 
              campaignAsync.value!.status.toUpperCase() == 'PENDING')
            IconButton(
              icon: Icon(Icons.cancel_outlined, color: Colors.white),
              onPressed: _isCancelling 
                  ? null 
                  : () => _cancelCampaign(campaignAsync.value!),
              tooltip: 'Cancel Campaign',
            ),
        ],
      ),
      body: campaignAsync.when(
        data: (campaign) => _buildContent(context, campaign),
        loading: () => Center(child: CircularProgressIndicator(color: AppColors.primaryColor)),
        error: (error, stack) => _buildError(context, error.toString()),
      ),
    );
  }

  Widget _buildContent(BuildContext context, CampaignModel campaign) {
    final placement = campaign.placements.isNotEmpty ? campaign.placements.first : null;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            margin: EdgeInsets.all(16.w),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        campaign.reference,
                        style: AppTexts.h3(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: _getStatusColor(campaign.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        campaign.statusDisplay,
                        style: AppTexts.labelSmall(color: _getStatusColor(campaign.status)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14.sp, color: AppColors.grey600),
                    SizedBox(width: 6.w),
                    Text(
                      DateFormat('MMM d, yyyy • h:mm a').format(campaign.createdAt),
                      style: AppTexts.bodySmall(color: AppColors.grey600),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount',
                        style: AppTexts.bodyMedium(color: AppColors.grey700),
                      ),
                      Text(
                        campaign.formattedAmount,
                        style: AppTexts.h2(color: AppColors.primaryColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (placement != null) ...[
            // Ad Slot Info
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Icons.campaign,
                              color: AppColors.primaryColor,
                              size: 24.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text('Ad Slot', style: AppTexts.h4()),
                        ],
                      ),
                      TextButton.icon(
                        onPressed: () {
                          // Navigate to ad slot details with hideBooking flag
                          context.push(
                            '/ad-slot-details/${placement.adSlotId}',
                            extra: {
                              'hideBooking': true,
                            },
                          );
                        },
                        icon: Icon(Icons.arrow_forward, size: 16.sp),
                        label: Text('View Details'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.grey50,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.grey200),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.tag, color: AppColors.primaryColor, size: 20.sp),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Slot ID',
                                    style: AppTexts.bodySmall(color: AppColors.grey600),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    '${placement.adSlotId}',
                                    style: AppTexts.bodyMedium(color: AppColors.textPrimary)
                                        .copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Icon(Icons.payments, color: AppColors.success, size: 20.sp),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Amount',
                                    style: AppTexts.bodySmall(color: AppColors.grey600),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    '₦${placement.amount}',
                                    style: AppTexts.bodyMedium(color: AppColors.success)
                                        .copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (placement.description.isNotEmpty) ...[
                          SizedBox(height: 16.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.info_outline, color: AppColors.info, size: 20.sp),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Description',
                                      style: AppTexts.bodySmall(color: AppColors.grey600),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      placement.description,
                                      style: AppTexts.bodySmall(color: AppColors.grey700),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Creatives
            if (placement.attachments.isNotEmpty)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.photo_library,
                            color: Colors.purple,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text('Creatives', style: AppTexts.h4()),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            '${placement.attachments.length}',
                            style: AppTexts.labelSmall(color: AppColors.primaryColor)
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    ...placement.attachments.map((attachment) => GestureDetector(
                      onTap: () {
                        _showCreativeDialog(context, attachment);
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: AppColors.grey50,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: AppColors.grey200),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: attachment.isImage 
                                    ? AppColors.primaryColor.withOpacity(0.1)
                                    : Colors.purple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Icon(
                                attachment.isImage ? Icons.image : Icons.videocam,
                                color: attachment.isImage ? AppColors.primaryColor : Colors.purple,
                                size: 24.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    attachment.name,
                                    style: AppTexts.bodyMedium()
                                        .copyWith(fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Icon(Icons.storage, size: 12.sp, color: AppColors.grey600),
                                      SizedBox(width: 4.w),
                                      Text(
                                        attachment.formattedSize,
                                        style: AppTexts.labelSmall(color: AppColors.grey600),
                                      ),
                                      SizedBox(width: 12.w),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(attachment.status).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        child: Text(
                                          attachment.status,
                                          style: AppTexts.labelSmall(
                                            color: _getStatusColor(attachment.status),
                                          ).copyWith(fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right, color: AppColors.grey400, size: 24.sp),
                          ],
                        ),
                      ),
                    )),
                  ],
                ),
              ),
          ],

          SizedBox(height: 80.h),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: isTotal ? AppTexts.h4() : AppTexts.bodyMedium(color: AppColors.grey700)),
        Text(value, style: isTotal ? AppTexts.h3(color: AppColors.primaryColor) : AppTexts.bodyMedium()),
      ],
    );
  }

  Widget _buildError(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
            SizedBox(height: 16.h),
            Text('Error loading campaign', style: AppTexts.h4()),
            SizedBox(height: 8.h),
            Text(error, style: AppTexts.bodySmall(color: AppColors.grey600), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  void _showCreativeDialog(BuildContext context, AttachmentModel attachment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              attachment.isImage ? Icons.image : Icons.videocam,
              color: attachment.isImage ? AppColors.primaryColor : Colors.purple,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                attachment.isImage ? 'Image Creative' : 'Video Creative',
                style: AppTexts.h4(),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('File Name', attachment.name),
            SizedBox(height: 12.h),
            _buildInfoRow('File Size', attachment.formattedSize),
            SizedBox(height: 12.h),
            _buildInfoRow('Type', attachment.mimeType),
            SizedBox(height: 12.h),
            _buildInfoRow('Status', attachment.status),
            SizedBox(height: 12.h),
            _buildInfoRow('File ID', attachment.id),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.info, size: 16.sp),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'File preview will be available once uploaded to the server',
                      style: AppTexts.labelSmall(color: AppColors.info),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80.w,
          child: Text(
            label,
            style: AppTexts.bodySmall(color: AppColors.grey600),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTexts.bodyMedium(),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING': return AppColors.warning;
      case 'ACCEPTED': return AppColors.info;
      case 'IN_PROGRESS':
      case 'ACTIVE': return AppColors.success;
      case 'COMPLETED': return AppColors.primaryColor;
      case 'CANCELLED': return AppColors.error;
      default: return AppColors.grey600;
    }
  }
}
