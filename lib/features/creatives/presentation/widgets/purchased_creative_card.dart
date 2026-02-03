import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../data/models/creative_model.dart';

class PurchasedCreativeCard extends StatelessWidget {
  final CreativeModel creative;
  final String orderStatus;
  final DateTime purchaseDate;
  final VoidCallback onDownload;
  final VoidCallback? onViewDetails;

  const PurchasedCreativeCard({
    super.key,
    required this.creative,
    required this.orderStatus,
    required this.purchaseDate,
    required this.onDownload,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageSection(),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  creative.title,
                  style: AppTexts.h4(color: AppColors.textPrimary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                _buildPurchaseInfo(),
                SizedBox(height: 12.h),
                _buildCreativeInfo(),
                SizedBox(height: 16.h),
                _buildActionButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        Container(
          height: 180.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.grey200,
          ),
          child: (creative.thumbnail != null && creative.thumbnail!.startsWith('http'))
              ? Image.network(
                  creative.thumbnail!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholder();
                  },
                )
              : _buildPlaceholder(),
        ),
        Positioned(
          top: 12.h,
          left: 12.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.textPrimary,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              creative.type,
              style: AppTexts.labelSmall(color: Colors.white),
            ),
          ),
        ),
        Positioned(
          top: 12.h,
          right: 12.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: _getStatusColor(),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              orderStatus,
              style: AppTexts.labelSmall(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.grey200,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 48.sp,
          color: AppColors.grey400,
        ),
      ),
    );
  }

  Widget _buildPurchaseInfo() {
    final dateFormat = DateFormat('MMM dd, yyyy');
    return Row(
      children: [
        Icon(Icons.calendar_today, size: 14.sp, color: AppColors.grey600),
        SizedBox(width: 4.w),
        Text(
          'Purchased: ${dateFormat.format(purchaseDate)}',
          style: AppTexts.bodySmall(color: AppColors.grey600),
        ),
      ],
    );
  }

  Widget _buildCreativeInfo() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            creative.format,
            style: AppTexts.bodySmall(color: AppColors.grey700),
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            '${creative.fileSizeMB} MB',
            style: AppTexts.bodySmall(color: AppColors.grey700),
          ),
        ),
        if (creative.width != null && creative.height != null) ...[
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              '${creative.width}x${creative.height}',
              style: AppTexts.bodySmall(color: AppColors.grey700),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: orderStatus == 'COMPLETED' ? onDownload : null,
            icon: Icon(Icons.download, size: 18.sp),
            label: Text('Download'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003D82),
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.grey300,
              disabledForegroundColor: AppColors.grey600,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 0,
            ),
          ),
        ),
        if (onViewDetails != null) ...[
          SizedBox(width: 12.w),
          OutlinedButton(
            onPressed: onViewDetails,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF003D82),
              side: BorderSide(color: const Color(0xFF003D82)),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text('Details'),
          ),
        ],
      ],
    );
  }

  Color _getStatusColor() {
    switch (orderStatus.toUpperCase()) {
      case 'COMPLETED':
        return Colors.green;
      case 'PENDING':
        return Colors.orange;
      case 'FAILED':
        return Colors.red;
      default:
        return AppColors.grey600;
    }
  }
}
