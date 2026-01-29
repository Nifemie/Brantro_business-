import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';

/// Vetting option card widget
class VettingCard extends StatelessWidget {
  final String title;
  final String description;
  final String duration;
  final String? useCase;
  final String price;
  final String status;
  final VoidCallback? onSelectTap;

  const VettingCard({
    super.key,
    required this.title,
    required this.description,
    required this.duration,
    this.useCase,
    required this.price,
    required this.status,
    this.onSelectTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTexts.h3(color: AppColors.textPrimary)
                      .copyWith(fontWeight: FontWeight.w700),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 12.w),
              _buildStatusBadge(),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Description
          Text(
            description,
            style: AppTexts.bodyMedium(color: AppColors.grey600),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          
          SizedBox(height: 12.h),
          
          // Duration
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16.sp,
                color: AppColors.grey600,
              ),
              SizedBox(width: 6.w),
              Text(
                duration,
                style: AppTexts.bodyMedium(color: AppColors.grey600),
              ),
            ],
          ),
          
          // Use Case (if provided)
          if (useCase != null && useCase!.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16.sp,
                    color: AppColors.grey600,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      useCase!,
                      style: AppTexts.bodySmall(color: AppColors.grey700),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          SizedBox(height: 20.h),
          
          // Price
          Text(
            price,
            style: AppTexts.h2(color: AppColors.textPrimary)
                .copyWith(fontWeight: FontWeight.w800),
          ),
          
          SizedBox(height: 16.h),
          
          // Select Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSelectTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003D82), // Deep blue
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'View Details',
                style: AppTexts.buttonMedium(color: Colors.white)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color badgeColor;
    Color textColor;
    
    switch (status.toLowerCase()) {
      case 'active':
        badgeColor = const Color(0xFF10B981); // Green
        textColor = Colors.white;
        break;
      case 'inactive':
        badgeColor = AppColors.grey400;
        textColor = Colors.white;
        break;
      case 'coming soon':
        badgeColor = AppColors.warning;
        textColor = Colors.white;
        break;
      default:
        badgeColor = AppColors.primaryColor;
        textColor = Colors.white;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        status,
        style: AppTexts.bodySmall(color: textColor)
            .copyWith(fontWeight: FontWeight.w600, fontSize: 11.sp),
      ),
    );
  }
}
